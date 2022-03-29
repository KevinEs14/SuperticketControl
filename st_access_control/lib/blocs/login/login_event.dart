part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final AuthenticationModel authentication;

  const LoginButtonPressed({
    @required this.authentication,
  });

  @override
  List<Object> get props => [authentication];

  @override
  String toString() =>
      'LoginButtonPressed {authentication:$authentication}';
}