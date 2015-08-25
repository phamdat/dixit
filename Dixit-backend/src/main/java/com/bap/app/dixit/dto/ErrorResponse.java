package com.bap.app.dixit.dto;

public class ErrorResponse extends BaseDTO {

    private String errorCode;
    private String message;

    public ErrorResponse(String errorCode) {
	setErrorCode(errorCode);
    }

    public ErrorResponse(String errorCode, Throwable t) {
	setErrorCode(errorCode);
	setMessage(t.getMessage());
    }

    public String getErrorCode() {
	return errorCode;
    }

    public void setErrorCode(String errorCode) {
	this.errorCode = errorCode;
    }

    public String getMessage() {
	return message;
    }

    public void setMessage(String message) {
	this.message = message;
    }

}
