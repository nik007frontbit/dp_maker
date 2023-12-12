import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareData {
  ShareData._();

  static shareApp({BuildContext? context}) async {
    const url =
        'https://play.google.com/store/apps/details?id=com.dpmaker.profile.photo';
    await Share.share(
        "DP Maker - Profile Photo Maker is very useful for build your profile picture unique from others, when you use profile border maker for edit your profile picture you see 100+ profile border. You can download frame with your photo and share to link with your friends... \n$url",
        subject: "Share App");
  }

  static rateUS() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.dpmaker.profile.photo';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static moreApps() async {
    const url = 'https://play.google.com/store/apps/developer?id=tech2b';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static privacyApps() async {
    const url = 'https://3techconnect.blogspot.com/2021/11/mobile-apps-1.html';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static shareLink({BuildContext? context, required String link}) async {
    // const url = 'https://play.google.com/store/apps/details?id=com.dpmaker.profile.photo';
    await Share.share("$link", subject: "Share Link");
  }
}
