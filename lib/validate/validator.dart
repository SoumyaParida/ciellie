class Validator {
  static const MIN_USERNAME_LENGTH = 3;
  static const MAX_USERNAME_LENGTH = 15;

  static const MIN_PASSWORD_LENGTH = 8;
  static const MAX_PASSWORD_LENGTH = 20;

  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty)
      return "Username cannot be left blank!";
    username = username.trim();
    if (username.length < MIN_USERNAME_LENGTH)
      return "Username at least $MIN_USERNAME_LENGTH character must be.";
    if (username.length > MAX_USERNAME_LENGTH)
      return "User name $MAX_USERNAME_LENGTH should not be longer than one character.";
    if (username.contains(" ")) return "Username must not contain spaces!";
    final regex1 = RegExp(r"^(?=[_.]).+$");
    if (regex1.hasMatch(username))
      return "Username Can't start with underscore [_] or point [.]";
    final regex2 = RegExp(r"^[a-zA-Z0-9._]+$");
    if (!regex2.hasMatch(username))
      return "Username contains unacceptable characters!";
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty)
      return "Email address cannot be left blank!";
    email = email.trim();
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    if (!regex.hasMatch(email)) return "Email address is not valid!";
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return "Password cannot be left blank!";
    if (password.length < MIN_PASSWORD_LENGTH)
      return "Password is at least $MIN_PASSWORD_LENGTH character must be";
    if (password.length > MAX_PASSWORD_LENGTH)
      return "Password $MAX_PASSWORD_LENGTH should not be longer than one character.";
    final regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[\S]+$");
    if (!regex.hasMatch(password))
      return "Your password must contain one lowercase character, one uppercase character and one number!";
    return null;
  }

  static String? validatePasswordRepeat(
      String password, String? passwordRepeat) {
    if (passwordRepeat == null || passwordRepeat.isEmpty)
      return "Password cannot be left blank!";
    if (password != passwordRepeat) return "Passwords do not match!";
    return null;
  }
}
