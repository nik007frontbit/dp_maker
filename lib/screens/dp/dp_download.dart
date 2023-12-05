import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DpDownloadPage extends StatefulWidget {
  const DpDownloadPage({super.key});

  @override
  State<DpDownloadPage> createState() => _DpDownloadPageState();
}

class _DpDownloadPageState extends State<DpDownloadPage> {
  File? selectedImage;
  final GlobalKey genKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(45.0),
            child: RepaintBoundary(
              key: genKey,
              child: Stack(
                children: [
                  selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            selectedImage!,
                            width: 234,
                            height: 234,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            "asset/images/home/4.png",
                            width: 234,
                            height: 234,
                          ),
                        ),
                  ClipOval(
                    child: Image.asset(
                      "asset/images/home/4.png",
                      width: 234,
                      height: 234,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          setState(() {
                            selectedImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: Icon(
                        Icons.add,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => takePicture(),
            child: Text(
              "Download",
            ),
          )
        ],
      ),
    );
  }

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

    File imgFile = File('${directory.path}/photo.png');
    await imgFile.writeAsBytes(pngBytes);
    print(imgFile.path);
  }
}
