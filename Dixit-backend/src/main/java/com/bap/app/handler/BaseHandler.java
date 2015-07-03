package com.bap.app.handler;

import java.io.IOException;
import java.lang.reflect.ParameterizedType;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.log4j.Logger;

import com.bap.app.dixit.Constants;
import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.JsonUtils;
import com.bap.app.dto.BaseRequest;
import com.bap.app.dto.BaseResponse;
import com.bap.app.dto.ErrorResponse;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public abstract class BaseHandler<T extends BaseRequest, L extends BaseResponse> extends BaseClientRequestHandler {

    protected static final Logger log = Logger.getLogger(BaseHandler.class);

    public void handleClientRequest(User sender, ISFSObject params) {
	log.info("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		+ "\nREQUEST: " + CommonUtils.getCmdHandler(this)
		+ "\nUSER: " + sender.toSFSArray().toJson()
		+ "\nINPUT: " + params.toJson()
		+ "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");

	try {
	    execute(sender, getRequest(params));
	} catch (Throwable e) {
	    log.error(ExceptionUtils.getStackTrace(e));
	    sendError(Constants.Error.INTERNAL_SERVER_ERROR, e, sender);
	}
    }

    public abstract void execute(User sender, T t) throws Exception;

    protected void send(L l, User recipient) {
	ISFSObject params = SFSObject.newInstance();
	try {
	    String cmd = CommonUtils.getCmdHandler(this);
	    params.putUtfString("response", JsonUtils.toJson(l));
	    super.send(cmd, params, recipient);
	} catch (Throwable e) {
	    log.error(ExceptionUtils.getStackTrace(e));
	    sendError(Constants.Error.INTERNAL_SERVER_ERROR, e, recipient);
	}

	log.info("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		+ "\nRESPONSE: " + CommonUtils.getCmdHandler(this)
		+ "\nUSER: " + recipient.toSFSArray().toJson()
		+ "\nOUTPUT: " + params.toJson()
		+ "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    }

    protected void sendError(String errorCode, User recipient) {
	sendError(errorCode, null, recipient);
    }

    protected void sendError(String errorCode, Throwable e, User recipient) {
	ISFSObject params = SFSObject.newInstance();
	try {
	    String cmd = getClass().getAnnotation(RequestHandler.class).value();
	    String response = JsonUtils.toJson(e == null ? new ErrorResponse(errorCode) : new ErrorResponse(errorCode, e));
	    params.putUtfString("response", response);
	    super.send(cmd, params, recipient);
	} catch (Throwable tr) {
	    log.error(ExceptionUtils.getStackTrace(e));
	}

	log.info("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		+ "\nRESPONSE-ERROR: " + CommonUtils.getCmdHandler(this)
		+ "\nUSER: " + recipient.toSFSArray().toJson()
		+ "\nOUTPUT: " + params.toJson()
		+ "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    }

    @SuppressWarnings("unchecked")
    private T getRequest(ISFSObject params) throws JsonParseException, JsonMappingException, IOException {
	return params.getUtfString("request") == null ? null :
		JsonUtils.toObject(params.getUtfString("request"), ((Class<T>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0]));
    }
}
