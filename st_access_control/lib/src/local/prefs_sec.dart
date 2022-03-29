import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:st_common/st_ac.dart';

class PrefsSec{

  static PrefsSec _instance = new PrefsSec.internal();

  PrefsSec.internal();

  factory PrefsSec() => _instance;

  FlutterSecureStorage _securePrefs = new FlutterSecureStorage();

  Future _addNewItem(String key, String value) async{
    _securePrefs.write(key: key, value: value);
    return true;
  }

  Future _getItem(String key) async {
    String item;
    try{
      item = await _securePrefs.read(key: key);
    }catch (e) {
      return null;
    }
    return item;
  }

  Future _remove(String key) async {
    final item = _getItem(key);
    if(item != null){
      _securePrefs.delete(key: key);
      return true;
    }
    return null;
  }

  Future clear()async {
    _securePrefs.deleteAll();
  }

  //
  //  Token
  //
  Future addUserToken(String value) async{
    if (SHOW_DETAIL_LOGS) {
      print('▮👉 SAVE TOKEN $value');
    }
    return await _addNewItem('token', value);
  }

  Future userToken() async {
    final token = await _getItem('token');
    if(token != null)
      return '$token';
    if (SHOW_DETAIL_LOGS) {
      print('▮👉 GET TOKEN $token');
    }
    return null;
  }

  Future removeUserToken() async {
    return await _remove('token');
  }

  //
  //  User
  //
  Future addUser(UserModel value) async{
    final String _user = jsonEncode(value.toJson());
    if (SHOW_DETAIL_LOGS) {
      print('▮👉 SAVE USER $_user');
    }
    await _addNewItem('user', _user);
    return;
  }

  Future<UserModel> user() async {
    final user = await _getItem('user');
    if(user != null)
      return UserModel.fromJson(jsonDecode(user));
    if (SHOW_DETAIL_LOGS) {
      print('▮👉 GET USER $user');
    }
    return null;
  }

  Future removeUser() async {
    if (SHOW_DETAIL_LOGS) {
      print('▮👉 REMOVE USER');
    }
    return await _remove('user');
  }
}

PrefsSec prefsSec = new PrefsSec();