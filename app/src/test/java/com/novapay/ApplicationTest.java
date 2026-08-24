package com.novapay;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class ApplicationTest {

    @Test
    void contextLoads() {
    }

    @Test
    void applicationClassCanBeInstantiated() {
        Application application = new Application();
        assertNotNull(application);
    }
}
