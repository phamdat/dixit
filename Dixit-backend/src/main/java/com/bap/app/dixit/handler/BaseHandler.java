package com.bap.app.dixit.handler;

import java.lang.reflect.ParameterizedType;
import java.util.List;

import com.bap.app.dixit.dto.BaseRequest;
import com.bap.app.dixit.util.JsonUtils;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public abstract class BaseHandler<T extends BaseRequest> extends BaseClientRequestHandler {

	public void handleClientRequest(User sender, ISFSObject params) {
		try {
			T t = JsonUtils.toObject(params.getUtfString("request"), ((Class<T>) ((ParameterizedType) getClass().getGenericSuperclass())
					.getActualTypeArguments()[0]));
			execute(sender, t);
		} catch (Throwable e) {

		}
	}

	public abstract void execute(User sender, T t);

	@Override
	protected void send(String cmdName, ISFSObject params, List<User> recipients) {
		// TODO Auto-generated method stub
		super.send(cmdName, params, recipients);
	}
}
