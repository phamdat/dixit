package com.bap.app.dixit;

import java.util.Map;
import java.util.Map.Entry;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

import com.bap.app.dixit.handler.BaseHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class Dispatcher extends SFSExtension {

    private ApplicationContext applicationContext;

    public void init() {
	applicationContext = new GenericXmlApplicationContext("classpath:dixit-context.xml");

	Map<String, BaseHandler> handlers = applicationContext.getBeansOfType(BaseHandler.class);
	for (Entry<String, BaseHandler> entry : handlers.entrySet()) {
	    BaseHandler handler = entry.getValue();
	    String cmd = handler.getCmdHandler();
	    addRequestHandler(cmd, handler);
	}
    }

}
