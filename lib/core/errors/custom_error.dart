import 'codes_error.dart';

typedef FormattedErrorResponse = ({String message, String path});

class CustomError implements Exception {
  final int statusCode;
  final List<FormattedErrorResponse> errors;
  final String message;

  const CustomError._(this.statusCode, this.errors, this.message);

  @override
  String toString() => 'CustomError($statusCode): $message';

  factory CustomError.badRequest({
    required List<FormattedErrorResponse> payload,
    required String path,
  }) {
    final defaultMessage = payload.isNotEmpty
        ? payload.first.message
        : "An unexpected error occurred";

    return CustomError._(kErrorCodes.badRequest, payload, defaultMessage);
  }

  factory CustomError.unauthorized({
    String message = "No autorizado",
    required String path,
  }) {
    return CustomError._(kErrorCodes.unauthorized, [
      (message: message, path: path),
    ], message);
  }

  factory CustomError.forbidden({
    String message = "No autorizado",
    required String path,
  }) {
    return CustomError._(kErrorCodes.forbidden, [
      (message: message, path: path),
    ], message);
  }

  factory CustomError.notFound({
    String message = "No encontrado",
    required String path,
  }) {
    return CustomError._(kErrorCodes.notFound, [
      (message: message, path: path),
    ], message);
  }

  factory CustomError.conflict({
    String message = "Conflicto",
    required String path,
  }) {
    return CustomError._(kErrorCodes.conflict, [
      (message: message, path: path),
    ], message);
  }

  factory CustomError.internalServer({
    String message = "Error interno del servidor",
    String path = "desconocido",
  }) {
    return CustomError._(kErrorCodes.internalServer, [
      (message: message, path: path),
    ], message);
  }

  factory CustomError.serviceUnavailable({
    String message = "Servicio no disponible temporalmente",
    String path = "desconocido",
  }) {
    return CustomError._(kErrorCodes.serviceUnavailable, [
      (message: message, path: path),
    ], message);
  }
}
