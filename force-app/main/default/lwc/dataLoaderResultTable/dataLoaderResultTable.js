import { LightningElement, api, track } from 'lwc';

export default class DataLoaderResultTable extends LightningElement {
    @api tableRows = null;
    @api tableName = null;
    @api tableColumns = null;
    @track tableHtml = null;

    @track tableValues = null;
    @track finalColumns = [];
    @track baseUrl;

    connectedCallback(){
        this.baseUrl = window.location.origin + '/';
        const tempTableColumns = ['#', ...this.tableColumns];
        tempTableColumns.forEach(column => {
            this.finalColumns.push({
                name: column,
                isVisible: column !== '#'
            });
        });
        const tableValuesMapList = this.tableRows.get(this.tableName);
        let counter = 1;
        tableValuesMapList.forEach(rawRow => {
            const tempRow = [];
            let hasRow = false;
            this.finalColumns.forEach(oColumn => {
                const column = oColumn.name;
                if(column === '#'){
                    tempRow.push({isId:false, value:counter, urlValue:null});
                    counter+=1;
                    return;
                }
                if(rawRow.hasOwnProperty(column)){
                    hasRow = true;
                    const idColumn = column.includes('id') || column.includes('Id') || column.includes('ID');
                    tempRow.push({isId:idColumn, value:rawRow[column], urlValue:this.baseUrl+rawRow[column]});
                }else{
                    tempRow.push('');
                }
            });
            if(hasRow){
                if(this.tableValues === null){
                    this.tableValues = [];
                }
                this.tableValues.push(tempRow);
            }
        });
    }
}