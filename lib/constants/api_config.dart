class ApiConfig {
  // Development URL
  static const String _devBaseUrl = "http://192.168.68.100:5066";
  
  // Production URL (replace with your actual production URL)
  static const String _prodBaseUrl = "https://collabflow-api-dev-c32ae278ebe5.herokuapp.com";

  //https://collabflow-api-prod-315d413dccce.herokuapp.com
  
  /// Get the base URL based on the current environment
  static String get baseUrl {
    // Check if we're in debug mode (development)
    const bool isDebugMode = bool.fromEnvironment('dart.vm.product') == false;
    
    if (isDebugMode) {
      return _devBaseUrl;
    } else {
      return _prodBaseUrl;
    }
  }
  
  /// Get the development URL (for testing)
  static String get devUrl => _devBaseUrl;
  
  /// Get the production URL
  static String get prodUrl => _prodBaseUrl;
  
  /// Check if we're in development mode
  static bool get isDevelopment {
    return const bool.fromEnvironment('dart.vm.product') == false;
  }
  
  /// Check if we're in production mode
  static bool get isProduction {
    return const bool.fromEnvironment('dart.vm.product') == true;
  }
  
  /// Get current environment info for debugging
  static String get environmentInfo {
    return "Environment: ${isDevelopment ? 'Development' : 'Production'}, URL: $baseUrl";
  }
}
