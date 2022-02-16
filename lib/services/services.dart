import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class ApiServices{

  Future<WeatherModel> makeList({city})
  async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q='+city+'&lang=tr&units=metric&appid=bceb49730d3de39d66f4b5219e717753');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  readJson() async {
    var response = await rootBundle.loadString('lib/assets/cities.json');

    Map<String, dynamic> map = await json.decode(response);

    return map["cities"];
  }

}