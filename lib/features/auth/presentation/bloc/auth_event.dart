import 'package:equatable/equatable.dart';

sealed class MyFormEvent extends Equatable {
  const MyFormEvent();

  @override
  List<Object> get props => [];
}

final class EmailChanged extends MyFormEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

final class PasswordChanged extends MyFormEvent {
  const PasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

final class FormSubmitted extends MyFormEvent {}
