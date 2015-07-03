package com.bap.app.dixit;

import java.util.Map;
import java.util.Map.Entry;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.handler.Start;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.IClientRequestHandler;

public class Test {

    private ApplicationContext applicationContext;

    public void init() {
	applicationContext = new GenericXmlApplicationContext("classpath:context.xml");

	Map<String, IClientRequestHandler> handlers = applicationContext.getBeansOfType(IClientRequestHandler.class);
	for (Entry<String, IClientRequestHandler> entry : handlers.entrySet()) {
	    IClientRequestHandler handler = entry.getValue();
	    String cmd = getCmdHandler(handler);

	}
    }

    public String getCmdHandler(IClientRequestHandler handler) {
	RequestHandler annotation = handler.getClass().getAnnotation(RequestHandler.class);
	if (annotation != null) {
	    return annotation.value();
	}
	return handler.getClass().getSimpleName();
    }

    public static void main(String[] args) {
	Test dispatcher = new Test();
	dispatcher.init();
    }
}
