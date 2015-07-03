package com.bap.app.dixit;

import java.util.Map;
import java.util.Map.Entry;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

import com.bap.app.dixit.util.CommonUtils;
import com.smartfoxserver.v2.extensions.IClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class Dispatcher extends SFSExtension {

    private ApplicationContext applicationContext;

    public void init() {
	applicationContext = new GenericXmlApplicationContext("classpath:dixit-context.xml");

	Map<String, IClientRequestHandler> handlers = applicationContext.getBeansOfType(IClientRequestHandler.class);
	for (Entry<String, IClientRequestHandler> entry : handlers.entrySet()) {
	    IClientRequestHandler handler = entry.getValue();
	    String cmd = CommonUtils.getCmdHandler(handler);
	    addRequestHandler(cmd, handler);
	}
    }

}
