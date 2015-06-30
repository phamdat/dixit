package com.bap.app.dixit.dto;

public class BaseResponse {
	private boolean success;
	private String errorCode;

	public BaseResponse() {
		setSuccess(true);
	}

	public BaseResponse(String errorCode) {
		setSuccess(false);
		setErrorCode(errorCode);
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

}
