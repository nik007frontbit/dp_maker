import 'package:dp_maker/screens/dp/dp_show.dart';
import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'caption/caption_images.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          children: [
            pagesIcon(
                height: 70,
                image: "asset/images/home/dp.png",
                ontap: () => Get.to(const DpShowList())),
            Row(
              children: [
                Expanded(
                  child: pagesIcon(
                    height: 100,
                    image: "asset/images/home/chat.png",
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: pagesIcon(
                    height: 100,
                    image: "asset/images/home/cap.png",
                    ontap: () => Get.to(CaptionImagesShow()),
                  ),
                ),
              ],
            ),
            pagesIcon(
              height: 70,
              image: "asset/images/home/genLink.png",
            ),
            pagesIcon(
              height: 70,
              image: "asset/images/home/waWeb.png",
            ),
          ],
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
      child: Container(
        width: double.infinity,
        height: height,
        margin: const EdgeInsets.symmetric(
          vertical: 7.5,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primary,
            border: Border.all(
              color: const Color(0xFFD2F0FD),
            )),
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}
