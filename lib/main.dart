import 'package:bloc_demo/bloc/bloc.dart';
import 'package:bloc_demo/data/weather_repository.dart';
import 'package:bloc_demo/pages/weather_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Weather App",
      home: BlocProvider(
          builder: (context) => WeatherBloc(TrueWeatherRespository()),
          child: WeatherSearchPage()),
    );
  }
}
