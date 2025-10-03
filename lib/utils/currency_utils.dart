import 'dart:ui';
import 'package:flutter/material.dart';

/// Utility class for handling currency symbols and formatting
/// based on the current locale
class CurrencyUtils {
  /// Get the currency symbol based on the current locale
  static String getCurrencySymbol() {
    final locale = PlatformDispatcher.instance.locale;
    
    // Map locale codes to currency symbols
    switch (locale.languageCode) {
      case 'de':
        return '€'; // Euro for German
      case 'en':
        // For English, check country code for more specific currency
        switch (locale.countryCode) {
          case 'US':
            return '\$'; // US Dollar
          case 'GB':
            return '£'; // British Pound
          case 'AU':
            return 'A\$'; // Australian Dollar
          case 'CA':
            return 'C\$'; // Canadian Dollar
          default:
            return '€'; // Default to Euro for other English locales
        }
      case 'fr':
        return '€'; // Euro for French
      case 'es':
        return '€'; // Euro for Spanish
      case 'it':
        return '€'; // Euro for Italian
      case 'pt':
        return '€'; // Euro for Portuguese
      case 'nl':
        return '€'; // Euro for Dutch
      case 'pl':
        return 'zł'; // Polish Zloty
      case 'cz':
        return 'Kč'; // Czech Koruna
      case 'hu':
        return 'Ft'; // Hungarian Forint
      case 'ru':
        return '₽'; // Russian Ruble
      case 'jp':
        return '¥'; // Japanese Yen
      case 'cn':
        return '¥'; // Chinese Yuan
      case 'kr':
        return '₩'; // South Korean Won
      case 'in':
        return '₹'; // Indian Rupee
      case 'br':
        return 'R\$'; // Brazilian Real
      case 'mx':
        return '\$'; // Mexican Peso
      default:
        return '€'; // Default to Euro for unknown locales
    }
  }
  
  /// Get the currency icon based on the current locale
  static IconData getCurrencyIcon() {
    final locale = PlatformDispatcher.instance.locale;
    
    // Map locale codes to currency icons
    switch (locale.languageCode) {
      case 'en':
        switch (locale.countryCode) {
          case 'US':
            return Icons.attach_money; // Dollar icon
          case 'GB':
            return Icons.currency_pound; // Pound icon
          default:
            return Icons.euro; // Default to Euro icon
        }
      case 'jp':
        return Icons.currency_yen; // Yen icon
      case 'cn':
        return Icons.currency_yen; // Yuan icon (same as yen)
      case 'kr':
        return Icons.currency_exchange; // Won icon
      case 'in':
        return Icons.currency_rupee; // Rupee icon
      default:
        return Icons.euro; // Default to Euro icon
    }
  }
  
  /// Format a number as currency with the appropriate symbol
  static String formatCurrency(double amount) {
    final symbol = getCurrencySymbol();
    return '$symbol ${amount.toStringAsFixed(2)}';
  }
}
