package com.novapay;

import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class PaymentControllerTest {

    private final PaymentController controller = new PaymentController();

    @Test
    void listPaymentsReturnsOkStatus() {
        Map<String, Object> response = controller.list();

        assertNotNull(response);
        assertEquals("ok", response.get("status"));
        assertEquals("novapay-payment", response.get("service"));
    }

    @Test
    void createPaymentWithBodyReturnsAcceptedPayment() {
        Map<String, Object> request = Map.of(
                "amount", 100,
                "currency", "INR"
        );

        Map<String, Object> response = controller.create(request);

        assertNotNull(response);
        assertEquals("accepted", response.get("status"));
        assertEquals(request, response.get("payment"));
    }

    @Test
    void createPaymentWithoutBodyReturnsEmptyPayment() {
        Map<String, Object> response = controller.create(null);

        assertNotNull(response);
        assertEquals("accepted", response.get("status"));
        assertEquals(Map.of(), response.get("payment"));
    }
}
