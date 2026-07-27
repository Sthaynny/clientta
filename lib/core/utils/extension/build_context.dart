import 'package:university_hub/core/router/app_router.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Future<T?> go<T>(AppRouters routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushNamed<T>(routeName.path, arguments: arguments);
  }

  void back([Object? result]) => Navigator.of(this).pop(result);
}

extension BuildContextSnackBarExt on BuildContext {
  void showSnackBarInfo(String message, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(
        this,
      ).showSnackBar(DSSnackBar.info(message, action: action));

  void showSnackBarError(String message, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(
        this,
      ).showSnackBar(DSSnackBar.error(message, action: action));

  void showSnackBarSuccess(String message, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(
        this,
      ).showSnackBar(DSSnackBar.success(message, action: action));

  void showSnackBarWarning(String message, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(
        this,
      ).showSnackBar(DSSnackBar.warning(message, action: action));
}
