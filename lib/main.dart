import 'dart:convert';

import 'package:dp_maker/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

List dataFrames = [];
List dataImages = [];

loader() async {
  String jsonString = await rootBundle.loadString('asset/json/frames.json');
  String jsonList =
      await rootBundle.loadString('asset/json/caption_images.json');

  var data = await json.decode(jsonString);
  var dataImg = await json.decode(jsonList);
  dataFrames = data['data'];
  dataImages = dataImg;

  // data.shuffle();
  // print(data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  await loader();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dp Generator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0099DD)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
