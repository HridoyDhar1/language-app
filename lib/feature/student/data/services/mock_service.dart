// services/mock_payment_service.dart
import 'dart:math';

class MockPaymentService {
  static final MockPaymentService _instance = MockPaymentService._internal();
  factory MockPaymentService() => _instance;
  MockPaymentService._internal();

  // Simulate payment processing with a mock API
  Future<Map<String, dynamic>> processPayment({
    required String paymentMethod,
    required double amount,
    Map<String, dynamic>? cardDetails,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate random success/failure (80% success rate)
    final random = Random().nextDouble();
    final bool isSuccess = random > 0.2;

    if (isSuccess) {
      return {
        'success': true,
        'message': 'Payment successful!',
        'transactionId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
        'amount': amount,
        'timestamp': DateTime.now().toString(),
      };
    } else {
      return {
        'success': false,
        'message': _getRandomErrorMessage(),
        'errorCode': 'ERR${Random().nextInt(1000)}',
      };
    }
  }

  String _getRandomErrorMessage() {
    final errors = [
      'Insufficient funds',
      'Card declined',
      'Invalid card details',
      'Transaction timeout',
      'Bank connection failed',
    ];
    return errors[Random().nextInt(errors.length)];
  }

  // Validate card details (simple validation)
  Map<String, String> validateCardDetails({
    required String cardNumber,
    required String expiry,
    required String cvv,
    required String name,
  }) {
    final errors = <String, String>{};

    // Validate card number (simple check for 16 digits)
    if (cardNumber.isEmpty || cardNumber.replaceAll(' ', '').length != 16) {
      errors['cardNumber'] = 'Enter a valid 16-digit card number';
    }

    // Validate expiry date (MM/YY format)
    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');
    if (!expiryRegex.hasMatch(expiry)) {
      errors['expiry'] = 'Enter valid expiry date (MM/YY)';
    }

    // Validate CVV (3 or 4 digits)
    if (cvv.isEmpty || !(cvv.length == 3 || cvv.length == 4)) {
      errors['cvv'] = 'Enter a valid CVV';
    }

    // Validate name
    if (name.isEmpty) {
      errors['name'] = 'Enter cardholder name';
    }

    return errors;
  }
}