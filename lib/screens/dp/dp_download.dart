import 'dart:io';
import 'dart:typed_data';
import 'package:dp_maker/utils/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ads/ads_manager.dart';

class DpDownloadPage extends StatefulWidget {
  RxInt indexImage;
  List images;

  DpDownloadPage({super.key, required this.indexImage, required this.images});

  @override
  State<DpDownloadPage> createState() => _DpDownloadPageState();
}

class _DpDownloadPageState extends State<DpDownloadPage> {
  RxString selectedImage = ''.obs;
  final GlobalKey genKey = GlobalKey();
  final ScreenshotController screenshotController = ScreenshotController();
  RxBool imageChange = false.obs;
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
        title: const Text("Create Your DP",
            style: TextStyle(
              fontWeight: FontWeight.w600,
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
      body: Column(
        children: [
          Obx(() {
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
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Screenshot(
                    controller: screenshotController,
                    child: ClipOval(
                      child: Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.center,
                        children: [
                          Obx(
                            () => imageChange.isTrue
                                ? ClipOval(
                                    child: Image.network(
                                      "${widget.images[widget.indexImage.value]['preview']}",
                                      width:
                                          MediaQuery.of(context).size.width * .8,
                                      height:
                                          MediaQuery.of(context).size.width * .8,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          Obx(() => selectedImage.value != ""
                              ? ClipOval(
                                  child: InteractiveViewer(
                                    child: Image.file(
                                      File(selectedImage!.value),
                                      width:
                                          MediaQuery.of(context).size.width * .79,
                                      height:
                                          MediaQuery.of(context).size.width * .79,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                          Obx(
                            () => imageChange.isFalse
                                ? ClipOval(
                                    child: Image.network(
                                      "${widget.images[widget.indexImage.value]['preview']}",
                                      width:
                                          MediaQuery.of(context).size.width * .8,
                                      height:
                                          MediaQuery.of(context).size.width * .8,
                                    ),
                                  )
                                : const SizedBox(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      selectedImage.value = pickedFile.path;
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: AppColors.primary,
                      ),
                    ),
                    child: Center(
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Add Image From Gallery",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppColors.primary,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => selectedImage.value != ""
                      ? Center(
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Resize Mode",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: AppColors.primary,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              CupertinoSwitch(
                                value: imageChange.value,
                                onChanged: (value) {
                                  imageChange.value = value;
                                },
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                      )
                      : const SizedBox(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * .15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => ShareData.shareApp(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: AppColors.primary,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: AppColors.primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Share",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => takePicture(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: AppColors.primary,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: AppColors.primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Save",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .1,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            // widget.indexImage.value = index;
            return GestureDetector(
              onTap: () => widget.indexImage.value = index,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.network(
                  "${widget.images[index]['preview']}",
                  width: MediaQuery.of(context).size.height * .08,
                  height: MediaQuery.of(context).size.height * .08,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    imageChange.value = false;
    if (selectedImage.value != "") {
      try {
        Uint8List? imageBytes = await screenshotController.capture();
        Directory directory =
            Directory('/storage/emulated/0/Download/DpGenerator');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        String imageName = "${DateTime.now().millisecondsSinceEpoch}";
        File imgFile = File('${directory.path}/$imageName.jpeg');
        await imgFile.writeAsBytes(imageBytes!, flush: true);

        Get.snackbar(
          'Image downloaded and saved in the gallery.',
          imgFile.path,
          snackPosition: SnackPosition.BOTTOM,
        );
        print(imgFile.path);
        // Provide UI feedback for success if needed
      } catch (e) {
        Get.snackbar(
          'Error during image processing:',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
        print("Error during image processing: $e");
        // Provide UI feedback for error if needed
      }
    } else {
      Get.snackbar(
        'Error during image processing:',
        "Add image from the Gallery",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

/*
  Future<void> takePicture() async {
    RenderRepaintBoundary? boundary =
        genKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      // Handle the case where genKey.currentContext is null
      return;
    }

    ui.Image image = await boundary.toImage();
    Directory directory = Directory('/storage/emulated/0/Download/DpGenerator');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    String imageName = "${DateTime.now().millisecondsSinceEpoch}";
    img.Image imgImage = img.decodeImage(pngBytes)!;
    Uint8List jpegBytes = img.encodeJpg(imgImage, quality: 1000000);
    File imgFile = File('${directory.path}/$imageName.jpeg');
    await imgFile.writeAsBytes(jpegBytes, flush: true);

    print(imgFile.path);
  }*/
}
