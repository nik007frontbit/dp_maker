import 'package:card_swiper/card_swiper.dart';
import 'package:dp_maker/main.dart';
import 'package:dp_maker/screens/dp/dp_download.dart';
import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ads/ads_manager.dart';

class DpShowList extends StatefulWidget {
  const DpShowList({super.key});

  @override
  State<DpShowList> createState() => _DpShowListState();
}

class _DpShowListState extends State<DpShowList> {
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
          "Dp Generator",
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
      body: Column(
        children: [
          Expanded(
            child: Swiper(
              viewportFraction: 0.85,
              scale: 0.95,
              itemCount: dataFrames.length,
              itemBuilder: (context, index) {
                var data = dataFrames[index]['cat_name'];
                return Container(
                  width: MediaQuery.of(context).size.width * .6,
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 20,
                    top: 20,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataFrames[index]['cat_name'],
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dataFrames[index]['image'].length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, i) {
                              data = dataFrames[index]['image'][i];
                              return GestureDetector(
                                onTap: () => AdsManager.showInterstitialAd(
                                  () => Get.to(() => DpDownloadPage(
                                        indexImage: i.obs,
                                        images: dataFrames[index]['image'],
                                      )),
                                ),
                                child: Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    "${dataFrames[index]['image'][i]['preview']}",
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
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
