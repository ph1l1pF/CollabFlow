

import 'package:flutter/services.dart';

class ApiConfig {
  static const String _devBaseUrl = "https://collabflow-api-dev-c32ae278ebe5.herokuapp.com";// "http://192.168.68.100:5066";
  
  static const String _prodBaseUrl = "https://collabflow-api-prod-315d413dccce.herokuapp.com";
  
  static Future<String> get baseUrl async {
    const bool isDebugMode = bool.fromEnvironment('dart.vm.product') == false;
    
    if (isDebugMode) {
      return Future.value(_devBaseUrl);
    } 

    final isFromAppStore = await _isFromAppStore();
    if (isFromAppStore) {
      return Future.value(_prodBaseUrl);
    } else {
      return Future.value(_devBaseUrl);
    }
  }

  static Future<bool> _isFromAppStore() async {
    final MethodChannel channel = const MethodChannel('store_checker');
    final String? sourceName = await channel.invokeMethod('getSource');
    return sourceName?.compareTo('AppStore') == 0;
  }
}