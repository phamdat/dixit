package com.bap.app.dixit.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.log4j.Logger;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public final class JsonUtils {

    private static final Logger log = Logger.getLogger(JsonUtils.class);

    private final static ObjectMapper objectMapper;
    static {
	objectMapper = new ObjectMapper();
	objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
	objectMapper.setSerializationInclusion(Include.NON_NULL);
	objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
	objectMapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
    }

    public static <T> T toObject(InputStream stream, Class<T> clazz) throws JsonParseException, JsonMappingException, IOException {
	return objectMapper.readValue(stream, clazz);
    }

    public static <T> T toObject(String json, Class<T> clazz) throws JsonParseException, JsonMappingException, IOException {
	return objectMapper.readValue(json, clazz);
    }

    public static <T> List<T> toList(InputStream stream, Class<T> clazz) throws JsonParseException, JsonMappingException, IOException {
	return objectMapper.readValue(stream, objectMapper.getTypeFactory().constructCollectionType(List.class, clazz));
    }

    public static <T> List<T> toList(String json, Class<T> clazz) throws JsonParseException, JsonMappingException, IOException {
	return objectMapper.readValue(json, objectMapper.getTypeFactory().constructCollectionType(List.class, clazz));
    }

    public static String toJson(Object o) {
	try {
	    return objectMapper.writeValueAsString(o);
	} catch (JsonProcessingException e) {
	    log.error(ExceptionUtils.getStackTrace(e));
	}
	return null;
    }
}
