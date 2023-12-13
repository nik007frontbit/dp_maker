import 'dart:io';

import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:image/image.dart' as img;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path/path.dart' as path;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ads/ads_manager.dart';

class CaptionSelectedImage extends StatelessWidget {
  const CaptionSelectedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class EditorController extends GetxController {
  RxString selected = "".obs;
  Rx<Uint8List> imageData = (Uint8List(0)).obs;
}

class ImageEditorExample extends StatefulWidget {
  String image;

  ImageEditorExample({super.key, required this.image});

  @override
  createState() => _ImageEditorExampleState();
}

class _ImageEditorExampleState extends State<ImageEditorExample> {
  final controller = Get.put(EditorController());

  Uint8List? bytes;

  loadImage() async {
    bytes =
        (await NetworkAssetBundle(Uri.parse(widget.image)).load(widget.image))
            .buffer
            .asUint8List();
    controller.imageData.value = bytes!;
    print(bytes);
  }

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
    super.initState();
    // Initialize controller.imageData with an empty Uint8List.
    controller.imageData = Rx<Uint8List>(Uint8List(0));

    loadImage();
    loadNativeAd();
    // Load the first image from selectedImages if available.
/*    if (controller.selected.value.isNotEmpty) {
      loadAsset(controller.selected.value);
    }*/
  }

/*

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFiles != null) {
      controller.selected.value = pickedFiles.path;
      loadAsset(pickedFiles.path);
    }
  }
*/

  /* void loadAsset(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      if (bytes.isNotEmpty) {
        controller.imageData.value = Uint8List.fromList(bytes);
      } else {
        // Handle the case where the file is empty.
        Get.snackbar(
          "Error",
          "Image file is empty.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // Handle the case where the file doesn't exist.
      Get.snackbar(
        "Error",
        "Image file does not exist at path: $filePath",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
*/
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
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Obx(
              () => controller.imageData.value.isNotEmpty
                  ? Expanded(
                      child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          controller.imageData.value,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                  : Expanded(
                      child: Container(
                      color: Colors.grey.withOpacity(0.2),
                    )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => AdsManager.showInterstitialAd(
                        () => _download(controller.imageData.value)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary,
                        ),
                      ),
                      child: const Icon(
                        Icons.file_download_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.primary,
                      ),
                    ),
                    onTap: () async {
                      // Check if imageData is not null before editing.

                      if (controller.imageData.value.isNotEmpty) {
                        var editedImage = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ImageEditor(
                              image: controller.imageData.value,
                            ),
                          ),
                        );

                        // Replace with edited image if available.
                        if (editedImage != null) {
                          controller.imageData.value = editedImage;
                        }
                      } else {
                        Get.snackbar(
                          "Empty Data",
                          "No image data available for editing.",
                        );
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () => controller.imageData.value = bytes!,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary,
                        ),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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

  void _download(Uint8List imageData) async {
    String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final image = img.decodeImage(imageData);
    if (image == null) {
      // Handle the case where the decoding failed
      return;
    }

    Directory dir = Directory('/storage/emulated/0/Download/DpGenerator');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    // Define a unique filename for the saved image

    final appFolder = Directory('${dir.path}/caption_images');
    if (!await appFolder.exists()) {
      appFolder.createSync();
    }

    final localPath = path.join(appFolder.path, uniqueFileName);
    File imageFile = File(localPath);
    try {
      await imageFile.writeAsBytes(img.encodePng(image));

      Get.snackbar(
        'Image downloaded and saved in the gallery.',
        imageFile.path,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download and save image.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
