import 'package:dp_maker/main.dart';
import 'package:dp_maker/screens/caption/cap_image_show.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaptionImagesShow extends StatelessWidget {
  const CaptionImagesShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              Get.to(ImageEditorExample(image: dataImages[index]));
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
    );
  }
}
