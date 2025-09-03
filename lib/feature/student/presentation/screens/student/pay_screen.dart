import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:languageapp/feature/teacher/data/models/teacher_model.dart';

// Mock Payment Service
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

// Custom input formatter for card number
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write(" ");
      }
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final String teacherName;
  final String day;
  final String time;
  final double amount;
  final Teacher? teacher;

  const PaymentScreen({
    super.key,
    required this.teacherName,
    required this.day,
    required this.time,
    required this.amount,
    this.teacher,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'credit_card';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  final Map<String, String> _fieldErrors = {};
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Teacher Name
                    _buildSummaryRow('Teacher', widget.teacherName),
                    const SizedBox(height: 8),
                    // Language (if teacher object is available)
                    if (widget.teacher != null)
                      Column(
                        children: [
                          _buildSummaryRow('Language', widget.teacher!.language),
                          const SizedBox(height: 8),
                        ],
                      ),
                    // Date and Time
                    _buildSummaryRow('Date', '${widget.day}, ${widget.time}'),
                    const SizedBox(height: 8),
                    // Price - Highlighted
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'BDT ${widget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment Method Selection
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(
              'credit_card',
              'Credit/Debit Card',
              Icons.credit_card,
            ),
            const SizedBox(height: 8),
            _buildPaymentMethodCard(
              'paypal',
              'PayPal',
              Icons.payment,
            ),
            const SizedBox(height: 8),
            _buildPaymentMethodCard(
              'bank_transfer',
              'Bank Transfer',
              Icons.account_balance,
            ),

            const SizedBox(height: 24),

            // Payment Form (only show for credit card)
            if (_selectedPaymentMethod == 'credit_card') ...[
              const Text(
                'Card Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.credit_card),
                  errorText: _fieldErrors['cardNumber'],
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
                  CardNumberFormatter(),
                ],
                onChanged: (_) {
                  if (_fieldErrors.containsKey('cardNumber')) {
                    setState(() {
                      _fieldErrors.remove('cardNumber');
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'MM/YY',
                        border: const OutlineInputBorder(),
                        errorText: _fieldErrors['expiry'],
                      ),
                      onChanged: (_) {
                        if (_fieldErrors.containsKey('expiry')) {
                          setState(() {
                            _fieldErrors.remove('expiry');
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: const OutlineInputBorder(),
                        errorText: _fieldErrors['cvv'],
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        if (_fieldErrors.containsKey('cvv')) {
                          setState(() {
                            _fieldErrors.remove('cvv');
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  border: const OutlineInputBorder(),
                  errorText: _fieldErrors['name'],
                ),
                onChanged: (_) {
                  if (_fieldErrors.containsKey('name')) {
                    setState(() {
                      _fieldErrors.remove('name');
                    });
                  }
                },
              ),
            ],

            const SizedBox(height: 32),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isProcessing ? null : () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(String value, String title, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
      ),
    );
  }

  void _processPayment() async {
    // Validate form if credit card is selected
    if (_selectedPaymentMethod == 'credit_card') {
      final errors = MockPaymentService().validateCardDetails(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        expiry: _expiryController.text,
        cvv: _cvvController.text,
        name: _nameController.text,
      );
      
      if (errors.isNotEmpty) {
        setState(() {
          _fieldErrors.clear();
          _fieldErrors.addAll(errors);
        });
        return;
      }
    }
    
    setState(() {
      _isProcessing = true;
      _fieldErrors.clear();
    });

    try {
      // Process payment with mock service
      final paymentResult = await MockPaymentService().processPayment(
        paymentMethod: _selectedPaymentMethod,
        amount: widget.amount,
        cardDetails: _selectedPaymentMethod == 'credit_card' ? {
          'cardNumber': _cardNumberController.text.replaceAll(' ', ''),
          'expiry': _expiryController.text,
          'cvv': _cvvController.text,
          'name': _nameController.text,
        } : null,
      );

      // Show result dialog
      _showPaymentResult(paymentResult);
    } catch (e) {
      // Show error dialog
      _showPaymentResult({
        'success': false,
        'message': 'An unexpected error occurred: $e',
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showPaymentResult(Map<String, dynamic> result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(result['success'] ? 'Success!' : 'Payment Failed'),
        icon: result['success'] 
            ? const Icon(Icons.check_circle, color: Colors.green, size: 48)
            : const Icon(Icons.error, color: Colors.red, size: 48),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result['message'],
              style: TextStyle(
                fontSize: 16,
                color: result['success'] ? Colors.green : Colors.red,
              ),
            ),
            if (result['success']) ...[
              const SizedBox(height: 16),
              Text('Transaction ID: ${result['transactionId']}'),
              Text('Amount: BDT ${result['amount']?.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              const Text(
                'Your lesson has been booked successfully!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ] else if (result['errorCode'] != null) ...[
              const SizedBox(height: 8),
              Text('Error code: ${result['errorCode']}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (result['success']) {
                Navigator.pop(context, true); // Return to previous screen with success
              }
            },
            child: Text(result['success'] ? 'Continue' : 'Try Again'),
          ),
        ],
      ),
    );
  }
}