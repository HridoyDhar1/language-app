class PaymentController {
  Future<bool> pay(double amount) async {
    // Simulate payment success
    await Future.delayed(Duration(seconds: 2));
    return true; // Always successful
  }
}
