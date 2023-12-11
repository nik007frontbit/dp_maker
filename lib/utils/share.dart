import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareData {
  ShareData._();

  static shareApp({BuildContext? context}) async {
    const url =
        'https://play.google.com/store/apps/details?id=com.quotes_world.quotes.best.popular.quotes_world';
    await Share.share(
        "Download Life Quotes Application, These are the Best Life Quotes and statuses for you.. \n$url",
        subject: "Share App");
  }

  static rateUS() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.quotes_world.quotes.best.popular.quotes_world';
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
    // const url = 'https://play.google.com/store/apps/details?id=com.quotes_world.quotes.best.popular.quotes_world';
    await Share.share("$link", subject: "Share Link");
  }
}
