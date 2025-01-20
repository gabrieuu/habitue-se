abstract class Error {}

class Sucess implements Error {
  final String? message;

  Sucess({this.message});
}

class Failure implements Error {
  final String message;

  Failure(this.message);
}
