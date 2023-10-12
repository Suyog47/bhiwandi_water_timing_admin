import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetController extends GetxController{
  RxBool isInternetActive = true.obs;

  Future checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      isInternetActive.value = true;
    }
    else{
      isInternetActive.value = false;
    }
  }

  void setInternetListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        isInternetActive.value = true;
      }
      else{
        isInternetActive.value = false;
      }
    });
  }

}