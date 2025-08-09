class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;
  final bool logError; // si necesitamos almacenar el error en un log, por ejemplo los no controlados para saber qué pasó
  // final int code;

  CustomError(
    this.message,
    // this.code
    [this.logError = false]
  );
}