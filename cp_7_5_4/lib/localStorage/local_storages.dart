import 'package:shared_preferences/shared_preferences.dart';

// 5КТ
class UserStorage {
  UserStorage(this._prefs);

  final String _nameKey = 'user.lds.name.key';
  final String _ageKey = 'user.lds.age.key';
  final String _loginKey = 'user.lds.password.key';
  final String _passwordKey = 'user.lds.password.key';

  final SharedPreferences _prefs;

  // Запись данных
  Future<void> saveUserName(String value) => _prefs.setString(_nameKey, value);
  Future<void> saveUserAge(int value) => _prefs.setInt(_nameKey, value);
  Future<void> saveUserLogin(String value) =>
      _prefs.setString(_loginKey, value);
  Future<void> saveUserPassword(String value) =>
      _prefs.setString(_nameKey, value);

  //Удаление данных
  Future<void> removeUserName() => _prefs.remove(_nameKey);
  Future<void> removeUserAge() => _prefs.remove(_ageKey);
  Future<void> removeUserLogin() => _prefs.remove(_ageKey);
  Future<void> removeUserPassword() => _prefs.remove(_passwordKey);

  //Чтение данных
  String? getUserName() => _prefs.getString(_nameKey);
  int? getUserAge() => _prefs.getInt(_ageKey);

  //Проверка пароля
  bool checkUserPassword(String value) {
    return value == _prefs.getString(_passwordKey);
  }

  bool checkUserLogin(String value) {
    return value == _prefs.getString(_loginKey);
  }
}

//
class APIUsedCounter {
  APIUsedCounter(this._prefs);

  final String _counterKey = 'app.lds.counter.key';

  final SharedPreferences _prefs;

  // Запись данных
  Future<void> saveCounterValue(int value) => _prefs.setInt(_counterKey, value);

  // Чтение данных
  int? getCounterValue() => _prefs.getInt(_counterKey);
}
