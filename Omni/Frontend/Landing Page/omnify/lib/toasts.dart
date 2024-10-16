import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';

class Toasts {
  static void showSuccessToast(
      String title, String description, bool isDark, TextDirection dir) {
    toastification.show(
        direction: dir,
        alignment: Alignment.bottomCenter,
        title: Text(title),
        description: Text(description),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5));
  }

  static void showInfoToast(
      String title, String description, bool isDark, TextDirection dir) {
    toastification.show(
        alignment: Alignment.bottomCenter,
        direction: dir,
        title: Text(title),
        description: Text(description),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        type: ToastificationType.info,
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5));
  }

  static void showWarningToast(
      String title, String description, bool isDark, TextDirection dir) {
    toastification.show(
        alignment: Alignment.bottomCenter,
        direction: dir,
        title: Text(title),
        description: Text(description),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        type: ToastificationType.warning,
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5));
  }

  static void showErrorToast(
      String title, String description, bool isDark, TextDirection dir) {
    toastification.show(
        alignment: Alignment.bottomCenter,
        direction: dir,
        title: Text(title),
        description: Text(description),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 5));
  }

  static void showCustomToast(Widget icon, String title, String description,
      bool isDark, TextDirection dir) {
    toastification.show(
        alignment: Alignment.bottomCenter,
        direction: dir,
        title: Text(title),
        description: Text(description),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        icon: icon,
        type: ToastificationType.info,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 10));
  }
}
