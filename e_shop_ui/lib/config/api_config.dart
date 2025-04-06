class ApiConfig {
  // Base URL for API calls
  static const String baseUrl = 'http://localhost:8080';

  // API Timeout in seconds
  static const int timeout = 30;

  // Default headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
