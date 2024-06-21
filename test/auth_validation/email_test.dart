import 'package:auth_app/features/auth/presentation/models/Email.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Email Validation', () {
    test('Valid email should return null', () {
      var email = Email.dirty('test@example.com');
      expect(email.validator(email.value), isNull);
    });

    test('Invalid email should return EmailValidationError.invalid', () {
      var email = Email.dirty('invalid-email');
      expect(email.validator(email.value), equals(EmailValidationError.invalid));
    });

    test('Empty email should return EmailValidationError.invalid', () {
      var email = Email.dirty('');
      expect(email.validator(email.value), equals(EmailValidationError.invalid));
    });


    test('Whitespace email should return EmailValidationError.invalid', () {
      var email = Email.dirty(' ');
      expect(email.validator(email.value), equals(EmailValidationError.invalid));
    });

  });
}
