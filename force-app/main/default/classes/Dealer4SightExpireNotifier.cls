global class Dealer4SightExpireNotifier implements Schedulable{
    global void execute(SchedulableContext SC) {
        
        //system.debug('Dealer4SightExpireProcessor is running');
        
        Dealer4SightExpireProcessor processor = new Dealer4SightExpireProcessor();
        database.executeBatch(processor, 100);      
    }
}