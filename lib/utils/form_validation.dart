// part of 'utils.dart';

bool isValidEmail(String? email) {
  if (email == null) return false;
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

String? validateString({
  required String? value,
  required String name,
  int minLength = 0,
  int? maxLength,
  bool allowUppercase = false,
  bool allowLowercase = false,
  bool allowDigit = false,
  bool allowSpecial = false,
  bool denyUppercase = false,
  bool denyLowercase = false,
  bool denyDigit = false,
  bool denySpecial = false,
}) {
  if (value == null || value.isEmpty) return "$name is required";

  if (denyUppercase && value.contains(RegExp(r'[A-Z]'))) {
    return "$name must not contain an uppercase letter";
  }
  if (allowUppercase && !value.contains(RegExp(r'[A-Z]'))) {
    return "$name must contain at least one uppercase letter";
  }

  if (denyLowercase && value.contains(RegExp(r'[a-z]'))) {
    return "$name must not contain a lowercase letter";
  }
  if (allowLowercase && !value.contains(RegExp(r'[a-z]'))) {
    return "$name must contain at least one lowercase letter";
  }

  if (allowDigit && !value.contains(RegExp(r'(\d)'))) {
    return "$name must contain at least one digit";
  }

  if (allowSpecial && !value.contains(RegExp(r'(\W)'))) {
    return "$name must contain at least one special character (*&%!@#)";
  }

  if (value.length <= minLength) {
    return "$name must be more than $minLength characters";
  }

  if (maxLength != null && value.length > maxLength) {
    return "$name cannot be more than $maxLength characters";
  }
  return null;
}

String userInitials(String? name) {
  try {
    if (name == null || (name.isEmpty)) return "";
    String result = "";
    final chunks = name.split(" ");
    if (chunks.isEmpty) return name;
    result = chunks.first.split("").first;

    if (chunks.length > 1) {
      final next = chunks[1].split("");
      if (next.isNotEmpty) result += next.first;
    }
    return result;
  } catch (e) {
    return "";
  }
}
