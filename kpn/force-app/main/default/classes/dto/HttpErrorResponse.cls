public class HttpErrorResponse {
    public HttpErrorResponse(String message, String code, String traceId) {
        this.message = message;
        this.code = code;
        this.traceId = traceId;
    }

    public String message {get; private set;}

    public String code  {get; private set;}

    public String traceId {get; private set;}

    public override String toString() {
        String response;

        if(String.isNotBlank(this.traceId))
            response += 'trace-id: ' + traceId;

        if(String.isNotBlank(this.code))
            response += 'code: ' + code;
            
        return response + ' message: ' + this.message;
    }
}
