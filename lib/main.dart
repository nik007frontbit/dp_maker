import 'dart:convert';

import 'package:dp_maker/screens/home.dart';
import 'package:dp_maker/utils/colors.dart';
import 'package:dp_maker/utils/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ads/ads_manager.dart';

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

  await MobileAds.instance.initialize();

  AdsManager.loadAppOpenAd();
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NativeAd? nativeAd;
  RxBool nativeAdIsLoaded = false.obs; //testing

  void loadNativeAd() {
    nativeAd = NativeAd(
        adUnitId: ApiUrl.nativeId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('👍👍👍👍👍$NativeAd loaded. 👍👍👍👍👍');
            nativeAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('🔔🔔🔔🔔$ad failed to load: $error🔔🔔🔔🔔');
            nativeAdIsLoaded.value = false;
            ad.dispose();
            nativeAd!.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling...
        nativeTemplateStyle: NativeTemplateStyle(
          callToActionTextStyle: NativeTemplateTextStyle(
            textColor: Colors.white,
            backgroundColor: AppColors.primary,
            style: NativeTemplateFontStyle.monospace,
            size: 16.0,
          ),
          // Required: Choose a template.
          templateType: TemplateType.medium,
        ))
      ..load();

    nativeAd!.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNativeAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Photo editor",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "asset/images/spalsh/spalsh_frame.jpg",
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => ShareData.shareApp(),
                  child: Image.asset(
                    "asset/images/spalsh/share.png",
                    height: MediaQuery.of(context).size.width * .18,
                    width: MediaQuery.of(context).size.width * .18,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(const HomePage()),
                  child: Image.asset(
                    "asset/images/spalsh/play.png",
                    height: MediaQuery.of(context).size.width * .18,
                    width: MediaQuery.of(context).size.width * .18,
                  ),
                ),
                GestureDetector(
                  onTap: () => ShareData.rateUS(),
                  child: Image.asset(
                    "asset/images/spalsh/rate.png",
                    height: MediaQuery.of(context).size.width * .18,
                    width: MediaQuery.of(context).size.width * .18,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse("http://1376.go.qureka.com")),
              child: Image.asset(
                "asset/images/spalsh/sponser.png",
                height: MediaQuery.of(context).size.width * .2,
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Obx(() {
              if (nativeAdIsLoaded.value) {
                return SizedBox(height: 350, child: AdWidget(ad: nativeAd!));
              } else {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('*Ad is not loaded yet.*')),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
