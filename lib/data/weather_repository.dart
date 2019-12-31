import 'dart:math';

import 'package:bloc_demo/data/model/Weather.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);

  Future<Weather> fetchDetailedWeather(String cityName);
}


class FakeWeatherRepository implements WeatherRepository {
  //缓存天气
  double cachedTempCelsius;

  @override
  Future<Weather> fetchWeather(String cityName) {
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();
      // 模拟网络出错
      if (random.nextBool()) {
        throw NetWorkError();
      }

      cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();

      return Weather(cityName: cityName, temperatureCelsius: cachedTempCelsius);
    });
  }

  @override
  Future<Weather> fetchDetailedWeather(String cityName) {
    return Future.delayed(Duration(seconds: 1), () {
      return Weather(
          cityName: cityName,
          temperatureCelsius: cachedTempCelsius,
          temperatureFahrenheit: cachedTempCelsius * 1.8 + 32);
    });
  }
}


class TrueWeatherRespository implements WeatherRepository {
  double cachedTempCelsius;

  @override
  Future<Weather> fetchDetailedWeather(String cityName) async {
    return Future.delayed(Duration(seconds: 1), () {
      return Weather(
          cityName: cityName,
          temperatureCelsius: cachedTempCelsius,
          temperatureFahrenheit: cachedTempCelsius * 1.8 + 32);
    });
  }

  @override
  Future<Weather> fetchWeather(String cityName) async {
    return getWeatherNyNet(cityName);
  }

  Future<Weather> getWeatherNyNet(String cityName) async {
    var response = await Dio().get(
        "http://apis.juhe.cn/simpleWeather/query?city= $cityName &key=928e5e885830d699bfbd07e76194e5fd");

    print(response);

    cachedTempCelsius = double.parse( response.data['result']['realtime']['temperature'] );

    return Weather(cityName: cityName, temperatureCelsius: cachedTempCelsius);
  }
}

class NetWorkError extends Error {}
