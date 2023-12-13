import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class ApiUrl {
  static String bannerId = 'ca-app-pub-4262674141420804/3730354262';
  static String interstialId = 'ca-app-pub-4262674141420804/4687432461';
  static String nativeId = 'ca-app-pub-4262674141420804/9992510283';
  static String appId = 'ca-app-pub-4262674141420804/7968982173';/*
  static String bannerId = 'ca-app-pub-3940256099942544/6300978111';
  static String interstialId = 'ca-app-pub-3940256099942544/1033173712';
  static String nativeId = 'ca-app-pub-3940256099942544/2247696110';
  static String appId = 'ca-app-pub-3940256099942544/9257395921';*/
}

class AdsManager {
  static InterstitialAd? interstitialAd;

  static void _showAdsLoadingDialog() {
    var width = MediaQuery
        .of(Get.context!)
        .size
        .width;
    Get.dialog(WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: width * 0.35,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.black),
                    SizedBox(height: 15),
                    Text(
                      'Loading Ads...',
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  static void _dismissAdDialog() {
    print("object ${Get.isDialogOpen}");
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  static bool isInterstitialAdLoaded = false;

  static Future<void> initInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: ApiUrl.interstialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialAdLoaded = true;
          print("👍👍👍");
        },
        onAdFailedToLoad: (error) {
          print("🔔🔔🔔");
          interstitialAd?.dispose();
        },
      ),
    );
  }

  static Future<void> showInterstitialAd(Function() onAdFinished) async {
    _showAdsLoadingDialog();
    await Future.delayed(const Duration(seconds: 1));
    if (isInterstitialAdLoaded) {
      interstitialAd?.show();

      interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          _dismissAdDialog();
          isInterstitialAdLoaded = false;
          interstitialAd?.dispose();
          interstitialAd = null;
          initInterstitialAd();
          onAdFinished();

          // Navigate to the desired page or perform an action after ad dismissal.
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _dismissAdDialog();
          interstitialAd?.dispose();
          interstitialAd = null;
          initInterstitialAd();
          onAdFinished();
        },
      );
    } else {
      interstitialAd?.dispose();
      interstitialAd = null;
      initInterstitialAd();
      _dismissAdDialog();
      onAdFinished();
    }
    _dismissAdDialog();
    _dismissAdDialog();
  }

  static loadAppOpenAd() {
    AppOpenAd? myAppOpenAd;

    AppOpenAd.load(
        adUnitId: ApiUrl.appId, //Your ad Id from admob
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              myAppOpenAd = ad;
              myAppOpenAd!.show();
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  }
}

/*{
  static FutureBuilder<Widget> showNativeAd() {
    var adCompleter = Completer<void>();
    Future<Widget> getNativeAdTest() async {
      NativeAd _listAd = NativeAd(
        adUnitId: ApiUrl.nativeId,
        nativeTemplateStyle:
        NativeTemplateStyle(templateType: TemplateType.medium),
        request: const AdRequest(),
        listener: NativeAdListener(onAdLoaded: (ad) {


          adCompleter.complete();
        }, onAdFailedToLoad: (ad, error) {
          // _listAd.dispose();

          ad.dispose();

          adCompleter.completeError(error);
        }),
      );

      await _listAd.load();
      await adCompleter.future;
      return AdWidget(
        ad: _listAd,
        key: Key(_listAd.hashCode.toString()),
      );
    }

    return FutureBuilder(
      future: getNativeAdTest(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Display the loaded ad
          return Container(
            height: 310,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
            child: snapshot.data,
          );
        } else {
          // Handle other cases
          return const Text("*Ad Loading*");
        }
      },
    );
  }

  static const bannerSize = AdSize.banner;

  static FutureBuilder<Widget> showBannerAd() {
    var adCompleter = Completer<void>();
    Future<Widget> getBannerAdTest() async {
      BannerAd _listAd = BannerAd(
        adUnitId: ApiUrl.bannerId,
        request: const AdRequest(),
        listener: BannerAdListener(onAdLoaded: (ad) {

          adCompleter.complete();
        }, onAdFailedToLoad: (ad, error) {
          // _listAd.dispose();
          ad.dispose();
          adCompleter.completeError(error);
        }),
        size: AdSize.banner,
      );
      await _listAd.load();
      await adCompleter.future;
      // await Future.delayed(const Duration(seconds: 3));
      return AdWidget(
        ad: _listAd,
        key: Key(_listAd.hashCode.toString()),
      );
    }

    return FutureBuilder(
      future: getBannerAdTest(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Display the loaded ad
          return Container(
            height: AdsManager.bannerSize.height.toDouble(),
            alignment: Alignment.center,
            child: snapshot.data,
          );
        } else {
          // Handle other cases
          return const SizedBox(
            height: 50,
            child: Center(child: Text("*Ad Loading*")),
          );
        }
      },
    );
  }

  static bool interAvailable = true;

  static InterstitialAd? interstitialAd;
  static int adCount=0;

  static void _showAdsLoadingDialog() {
    var width = MediaQuery.of(navigatorKey.currentContext!).size.width;
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  width: width * 0.35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Colors.black),
                        SizedBox(height: 15),
                        Text(
                          'Loading Ads...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showInterstitialAd(Function() onAdFinished) async {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    _showAdsLoadingDialog();
    if (interAvailable) {
      interAvailable = false;
      var adCompleter = Completer<void>();
      InterstitialAd.load(
        adUnitId: ApiUrl.interstialId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) async {
            if (Get.isDialogOpen == true) {
              Get.back(); // Ensure the loading dialog is closed if open
            }
            interstitialAd = ad;
            await interstitialAd!.show();
            adCompleter.complete();
          },
          onAdFailedToLoad: (error) {
            if (Get.isDialogOpen == true) {
              Get.back(); // Ensure the loading dialog is closed if open
            }
            interAvailable = true;
            adCompleter.completeError(error);
            // onAdFinished();
          },
        ),
      );

      if (Get.isDialogOpen == true) {
        Get.back(); // Ensure the loading dialog is closed if open
      }
      await adCompleter.future;
      if (interstitialAd != null) {
        interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            interstitialAd!.dispose();
            interAvailable = true;
            onAdFinished();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            interstitialAd!.dispose();
            interAvailable = true;
            onAdFinished();
          },
        );
      } else {
        if (Get.isDialogOpen == true) {
          Get.back(); // Ensure the loading dialog is closed if open
        }

        interAvailable = true;
        onAdFinished();
      }
    } else {
      if (Get.isDialogOpen == true) {
        Get.back(); // Ensure the loading dialog is closed if open
      }
      interAvailable = true;
      onAdFinished();
    }
  }

  static loadAppOpenAd() {
    AppOpenAd? myAppOpenAd;

    AppOpenAd.load(
        adUnitId: ApiUrl.appId, //Your ad Id from admob
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              myAppOpenAd = ad;
              myAppOpenAd!.show();
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  }
}*/
