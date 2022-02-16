import 'package:flutter/material.dart';
import 'package:weather_app/services/services.dart';

import 'models/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color topColor=Colors.redAccent;
  Color bottomColor= Colors.deepPurpleAccent;
  ApiServices apiObj = new ApiServices();


  late Future<WeatherModel> weatherInf;
  Map<String, dynamic> map = new Map();
  List<String> cityList=[];

  String cityName="";

  cityListSet()
  async {

    var tempList = await apiObj.readJson();
    for(int i=0; i<tempList.length;i++)
      {
        cityList.add(tempList[i]["name"]);
      }

    setState(() {

    });
  }


  getWeather(String city)
  {
    setState(() {
      weatherInf = apiObj.makeList(city: city);
    });
  }

  getIcon(String weatherStatus)
  {
    if(weatherStatus == "açık")
      {
          topColor=Colors.deepOrangeAccent;
          bottomColor= Colors.yellowAccent;

        return Container(

          child: Text("☀️", style: TextStyle(fontSize: 50),),
        );
      }
    else if(weatherStatus == "parçalı bulutlu" || weatherStatus == "parçalı az bulutlu" || weatherStatus == "az bulutlu")
    {
        topColor=Colors.blue;
        bottomColor= Colors.lightBlueAccent;
      return Container(
        child: Text("☁️", style: TextStyle(fontSize: 50)),
      );
    }
    else if(weatherStatus == "kapalı")
    {
        topColor=Colors.white38;
        bottomColor= Colors.white10;
      return Container(
        child: Text("🌫️", style: TextStyle(fontSize: 50)),
      );
    }
    else if(weatherStatus == "sisli")
    {
        topColor=Colors.white10;
        bottomColor= Colors.brown;
      return Container(
        child: Text("🌁", style: TextStyle(fontSize: 50)),
      );
    }
    else
    {
      return Container(
        child: Text("❔", style: TextStyle(fontSize: 50)),
      );
    }
  }


  initState() {
    cityListSet();
    getWeather("edirne");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("WEATHER APP", style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 30
        ),),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.85,
          child: FutureBuilder<WeatherModel>(
            future: weatherInf,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text("🏙️ Şehir seçiniz:", style: TextStyle(fontSize: 30, color: Colors.white),),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 200, height: 30, color:Colors.white,margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Autocomplete<String>(
                              onSelected: (String option)
                                {
                                  getWeather(cityName);
                                },
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              cityName=textEditingValue.text;

                              if (textEditingValue.text == '') {
                                return const Iterable<String>.empty();
                              }
                              return cityList.where((String option) {

                                return option.contains(textEditingValue.text.toLowerCase());
                              });
                            },

                          ),),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container( margin: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Text(snapshot.data?.city ?? "BOŞ", style: TextStyle(color: Colors.white, fontSize: 25),)),
                            getIcon(snapshot.data?.cityStatus ?? "BOŞ"),

                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0),child: Text(snapshot.data?.cityWeather.toString() ?? "0.0", style: TextStyle(color: Colors.white, fontSize: 50)))
                        ],
                      )
                    ],
                  ),

                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [topColor, bottomColor])
                  ),


                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Container(child: Center(child: Text("Bilgi geliyor...", style: TextStyle(fontSize: 24),)));
    }

          ),
        ),
      ),

    );
  }
}
