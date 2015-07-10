package com.bap.app.dixit;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dixit.util.JsonUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
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

    public static void main(String[] args) throws JsonProcessingException {
	final File folder = new File("D:\\workspace\\dixit\\Dixit-document\\Dixit");
	listFilesForFolder(folder);
    }

    public static void listFilesForFolder(final File folder) throws JsonProcessingException {
	List<Card> l = new ArrayList<>();
	for (final File fileEntry : folder.listFiles()) {
	    if (fileEntry.isDirectory()) {
		listFilesForFolder(fileEntry);
	    } else {
		l.add(new Card(fileEntry.getName().replaceAll(".jpg", ""), "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/" + fileEntry.getName()));
	    }
	}
	System.out.println(JsonUtils.toJson(l));
    }

}
