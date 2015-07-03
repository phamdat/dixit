package com.bap.app.dto;


public class ErrorResponse extends BaseResponse {

    private String errorCode;
    private String message;

    public ErrorResponse(String errorCode) {
	setSuccess(false);
	setErrorCode(errorCode);
    }

    public ErrorResponse(String errorCode, Throwable t) {
	setSuccess(false);
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
