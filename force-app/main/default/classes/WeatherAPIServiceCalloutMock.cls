@isTest
global class WeatherAPIServiceCalloutMock implements HttpCalloutMock{
    private Boolean isException;
    private HttpResponse response;

    global WeatherAPIServiceCalloutMock(Boolean isException){
        this.isException = isException;
        this.response = new HTTPResponse();
    }

    global void setHeader(String name, String value){
        response.setHeader(name, value);
    }

    global void setStatusCode(Integer statusCode){
        response.setStatusCode(statusCode);
    }

    global void setStatus(String status){
        response.setStatus(status);
    }

    global void setBody(String body){
        response.setBody(body);
    }

    global HTTPResponse respond(HttpRequest req){
        if (isException) {
            throw new CustomHTTPException('Error');
        }
        return response;
    }

    public class CustomHTTPException extends Exception{

    }

}