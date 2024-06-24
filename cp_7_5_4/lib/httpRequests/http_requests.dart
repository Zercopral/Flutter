import 'package:dio/dio.dart';

class WeatherAPI {
  static Dio dio = Dio();

  static const String _baseURL = "https://api.open-meteo.com/v1/forecast";
  static final Map<String, dynamic> _params = {
    "latitude": 55.751244,
    "longitude": 37.618423,
    "hourly": "temperature_2m",
    "forecast_days": 1
  };

  //Получение данных;
  static Future getTemperature() async {
    final res = await dio.get(_constructRequest());

    return res.data['hourly']['temperature_2m'][0];
  }

  //Конструирование ссылки
  static String _constructRequest() {
    double latitude = _params['latitude'];
    double longitude = _params['longitude'];
    String hourly = _params['hourly'];
    int forecastDays = _params['forecast_days'];

    String params =
        "latitude=$latitude&longitude=$longitude&hourly=$hourly&forecast_days=$forecastDays";

    return "$_baseURL?$params";
  }
}
