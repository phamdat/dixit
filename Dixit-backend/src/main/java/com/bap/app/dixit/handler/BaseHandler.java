package com.bap.app.dixit.handler;

import java.io.IOException;
import java.lang.reflect.ParameterizedType;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.log4j.Logger;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.dto.BaseRequest;
import com.bap.app.dixit.dto.ErrorResponse;
import com.bap.app.dixit.dto.object.PlayerData;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.Constants;
import com.bap.app.dixit.util.JsonUtils;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.exceptions.SFSVariableException;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public abstract class BaseHandler<T extends BaseRequest> extends BaseClientRequestHandler {

    protected static final Logger log = Logger.getLogger(BaseHandler.class);

    public abstract void execute(User sender, T t, RoomData roomData) throws Exception;

    public void handleClientRequest(User sender, ISFSObject params) {
	RoomData rd = null;
	try {
	    rd = getRoomData(sender);
	    execute(sender, getRequest(params), rd);
	    updateRoomData(sender, rd);
	} catch (Throwable e) {
	    log.error(ExceptionUtils.getStackTrace(e));
	    send(new ErrorResponse(Constants.Error.INTERNAL_SERVER_ERROR, e), sender);
	}

	log.info("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		+ "\nREQUEST: " + getCmdHandler()
		+ "\nUSER: " + sender.toSFSArray().toJson()
		+ "\nROOM: " + JsonUtils.toJson(rd)
		+ "\nINPUT: " + params.toJson()
		+ "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    }

    protected void send(Object o, User recipient) {
	ISFSObject params = SFSObject.newInstance();
	try {
	    String cmd = getCmdHandler(o.getClass());
	    params.putUtfString("response", JsonUtils.toJson(o));
	    super.send(cmd, params, recipient);
	} catch (Throwable e) {
	    log.error(ExceptionUtils.getStackTrace(e));
	    if (!(o instanceof ErrorResponse)) {
		send(new ErrorResponse(Constants.Error.INTERNAL_SERVER_ERROR, e), recipient);
	    }
	}

	log.info("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		+ "\nRESPONSE: " + getCmdHandler(o.getClass())
		+ "\nUSER: " + recipient.toSFSArray().toJson()
		+ "\nOUTPUT: " + params.toJson()
		+ "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    }

    public String getCmdHandler() {
	return getCmdHandler(getRequestClass());
    }

    @SuppressWarnings("unchecked")
    private T getRequest(ISFSObject params) throws JsonParseException, JsonMappingException, IOException {
	return params.getUtfString("request") == null ? null :
		JsonUtils.toObject(params.getUtfString("request"), (Class<T>) getRequestClass());
    }

    private Class<?> getRequestClass() {
	return (Class<?>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
    }

    private String getCmdHandler(Class<?> clazz) {
	RequestHandler annotation = clazz.getAnnotation(RequestHandler.class);
	if (annotation != null) {
	    return annotation.value();
	}
	return clazz.getSimpleName();
    }

    private RoomData getRoomData(User sender) throws JsonParseException, JsonMappingException, IOException {
	RoomVariable rv = sender.getLastJoinedRoom().getVariable("all");
	RoomData rd = null;
	if (rv != null) {
	    rd = JsonUtils.toObject(rv.getStringValue(), RoomData.class);
	} else {
	    rd = new RoomData();
	    for (User player : sender.getLastJoinedRoom().getUserList()) {
		rd.getPlayers().put(player.getId(), new PlayerData());
	    }
	}
	return rd;
    }

    private void updateRoomData(User sender, RoomData rd) throws SFSVariableException, JsonProcessingException {
	SFSRoomVariable rv = new SFSRoomVariable("all", JsonUtils.toJson(rd));
	sender.getLastJoinedRoom().setVariable(rv);
    }
}
