import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_codes/country_codes.dart';
import 'package:dp_maker/screens/genrate_link/generated_link.dart';
import 'package:dp_maker/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ads/ads_manager.dart';

class GenerateLink extends StatefulWidget {
  bool isDirect;

  GenerateLink({super.key, required this.isDirect});

  @override
  State<GenerateLink> createState() => _GenerateLinkState();
}

class _GenerateLinkState extends State<GenerateLink> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _messageController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RxString _selectedCountryCode = '+1'.obs;

  Future<void> countryCode() async {
    await CountryCodes
        .init(); // Optionally, you may provide a `Locale` to get countrie's localizadName

    final CountryDetails details = CountryCodes.detailsForLocale();
    // Displays alpha2Code, for example US.
    _selectedCountryCode.value = details.dialCode ?? '+1';
    print(details.dialCode);
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
          templateType: TemplateType.medium,
        ))
      ..load();

    nativeAd!.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryCode();
    loadNativeAd();
  }

  // Default country code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isDirect == true ? "Direct Message" : "Generate Link",
          style: const TextStyle(
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Obx(
                      () =>
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  const Positioned(
                                      right: 10,
                                      bottom: 10,
                                      top: 10,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Color(0xFF666666),
                                      )),
                                  CountryCodePicker(
                                    onChanged: (value) {
                                      _selectedCountryCode.value =
                                      value.dialCode!;
                                      print(value.dialCode);
                                    },
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: _selectedCountryCode
                                        .value,
                                    favorite: const ['+39', 'FR', '+91'],
                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                    // optional. Shows only country name and flag when popup is closed.
                                    showOnlyCountryWhenClosed: false,

                                    // optional. aligns the flag and the Text left
                                    alignLeft: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF1C1C1E)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  validator: (value) {
                    bool isNumeric(String input) {
                      final RegExp numericRegex = RegExp(r'^[0-9]+$');
                      return numericRegex.hasMatch(input);
                    }

                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (!isNumeric(value)) {
                      return 'Invalid characters. Please enter only numbers.';
                    }
                    // Add additional validation if needed
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      isDense: true,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: "Enter phone number",
                      hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA7A7A7)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: const Color(
                        0xFFF3F3F3,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter Message",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF1C1C1E)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _messageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a text';
                    }
                    // Add additional validation if needed
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: "write message...",
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA7A7A7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: const Color(
                      0xFFF3F3F3,
                    ),
                  ),
                  maxLines: 4,
                ),
                GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (widget.isDirect == false) {
                        print(
                            "${_selectedCountryCode
                                .value}${_phoneNumberController.text}");
                        Get.to(GeneratedLink(
                            phone:
                            "${_selectedCountryCode
                                .value}${_phoneNumberController.text}",
                            text: _messageController.text));
                      } else {
                        try {
                          await launchUrl(Uri.parse(
                              '''https://wa.me/${_selectedCountryCode
                                  .value}${_phoneNumberController
                                  .text}?text=${_messageController.text}'''));
                        } catch (e) {
                          Get.snackbar(
                            'Could not launch something went wrong',
                            '''https://wa.me/${_selectedCountryCode
                                .value}${_phoneNumberController
                                .text}?text=${_messageController.text}''',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    }
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
                    child: Text(
                      widget.isDirect == false
                          ? "Generate Link"
                          : "Direct message",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.primary),
                    ),
                  ),
                ),
                Obx(() {
                  if (nativeAdIsLoaded.value) {
                    return SizedBox(
                        height: 350, child: AdWidget(ad: nativeAd!));
                  } else {
                    return const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text('*Ad is not loaded yet.*')),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl() {}

  void _generateLink() {
    if (_formKey.currentState!.validate()) {
      print("${_selectedCountryCode.value}${_phoneNumberController.text}");
      Get.to(GeneratedLink(
          phone: "${_selectedCountryCode.value}${_phoneNumberController.text}",
          text: _messageController.text));
    } else {
      print(" udvjdsvnsjdvjnsv");
    }
    // All fields are valid, proceed with generating the link
    print('Generating link...');
    // Add your logic to generate the link here
  }
}
