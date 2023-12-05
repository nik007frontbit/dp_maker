import 'package:dp_maker/screens/dp/dp_download.dart';
import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DpShowList extends StatelessWidget {
  const DpShowList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
            )),
            child: Column(
              children: [
                const Text(
                  "title",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Wrap(
                  children: List.generate(
                      40,
                      (index) => GestureDetector(
                            onTap: () => Get.to(const DpDownloadPage()),
                            child: Image.asset(
                              "asset/images/home/1.png",
                              width: 60,
                              height: 60,
                            ),
                          )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
