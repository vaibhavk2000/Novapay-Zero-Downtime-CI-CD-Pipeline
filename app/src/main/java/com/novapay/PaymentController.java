package com.novapay;
import java.util.Map;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/v1/payments")
public class PaymentController {
  @GetMapping public Map<String,Object> list() {
    return Map.of("status","ok","service","novapay-payment");
  }
  @PostMapping public Map<String,Object> create(@RequestBody(required=false) Map<String,Object> body) {
    return Map.of("status","accepted","payment", body == null ? Map.of() : body);
  }
}
