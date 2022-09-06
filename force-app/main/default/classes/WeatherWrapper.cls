public with sharing class WeatherWrapper {
    public Coord coord = new Coord();
    public List<Weather> weather;
    public String base;
    public Main main = new Main();
    public Integer visibility;
    public Wind wind = new Wind();
    public Clouds clouds;
    public String dt;
    public Sys sys;
    public Integer timezone;
    public Integer id;
    public String name;
    public Integer cod;

    public class Weather {
        public Integer id;
        public String main;
        public String description;
        public String icon;
    }

    public class Coord {
        public Double lon;
        public Double lat;
    }

    public class Wind {
        public String speed;
        public Integer deg;
        public Double gust;
    }

    public class Clouds {
        public Integer all;
    }

    public class Sys {
        public String country;
        public Integer sunrise;
        public Integer sunset;
    }
    public class Main {
        public Double temp;
        public Double feels_like;
        public Double temp_min;
        public Double temp_max;
        public Integer humidity;
        public Integer pressure;
        public Integer sea_level;
        public Integer grnd_level;
    }

    public static WeatherWrapper parseJSON(String jsonString){
        return ((WeatherWrapper) System.JSON.deserialize(jsonString, WeatherWrapper.class));
    }

    public Weather__c parseToWeather(){
        Weather__c weather = new Weather__c(
            City_Name__c = name,
            Date__c = System.today(),
            Humidity__c = Main.humidity,
            Latitude__c = Coord.lat,
            Longitude__c = Coord.lon,
            Pressure__c = Main.pressure,
            Temp_Feels_Like__c = Main.feels_like,
            Weather_Description__c = weather[0].description,
            Main__c = weather[0].main,
            Temperature__c = Main.temp,
            Wind_Speed__c = Wind.speed
        );
        return weather;
    }
}