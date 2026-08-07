import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/app_snackbar.dart';

class NetworkHelper {
  /// Checks if device has active internet connectivity by performing a DNS lookup.
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Checks internet connectivity and shows SnackBar error if offline.
  /// Returns `true` if online, `false` if offline.
  static Future<bool> checkConnection(BuildContext context) async {
    final isOnline = await hasInternetConnection();
    if (!isOnline && context.mounted) {
      AppSnackBar.showNetworkError(context);
    }
    return isOnline;
  }
}
