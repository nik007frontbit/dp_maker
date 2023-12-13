import 'package:dp_maker/main.dart';
import 'package:dp_maker/screens/caption/cap_image_show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ads/ads_manager.dart';
import '../../utils/colors.dart';

class CaptionImagesShow extends StatefulWidget {
  const CaptionImagesShow({super.key});

  @override
  State<CaptionImagesShow> createState() => _CaptionImagesShowState();
}

class _CaptionImagesShowState extends State<CaptionImagesShow> {
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
          templateType: TemplateType.small,
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
        title: const Text(
          "Image & Caption",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
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
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: dataImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              AdsManager.showInterstitialAd(
                  () => Get.to(ImageEditorExample(image: dataImages[index])));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    "${dataImages[index]}",
                    fit: BoxFit.cover,
                  )),
            ),
          );
        },
      ),
      bottomNavigationBar: Obx(() {
        if (nativeAdIsLoaded.value) {
          return SizedBox(
            height: 72,
            child: AdWidget(ad: nativeAd!),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 72,
                  color: Colors.white,
                ),
              ),
              /*
              SizedBox(height: 20),
              Text(
                'Fetching an interesting ad for you...',
                style: TextStyle(fontSize: 16),
              ),*/
            ],
          );
        }
      }),
    );
  }
}
