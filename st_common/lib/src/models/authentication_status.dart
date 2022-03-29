import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum AuthenticationStatusEnum {authenticated, unauthenticated}

abstract class AuthenticationStatus extends Equatable {
  const AuthenticationStatus();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusAuthenticated extends AuthenticationStatus {
  final String token;

  const AuthenticationStatusAuthenticated({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'ASAuthenticated {token:$token}';
}

class AuthenticationStatusUnauthenticated extends AuthenticationStatus {}
