part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final UserModel user;
  final AuthenticationStatusEnum status;

  const AuthenticationState._({
    this.user,
    this.status = AuthenticationStatusEnum.unauthenticated,
  });

  const AuthenticationState.unauthenticated() : this._();

  const AuthenticationState.authenticated(UserModel user)
      : this._(status: AuthenticationStatusEnum.authenticated, user: user);

  @override
  List<Object> get props => [status, user];

  // bool get isAdmin => user != null && user.role == Role.ROLE_ADMIN;

  @override
  String toString() => 'AuthenticationState {$status, $user}';
}
