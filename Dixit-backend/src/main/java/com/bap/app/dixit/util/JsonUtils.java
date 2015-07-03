package com.bap.app.dixit.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public final class JsonUtils {

    private final static ObjectMapper objectMapper;
    static {
	objectMapper = new ObjectMapper();
	objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
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

    public static String toJson(Object o) throws JsonProcessingException {
	return objectMapper.writeValueAsString(o);
    }
}
