import { LightningElement, track, api } from 'lwc';
import getDataLoaderProcedures from '@salesforce/apex/DataLoaderController.getDataLoaderProcedures';
import performDataLoadProcedure from '@salesforce/apex/DataLoaderController.performDataLoadProcedure';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import csvIcon from '@salesforce/resourceUrl/csvIcon';

export default class DataLoader extends LightningElement {
    @track csvList = [];
    @track currentIndex = 0;
    @track dataLoaderProceduresList = [];
    @track dataLoaderProcedures = new Map();
    @track dataLoaderProcedureNames = [];
    @track chosenDataLoaderProcedure = null;
    @api chosenDataLoaderProcedureName = null;
    @track dataLoadInProgress = false;
    @track lastDataLoadResult = new Map();
    @track lastDataLoadTables = [];
    csvImage = csvIcon + '/csvIcon/csvIcon.jpg';

    connectedCallback(){
        getDataLoaderProcedures().then(dataLoaderProcedures =>{
            this.dataLoaderProceduresList = dataLoaderProcedures;
            this.dataLoaderProcedureNames = this.dataLoaderProceduresList.map(procedure => {
                return {value:procedure.DeveloperName, label:procedure.Label};
            });
            dataLoaderProcedures.forEach(procedure => {
                this.dataLoaderProcedures.set(procedure.DeveloperName, procedure);
            });
            this.dataLoaderProcedures.set(null,null);
        });
    }

    handleProcedureSelected(event){
        if(event.target.value === this.chosenDataLoaderProcedureName){
            return;
        }
        this.lastDataLoadResult = new Map();
        this.lastDataLoadTables = [];
        this.dataLoadInProgress = false;
        this.csvList = [];
        this.currentIndex = 0;
        this.chosenDataLoaderProcedureName = event.target.value;
        this.chosenDataLoaderProcedure = this.dataLoaderProcedures.get(this.chosenDataLoaderProcedureName);
        if(this.chosenDataLoaderProcedure !== null){
            this.dataLoaderProcedureNames = [{value:null,label:"None"}, ...this.dataLoaderProcedureNames];
            this.chosenDataLoaderProcedure.CSVs_Required__c.split(',').forEach(csv => {
                const csvObject = {
                    name: csv,
                    uploadedFileName: csv,
                    required: csv.slice(-1) !== '*',
                    requiredClass: csv.slice(-1) !== '*' ? 'flexItemRequired' : 'flexItemOptional',
                    file: null
                };
                this.csvList.push(csvObject);
            });
        }else{
            this.dataLoaderProcedureNames = this.dataLoaderProceduresList.map(procedure => {
                return {value:procedure.DeveloperName, label:procedure.Label};
            });
        }
    }

    async handleFilesChange(event) {
        const files = event.target.files;
        const fileIndexes = Object.keys(files);
        const maxNumOfFiles = (this.csvList.length - this.currentIndex);
        if(fileIndexes.length > maxNumOfFiles){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Too Many Files Selected',
                message: 'Please try again with less than ' + maxNumOfFiles + ' files.',
                variant: 'error'
            }));
            return;
        }
        let incorrectFileType = false; 
        fileIndexes.forEach(index =>{
            const file = files[index];
            incorrectFileType = !file.name.endsWith('.csv') && !file.name.endsWith('.xls');
            console.log('checked ' + file.name + ' and got ' + incorrectFileType);
            if(incorrectFileType){
                return;
            }
        });
        if(incorrectFileType){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Incorrect File Types Selected',
                message: 'Please try again with a csv or xls file.',
                variant: 'error'
            }));
            return;
        }
        for(const index of fileIndexes){
            this.dataLoadInProgress = false;
            const file = files[index];
            this.csvList[this.currentIndex].file = await this.readFile(file);
            console.log(this.csvList[this.currentIndex].file);
            this.csvList[this.currentIndex].uploadedFileName = file.name;
            this.currentIndex += 1;
        }
    }

    readFile(fileToRead){
        return new Promise((resolve,reject) => {
            const reader = new FileReader();
            reader.onload = function() {
                resolve(reader.result);
            }
            reader.onerror = function() {
                reject(reader.error);
            }
            reader.readAsText(fileToRead);
        })
    }

    performDataLoad(event){
        this.dataLoadInProgress = true;
        const requiredFileMissing = this.csvList.filter(csv => csv.required && !csv.file).length > 0;
        if(requiredFileMissing){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Required File Missing',
                message: 'Please populate required file and try again.',
                variant: 'error'
            }));
            return;
        }
        performDataLoadProcedure({files:this.csvList,procedureName:this.chosenDataLoaderProcedureName})
        .then(result=>{
            const tempLastDataLoadResult = new Map(Object.entries(result.tableRows));
            for(const table of tempLastDataLoadResult.keys()){
                if(this.lastDataLoadResult.has(table)){
                    let currTable = this.lastDataLoadResult.get(table);
                    let tempTable = tempLastDataLoadResult.get(table);
                    let newTable = [...currTable, ...tempTable];
                    this.lastDataLoadResult.set(table, newTable);
                }else{
                    this.lastDataLoadResult.set(table, tempLastDataLoadResult.get(table));
                }
            }
            this.lastDataLoadTables = Object.entries(result.tableColumns).map(arrayRep => {
                return {
                    key: arrayRep[0],
                    value: arrayRep[1]
                }
            });
            if(result.isCsvRemaining){
                this.csvList = result.unprocessedCsvs;
                this.performDataLoad();
            }else{
                this.dataLoadInProgress = false;
            }
        }).catch(error =>{
            const errorMessage = error.body.message;
            console.log('ERROR: ' + errorMessage);
            console.log(JSON.stringify(error.body));
            this.dispatchEvent(new ShowToastEvent({
                title: 'Data Loader Error',
                message: errorMessage,
                variant: 'error',
                mode: 'sticky'
            }));
            this.dataLoadInProgress = false;
        });
    }

    get disablePerformDataLoad(){
        return !this.chosenDataLoaderProcedure || this.dataLoadInProgress || this.csvList.filter(csv => csv.required && !csv.file).length > 0;
    }
}