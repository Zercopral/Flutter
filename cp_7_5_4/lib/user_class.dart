import '../LocalStorage/local_storages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  static bool _authorized = false;
  static late UserStorage _userStorage;

  static late String name;
  static late int age;
  static late String login;
  static late String password;

  static void _setAuthorized() {
    _authorized = true;
  }

  static void setUnAuthorized() {
    _authorized = false;
  }

  static void initStorage() {
    SharedPreferences.getInstance().then((onValue) {
      UserStorage userStorage = UserStorage(onValue);
      _userStorage = userStorage;
    });
  }

  static bool Authorized() {
    return _authorized;
  }

  static bool LogedIn() {
    return (_userStorage.getUserName() == null) ? false : true;
  }

  static Future<void> createUser(
      String name, int age, String login, String password) async {
    _userStorage.saveUserName(name);
    _userStorage.saveUserAge(age);
    _userStorage.saveUserLogin(login);
    _userStorage.saveUserPassword(password);

    name = name;
    age = age;
    login = login;
    password = password;

    _setAuthorized();
  }
}
