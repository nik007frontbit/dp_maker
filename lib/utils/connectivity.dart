import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkController());
  }
}

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Set an initial connectivity status.
  var isConnected = true.obs;
  var isDialogOpen = false.obs; // Flag to track if the dialog is open.

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    // Periodically check for connectivity.
    Stream.periodic(const Duration(seconds: 5)).listen((_) async {
      final newResult = await _connectivity.checkConnectivity();
      _updateConnectionStatus(newResult);
    });
  }

  _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isConnected(false); // Update the isConnected observable.

      if (!isDialogOpen.value) {
        isDialogOpen(true); // Set the dialog flag to true.
        Get.dialog(
          barrierDismissible: false,
          WillPopScope(
            onWillPop: () async {
              bool backWill = false;
              return backWill;
            },
            child: const CupertinoAlertDialog(
              title: Text("Oops",
                  style: TextStyle(
                    color: Color(0xFF008EB2),
                  )),
              content: Text(
                "Please check your internet connection. try again!!",
              ),
              actions: [
                /*CupertinoDialogAction(
                  onPressed: () {
                    isDialogOpen(false); // Set the dialog flag to false.
                    Get.back();
                  },
                  child: const Text(
                    "OK",
                  ),
                ),*/
              ],
            ),
          ),
        );
      }
    } else {
      isConnected(true); // Update the isConnected observable.
      if (isDialogOpen.value) {
        isDialogOpen(false); // Set the dialog flag to false.
        Get.back();
      }
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
