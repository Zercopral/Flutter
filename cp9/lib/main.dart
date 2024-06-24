import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:provider/provider.dart';

// Модель
class DataModel {
  String data;

  DataModel(this.data);
}

// ViewModel
class DataViewModel extends ChangeNotifier {
  final DataModel _dataModel;

  DataViewModel(this._dataModel);

  String get data => _dataModel.data;

  // Метод для загрузки данных
  Future<void> fetchData() async {
    Dio dio = Dio();
    try {
      // Запрос к API
      final response = await dio.get(
          'https://api.open-meteo.com/v1/forecast?latitude=55.751244&longitude=37.618423&hourly=temperature_2m');
      if (response.statusCode == 200) {
        // Если сервер вернул ответ "ОК", обновляем данные
        _dataModel.data = response.data['hourly']['temperature_2m'][0];
      } else {
        // Если сервер не вернул ответ "ОК", используем запасные данные
        _dataModel.data = 'Ошибка загрузки данных';
      }
    } catch (e) {
      // Обработка исключений при запросе
      _dataModel.data = 'Ошибка сети';
    }
    notifyListeners();
  }
}

// View
class DataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = DataViewModel(DataModel('Исходные данные'));

    return ChangeNotifierProvider<DataViewModel>(
      create: (context) => viewModel,
      child: Consumer<DataViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(title: Text('MVVM на Flutter')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(model.data),
                  ElevatedButton(
                    onPressed: () => model.fetchData(),
                    child: Text('Загрузить данные'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: DataView()));
}
