package com.example.demo;

import org.springframework.web.bind.annotation.*;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@RestController
public class Application {

    @GetMapping("/")
    public String home() {
        return """
            <html>
            <head>
                <title>Service 1</title>
            </head>
            <body style="background-color:#2196F3; color:red; text-align:center; font-family:sans-serif;">
                <h1>Service 1 UPDATED </h1>
                <p>This is deployed via Docker + AWS Pipeline</p>
            </body>
            </html>
        """;
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
