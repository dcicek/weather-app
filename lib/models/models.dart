class WeatherModel{
  String city="";
  String cityStatus="";
  String cityWeather="";

  WeatherModel({required this.city, required this.cityStatus, required this.cityWeather });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      cityStatus: json['weather'][0]['description'],
      cityWeather: json['main']['temp'].toString(),
    );
  }
}