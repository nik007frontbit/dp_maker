import 'dart:io';

import 'package:dp_maker/utils/colors.dart';
import 'package:dp_maker/utils/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneratedLink extends StatelessWidget {
  String phone;
  String text;

  GeneratedLink({super.key, required this.phone, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Link Generated",
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Message Link URL",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C1E),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    '''https://wa.me/$phone?text=$text''',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3366CC),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async => await Clipboard.setData(
                            ClipboardData(
                                text: '''https://wa.me/$phone?text=$text''')),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.copy,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "copy",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ShareData.shareLink(
                          link: '''https://wa.me/$phone?text=$text''',
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.share,
                              size: 16,
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
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(QrCodeScreen(
                    qrData: '''https://wa.me/$phone?text=$text'''));
              },
              child: Container(
                margin: const EdgeInsets.all(50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(40)),
                child: const Text(
                  "Generate QR Code",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QrCodeScreen extends StatelessWidget {
  final String qrData;
  final ScreenshotController screenshotController = ScreenshotController();

  QrCodeScreen({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR Code",
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Scan this QR code and start Chat",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1C1E),
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: QrImageView(
                data: qrData,
                backgroundColor: Colors.white,
                version: QrVersions.auto,
                size: MediaQuery.of(context).size.width * .8,
                gapless: false,
              ),
            ),
            GestureDetector(
              onTap: () => takePicture(),
              child: Container(
                margin: const EdgeInsets.all(50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(40)),
                child: const Text(
                  "Generate QR Code",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    try {
      Uint8List? imageBytes = await screenshotController.capture();
      Directory directory =
          Directory('/storage/emulated/0/Download/DpGenerator/QrCode');
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
  }
}
