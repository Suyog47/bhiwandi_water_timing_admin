import 'package:get/get.dart';

class Navigate {
  void toDashboard([Map? data]) {
    Get.toNamed('/dashboard');
  }

  void toAddUpdate([Map? data]) {
    Get.toNamed('/addUpdate', arguments: data);
  }
}
