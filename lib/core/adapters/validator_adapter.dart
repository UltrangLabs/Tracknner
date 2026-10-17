import 'package:lucid_validation/lucid_validation.dart';

import '../errors/custom_error.dart';

class ValidatorAdapter<TExpectedEntity> {
  final LucidValidator<TExpectedEntity> _schemaValidator;

  const ValidatorAdapter(this._schemaValidator);

  TExpectedEntity validate(TExpectedEntity rawData) {
    final validationResult = _schemaValidator.validate(rawData);

    if (!validationResult.isValid) {
      final List<FormattedErrorResponse> formattedErrors = validationResult
          .exceptions
          .map((exception) => (message: exception.message, path: exception.key))
          .toList();

      throw CustomError.badRequest(
        payload: formattedErrors,
        path: "Validations",
      );
    }

    return rawData;
  }
}
