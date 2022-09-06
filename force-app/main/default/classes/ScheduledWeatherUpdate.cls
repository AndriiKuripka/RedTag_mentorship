public class ScheduledWeatherUpdate implements Schedulable{
    public void execute(SchedulableContext ctx) {
        
        BatchGetWeather myBatchObject = new BatchGetWeather();
        Database.executeBatch(myBatchObject, 100);
    }
}