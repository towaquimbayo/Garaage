abstract class Failure {
  final String type;
  final String message;

  Failure(
    this.type,
    this.message,
  );
}

class ServerFailure extends Failure {
  ServerFailure(super.type, super.message);
}

class ClientFailure extends Failure {
  ClientFailure(super.type, super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.type, super.message);
}
