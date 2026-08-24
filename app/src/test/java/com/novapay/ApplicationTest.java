package com.novapay;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ApplicationTest {

    @Test
    void contextLoads() {
        // Verifies that the Spring Boot application context starts successfully.
    }

    @Test
    void applicationClassCanBeInstantiated() {
        Application application = new Application();

        org.junit.jupiter.api.Assertions.assertNotNull(application);
    }
}
