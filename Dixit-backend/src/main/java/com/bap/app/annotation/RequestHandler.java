package com.bap.app.annotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

import org.springframework.stereotype.Service;

@Service
@Retention(RetentionPolicy.RUNTIME)
public @interface RequestHandler {
    String value();
}