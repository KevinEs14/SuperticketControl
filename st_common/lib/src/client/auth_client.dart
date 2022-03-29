import 'package:meta/meta.dart';

import '../models/authentication_model.dart';
import 'api_client_rest.dart';
import '../models/user_model.dart';

class AuthClient {
  final ApiClient apiClient;

  AuthClient({@required this.apiClient});

  Future<String> toLogin(AuthenticationModel authentication) async {
    try {
      final response = await apiClient.post(authenticationUrl, authentication.toJson());
      return response['id_token'];
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> fetchAccount() async {
    try {
      final response = await apiClient.get(accountUrl);
      return UserModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
