import 'package:dp_maker/screens/dp/dp_show.dart';
import 'package:dp_maker/screens/web_view/wa_launch.dart';
import 'package:dp_maker/utils/colors.dart';
import 'package:dp_maker/utils/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/ads_manager.dart';
import 'caption/caption_images.dart';
import 'genrate_link/generate_link.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text("Dp Maker",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            )),
        actions: [
          GestureDetector(
            onTap: () => launchUrl(Uri.parse("http://1376.go.qureka.com")),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                CupertinoIcons.gift_fill,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .05,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: pagesIcon(
                        height: MediaQuery.of(context).size.width * .4,
                        image: "asset/images/home/dp.png",
                        ontap: () => Get.to(const DpShowList())),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .03,
                  ),
                  Expanded(
                    child: pagesIcon(
                      height: MediaQuery.of(context).size.width * .4,
                      image: "asset/images/home/cap.png",
                      ontap: () => Get.to(const CaptionImagesShow()),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: pagesIcon(
                        height: MediaQuery.of(context).size.width * .3,
                        image: "asset/images/home/direct.png",
                        ontap: () => Get.to(GenerateLink(isDirect: true))),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .03,
                  ),
                  Expanded(
                    child: pagesIcon(
                      height: MediaQuery.of(context).size.width * .3,
                      image: "asset/images/home/genLink.png",
                      ontap: () => Get.to(GenerateLink(isDirect: false)),
                    ),
                  ),
                ],
              ),
              pagesIcon(
                ontap: () => Get.to(WebViewLoad(
                    title: "Whatsapp web", url: "https://web.whatsapp.com")),
                height: MediaQuery.of(context).size.width * .4,
                image: "asset/images/home/waWeb.png",
              ),
              Row(
                children: [
                  Expanded(
                    child: pagesIcon(
                      height: MediaQuery.of(context).size.width * .3,
                      image: "asset/images/home/rate.png",
                      ontap: () => ShareData.rateUS(),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .03,
                  ),
                  Expanded(
                    child: pagesIcon(
                      height: MediaQuery.of(context).size.width * .3,
                      image: "asset/images/home/share.png",
                      ontap: () => ShareData.shareApp(),
                    ),
                  ),
                ],
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
      ),
    );
  }

  pagesIcon({
    required double height,
    required String image,
    Function()? ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Image.asset(
        image,
        height: height,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
