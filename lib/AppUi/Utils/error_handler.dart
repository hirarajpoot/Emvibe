import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  /// Handle and display errors to the user
  static void handleError(dynamic error, {String? context}) {
    log('Error${context != null ? ' in $context' : ''}: $error');
    
    String errorMessage = _getUserFriendlyMessage(error);
    
    Get.snackbar(
      'Error',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  /// Handle network errors specifically
  static void handleNetworkError(dynamic error) {
    log('Network Error: $error');
    
    Get.snackbar(
      'Connection Error',
      'Please check your internet connection and try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
    );
  }

  /// Handle permission errors
  static void handlePermissionError(String permission) {
    log('Permission Error: $permission denied');
    
    Get.snackbar(
      'Permission Required',
      'Please grant $permission permission to use this feature.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber.shade600,
      colorText: Colors.black,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.security, color: Colors.black),
    );
  }

  /// Handle AI service errors
  static void handleAIServiceError(dynamic error) {
    log('AI Service Error: $error');
    
    Get.snackbar(
      'AI Service Unavailable',
      'The AI service is temporarily unavailable. Using fallback responses.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.smart_toy, color: Colors.white),
    );
  }

  /// Get user-friendly error message
  static String _getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network connection error. Please check your internet.';
    }
    
    if (errorString.contains('permission')) {
      return 'Permission denied. Please check app permissions.';
    }
    
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (errorString.contains('unauthorized') || errorString.contains('401')) {
      return 'Authentication failed. Please try again.';
    }
    
    if (errorString.contains('not found') || errorString.contains('404')) {
      return 'Service not found. Please try again later.';
    }
    
    if (errorString.contains('server') || errorString.contains('500')) {
      return 'Server error. Please try again later.';
    }
    
    return 'Something went wrong. Please try again.';
  }

  /// Show success message
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  /// Show info message
  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }
}

