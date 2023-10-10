import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData{
  late SharedPreferences prefs;


  Future getPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future setData(String area) async {
    await getPref();
    await prefs.setString('area', area);
  }

  Future<String?> getData() async {
    await getPref();
    return prefs.getString('area');
  }

}