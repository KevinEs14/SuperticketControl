import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AuthenticationModel extends Equatable {
  final String username;
  final String password;
  final bool rememberMe;

  AuthenticationModel({
    @required this.username,
    @required this.password,
    @required this.rememberMe,
  });

  const AuthenticationModel._({
    this.username,
    this.password,
    this.rememberMe,
  });

  const AuthenticationModel.newModel() : this._();

  @override
  List<Object> get props => [username, password, rememberMe];

  @override
  String toString() =>
      'AuthenticationModel {username:$username, password:$password, rememberMe:$rememberMe}';

  AuthenticationModel copyWith({
    String username,
    String password,
    bool rememberMe,
  }) {
    return AuthenticationModel(
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  static AuthenticationModel createNew({
    @required String username,
    @required String password,
  }) {
    return AuthenticationModel(
      username: username.trim(),
      password: password.trim(),
      rememberMe: false,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': this.username,
        'password': this.password,
        'rememberMe': this.rememberMe,
      };
}
