# Test and Validation Evidence

## Automated tests
The project contains:
- `ApplicationTest.java`
- `PaymentControllerTest.java`

Run locally from `app/`:

```bash
gradle clean test jacocoTestReport jacocoTestCoverageVerification
```

## Expected controls
- Tests must pass.
- JaCoCo line coverage threshold: 80%.
- JaCoCo branch coverage threshold: 70%.

Attach CI run links or exported reports here when available.
