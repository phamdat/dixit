package com.bap.app.dixit.util;

import com.bap.app.dixit.annotation.RequestHandler;
import com.smartfoxserver.v2.extensions.IClientRequestHandler;

public final class CommonUtils {

    public static String getCmdHandler(IClientRequestHandler handler) {
	RequestHandler annotation = handler.getClass().getAnnotation(RequestHandler.class);
	if (annotation != null) {
	    return annotation.value();
	}
	return handler.getClass().getSimpleName();
    }
}
