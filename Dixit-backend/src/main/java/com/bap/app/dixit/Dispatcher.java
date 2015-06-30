package com.bap.app.dixit;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

import com.bap.app.dixit.handler.Start;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class Dispatcher extends SFSExtension {

	private ApplicationContext applicationContext;

	public void init() {
		applicationContext = new GenericXmlApplicationContext("classpath:context.xml");

		addRequestHandler(Constants.RequestHandler.START, applicationContext.getBean(Start.class));
	}

}
