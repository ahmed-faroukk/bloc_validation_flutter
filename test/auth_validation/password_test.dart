import 'package:auth_app/features/auth/presentation/models/Password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

void main() {
  group('Password Validation', () {

    test('Valid password should return null', () {
      var password = Password.dirty('Password1');
      expect(password.validator(password.value), isNull);
    });

    test('Password without digit should return PasswordValidationError.invalid', () {
      var password = Password.dirty('Password');
      expect(password.validator(password.value), equals(PasswordValidationError.invalid));
    });

    test('Password without letter should return PasswordValidationError.invalid', () {
      var password = Password.dirty('12345678');
      expect(password.validator(password.value), equals(PasswordValidationError.invalid));
    });

    test('Short password should return PasswordValidationError.invalid', () {
      var password = Password.dirty('Short1');
      expect(password.validator(password.value), equals(PasswordValidationError.invalid));
    });

    test('Empty password should return PasswordValidationError.invalid', () {
      var password = Password.dirty('');
      expect(password.validator(password.value), equals(PasswordValidationError.invalid));
    });

    test('Whitespace password should return PasswordValidationError.invalid', () {
      var password = Password.dirty('   ');
      expect(password.validator(password.value), equals(PasswordValidationError.invalid));
    });

  });
}
