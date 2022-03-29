import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_common/st_ac.dart';

import '../../../blocs/login/form/login_form_bloc.dart';
import '../../../blocs/login/login_bloc.dart';
import '../../values/values.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginFormBloc, LoginFormState>(
      listenWhen: (previous, current) => current.status != previous.status,
      listener: (context, state){
        if(state.status == MyFormStatus.FORM_SUCCESS) {
          BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
              authentication: AuthenticationModel.createNew(
                username: state.authentication.username,
                password: state.authentication.password,
              )));
        }
      },
      buildWhen: (previous, current) => current.status != previous.status,
      builder: (context, state) {
        return Form(
          key: _formKey,
          autovalidateMode: state.autoValidate ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildFailure(),
              _buildInputEmail(),
              _buildPassword(),
              _buildButton(),
            ],
          ),
        );
      },
    );
  }

  BlocBuilder _buildFailure() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginFailure) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimens.normal),
            child: Center(
              child: Text(
                state.error,
                style: TextStyle(fontSize: 12.0, color: Theme.of(context).errorColor),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  BlocBuilder _buildInputEmail() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      buildWhen: (previous, current) =>
      current.authentication.username != previous.authentication.username ||
          current.status != previous.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimens.normal),
          child: TextFormField(
            enabled: !state.disabledWidgets,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            initialValue: state.authentication.username ?? '',
            validator: Validator.username,
            inputFormatters: [LengthLimitingTextInputFormatter(36)],
            decoration: InputDecoration(
              labelText: Strings.username,
              errorText: state.status == MyFormStatus.FORM_FAILURE ? state.isValidUsername : null,
            ),
            onChanged: (String text) {
              BlocProvider.of<LoginFormBloc>(context).add(LoginFormUpdateData(
                value: text,
                typeData: LoginFormData.USERNAME,
              ));
            },
          ),
        );
      },
    );
  }

  BlocBuilder _buildPassword() {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      buildWhen: (previous, current) =>
      current.authentication.password != previous.authentication.password ||
          current.showPassword != previous.showPassword ||
          current.status != previous.status,
      builder: (context, state) {

        return Padding(
          padding: const EdgeInsets.only(bottom: Dimens.normal),
          child: TextFormField(
            obscureText: !state.showPassword,
            enabled: !state.disabledWidgets,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            initialValue: state.authentication.password ?? '',
            validator: Validator.password,
            inputFormatters: [LengthLimitingTextInputFormatter(36)],
            decoration: InputDecoration(
              labelText: Strings.password,
              errorText: state.status == MyFormStatus.FORM_FAILURE
                  ? state.isValidPassword
                  : null,
              suffixIcon: IconButton(
                icon: Icon(state.showPassword ? Icons.visibility_off_rounded : Icons.visibility),
                onPressed: () {
                  BlocProvider.of<LoginFormBloc>(context).add(LoginFormUpdateData(
                    value: !state.showPassword,
                    typeData: LoginFormData.SHOW_PASSWORD,
                  ));
                },
              ),
            ),
            onChanged: (String text) {
              BlocProvider.of<LoginFormBloc>(context).add(LoginFormUpdateData(
                value: text,
                typeData: LoginFormData.PASSWORD,
              ));
            },
            onEditingComplete: () {
              if (!state.disabledWidgets) {
                _onPressedLoginButton(context);
              }
            },
          ),
        );
      },
    );
  }

  BlocConsumer _buildButton() {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state){
        if(state is LoginInProgress) {
          BlocProvider.of<LoginFormBloc>(context).add(LoginFormUpdateData(value: MyFormStatus.IN_PROGRESS, typeData: LoginFormData.STATUS));
        }

        if(state is LoginFailure) {
          BlocProvider.of<LoginFormBloc>(context).add(LoginFormUpdateData(value: MyFormStatus.FAILURE, typeData: LoginFormData.STATUS));
        }

        if(state is LoginSuccess) {
          BlocProvider.of<LoginFormBloc>(context).add(LoginFormUpdateData(value: MyFormStatus.SUCCESS, typeData: LoginFormData.STATUS));
          // Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is LoginInProgress) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is LoginSuccess) {
          return Column(
            children: [
              Icon(Icons.check, color: colorSuccess),
              Text('Espere por favor...'),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: Dimens.normal),
          child: RaisedButton(
            child: Text(Strings.login.toUpperCase()),
            onPressed: () => _onPressedLoginButton(context),
          ),
        );
      },
    );
  }

  bool _validate() {
    bool _isValid = true;

    /// Validate form inputs
    if (!_formKey.currentState.validate()) {
      _isValid = false;
    }

    return _isValid;
  }

  _onPressedLoginButton(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_validate()) {
      //_formKey.currentState.save();
      BlocProvider.of<LoginFormBloc>(context).add(LoginFormValidate());
    }
  }
}