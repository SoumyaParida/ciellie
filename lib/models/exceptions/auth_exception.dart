import 'package:Ciellie/models/exceptions/base_exception.dart';

abstract class AuthException implements BaseException {
  static AuthException get emailAlreadyInUse => EmailAlreadyInUseException();

  static AuthException get usernameAlreadyInUse => UsernameAlreadyInUseException();

  static AuthException get weakPassword => WeakPasswordException();

  static AuthException get userNotFound => UserNotFoundException();

  static AuthException get wrongPassword => WrongPasswordException();

  static AuthException get tooManyRequests => TooManyRequestsException();
}

class EmailAlreadyInUseException implements AuthException {
  const EmailAlreadyInUseException._();

  factory EmailAlreadyInUseException() => const EmailAlreadyInUseException._();

  @override
  String get errorMessage => "There is an account registered to your e-mail address!";
}

class UsernameAlreadyInUseException implements AuthException {
  const UsernameAlreadyInUseException._();

  factory UsernameAlreadyInUseException() => const UsernameAlreadyInUseException._();

  @override
  String get errorMessage => "There is an account registered to the username!";
}

class WeakPasswordException implements AuthException {
  const WeakPasswordException._();

  factory WeakPasswordException() => const WeakPasswordException._();

  @override
  String get errorMessage => "Password too weak!";
}

class UserNotFoundException implements AuthException {
  const UserNotFoundException._();

  factory UserNotFoundException() => const UserNotFoundException._();

  @override
  String get errorMessage => "User not found";
}

class WrongPasswordException implements AuthException {
  const WrongPasswordException._();

  factory WrongPasswordException() => const WrongPasswordException._();

  @override
  String get errorMessage => "Wrong password!";
}

class TooManyRequestsException implements AuthException {
  const TooManyRequestsException._();

  factory TooManyRequestsException() => const TooManyRequestsException._();

  @override
  String get errorMessage => "Too many requests have been made to this account!";
}
