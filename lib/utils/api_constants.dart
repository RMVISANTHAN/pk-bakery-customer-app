/// Update `baseUrl` to point at your deployed backend (see backend/.env and
/// docs/INSTALLATION_GUIDE.md). Use 10.0.2.2 instead of localhost when
/// testing against a local server from the Android emulator.
class ApiConstants {
  static const String baseUrl = 'https://pk-bakery-backend.onrender.com/api';
  // static const String baseUrl = 'http://10.0.2.2:5000/api'; // local dev (Android emulator)

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleAuth = '/auth/google';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String me = '/auth/me';

  static const String products = '/products';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String myOrders = '/orders/my';
  static const String reviews = '/reviews';
  static const String coupons = '/coupons';
  static const String razorpayOrder = '/payments/razorpay/order';
  static const String razorpayVerify = '/payments/razorpay/verify';
  static const String registerFcmToken = '/notifications/register-token';
}
