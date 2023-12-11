import 'package:card_swiper/card_swiper.dart';
import 'package:dp_maker/main.dart';
import 'package:dp_maker/screens/dp/dp_download.dart';
import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DpShowList extends StatelessWidget {
  const DpShowList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        color: Colors.black.withOpacity(0.5),
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
                                onTap: () => Get.to(() => DpDownloadPage(
                                      indexImage: i.obs,
                                      images: dataFrames[index]['image'],
                                    )),
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
    );
  }
}
