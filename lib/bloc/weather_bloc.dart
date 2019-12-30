import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_demo/data/weather_repository.dart';
import 'bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository);

  @override
  WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    yield WeatherLoading();

    if (event is GetWeather) {
      try {
        print('============= ${this.weatherRepository is FakeWeatherRepository}');

        final weather = await weatherRepository.fetchWeather(event.cityName);
        print(weather);
        yield WeatherLoaded(weather);
      } on NetWorkError {
        yield WeatherError('Couldn`t fecth weather .is the device online?');
      }
    } else if (event is GetDetailWeather) {
      try {
        final weather =
            await weatherRepository.fetchDetailedWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetWorkError {
        yield WeatherError('Couldn`t fecth weather .is the device online?');
      }
    }
  }
}
