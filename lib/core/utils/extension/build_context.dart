import 'package:clientta/core/router/app_router.dart';
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
      ScaffoldMessenger.of(this).showSnackBar(
        DSSnackBar(
          context: this,
          content: Text(message),
          type: DSSnackBarType.info,
          onPressed: action?.onPressed,
          actionLabel: action?.label,
        ),
      );

  void showSnackBarError(String message, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(this).showSnackBar(
        DSSnackBar(
          context: this,
          content: Text(message),
          type: DSSnackBarType.error,
          onPressed: action?.onPressed,
          actionLabel: action?.label,
        ),
      );

  void showSnackBarSuccess(String message, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(this).showSnackBar(
        DSSnackBar(
          context: this,
          content: Text(message),
          type: DSSnackBarType.positive,
          onPressed: action?.onPressed,
          actionLabel: action?.label,
        ),
      );

  void showSnackBarWarning(String message, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(this).showSnackBar(
        DSSnackBar(
          context: this,
          content: Text(message),
          type: DSSnackBarType.warning,
          onPressed: action?.onPressed,
          actionLabel: action?.label,
        ),
      );
}
