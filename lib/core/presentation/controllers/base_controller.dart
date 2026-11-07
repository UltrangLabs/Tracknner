import 'package:flutter/foundation.dart';

import '../../domain/errors/codes_error.dart';
import '../../domain/errors/custom_error.dart';

typedef ValidationErrorMap = Map<String, String>;

abstract class BaseController<T> extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  T? _data;

  final ValidationErrorMap _validationErrors = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  T? get data => _data;

  ValidationErrorMap get validationErrors =>
      Map.unmodifiable(_validationErrors);

  @protected
  void setLoading({required bool isLoading}) {
    _isLoading = isLoading;
    notifyListeners();
  }

  @protected
  void setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  @protected
  void setData(T data) {
    _data = data;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearFieldError(String path) {
    if (_validationErrors.containsKey(path)) {
      _validationErrors.remove(path);
      notifyListeners();
    }
  }

  void clearValidationErrors() {
    if (_validationErrors.isNotEmpty) {
      _validationErrors.clear();
      notifyListeners();
    }
  }

  @protected
  Future<void> executeUseCase(Future<void> Function() action) async {
    setLoading(isLoading: true);
    _validationErrors.clear();
    _errorMessage = null;

    try {
      await action();
    } on CustomError catch (error) {
      if (error.statusCode == kErrorCodes.badRequest &&
          error.errors.isNotEmpty) {
        for (final errorRecord in error.errors) {
          if (errorRecord.path.isNotEmpty) {
            _validationErrors[errorRecord.path] = errorRecord.message;
          }
        }
        if (_validationErrors.isNotEmpty) {
          setLoading(isLoading: false);
        } else {
          setError(error.message);
        }
      } else {
        setError(error.message);
      }
    } catch (e) {
      setError(e.toString());
    }
  }
}
