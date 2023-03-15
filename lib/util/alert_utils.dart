import 'package:flutter/cupertino.dart';
import 'package:Ciellie/models/exceptions/base_exception.dart';
import 'package:Ciellie/models/result.dart';
import 'snackbar_utils.dart';

extension AlertExtension on BuildContext {
  void alertError(Result error) {
    final exception = (error as Error).exception;
    final errorMessage = exception is BaseException
        ? exception.errorMessage
        : "An error has been encountered.";//exception.toString();
    snackbar(errorMessage);
  }
}