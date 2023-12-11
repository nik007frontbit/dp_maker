import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                                width: MediaQuery.of(context).size.width * .8,
                                height: MediaQuery.of(context).size.width * .8,
                              ),
                            )
                          : const SizedBox(),
                    ),
                    Obx(() => selectedImage.value != ""
                        ? ClipOval(
                            child: InteractiveViewer(
                              child: Image.file(
                                File(selectedImage!.value),
                                width: MediaQuery.of(context).size.width * .79,
                                height: MediaQuery.of(context).size.width * .79,
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
                                width: MediaQuery.of(context).size.width * .8,
                                height: MediaQuery.of(context).size.width * .8,
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: AppColors.primary,
                ),
              ),
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
                  Text("Add Image From Gallary",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.primary,
                      )),
                ],
              ),
            ),
          ),
          Obx(
            () => selectedImage.value != ""
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Edit Mode",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.primary,
                          )),
                      CupertinoSwitch(
                        value: imageChange.value,
                        onChanged: (value) {
                          imageChange.value = value;
                        },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .15),
            child: Row(
              children: [
                Expanded(child: Image.asset("asset/images/home/share.png")),
                Expanded(
                  child: GestureDetector(
                    onTap: () => takePicture(),
                    child: Image.asset(
                      "asset/images/home/Save.png",
                    ),
                  ),
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
