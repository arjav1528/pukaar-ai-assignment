import 'package:get/get.dart';

void showAppSnack(String title, String message) {
  Get.snackbar(title, message);
}

void showErrorSnack(String message) {
  Get.snackbar('Something went wrong', message);
}
