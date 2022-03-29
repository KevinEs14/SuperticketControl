part of 'login_form_bloc.dart';

class LoginFormState extends Equatable {
  final MyFormStatus status;
  final AuthenticationModel authentication;
  final bool showPassword;

  LoginFormState({
    @required this.status,
    @required this.authentication,
    @required this.showPassword,
  });

  @override
  List<Object> get props => [status, authentication, showPassword];

  @override
  String toString() => 'LoginFormState {status:$status, $authentication, $showPassword}';

  LoginFormState copyWith({
    MyFormStatus status,
    AuthenticationModel authentication,
    bool showPassword,
  }) {
    return LoginFormState(
      status: status ?? this.status,
      authentication: authentication ?? this.authentication,
      showPassword: showPassword ?? this.showPassword,
    );
  }

  static LoginFormState initial (AuthenticationModel authentication) {
    return LoginFormState(
      status: MyFormStatus.INITIAL,
      authentication: authentication,
      showPassword: false,
    );
  }
  bool get autoValidate => this.status == MyFormStatus.INITIAL;

  bool get disabledWidgets => this.status == MyFormStatus.IN_PROGRESS || this.status == MyFormStatus.SUCCESS;


  String get isValidUsername => this.authentication?.username == null || this.authentication.username.isEmpty
      ? 'Por favor ingrese el nombre de usuario'
      : null;

  String get isValidPassword => this.authentication?.password == null || this.authentication.password.isEmpty
          ? 'Por favor ingrese el password'
          : null;

}
