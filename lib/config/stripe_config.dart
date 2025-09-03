class StripeConfig {
  static const String publishableKey = 'pk_test_your_publishable_key_here';
  static const String secretKey = 'sk_test_your_secret_key_here';
  static const String stripeApiUrl = 'https://api.stripe.com/v1';
  
  // For testing purposes - you can use these test card numbers:
  static const Map<String, String> testCards = {
    'Success': '4242424242424242',
    'Fail': '4000000000000002',
    'Requires Auth': '4000002500003155',
  };
}