import 'package:http/http.dart' as http;

class DataApiCalls{

  Future<dynamic> getData(id) async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Admin/getData.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.post(url, body: {
        'area_id': id,
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }

  Future<dynamic> addTiming(id, from, till) async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Admin/addTimings.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.post(url, body: {
        'id': id,
        'from': from,
        'till': till
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }

  Future<dynamic> editTiming(id, from, till) async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Admin/updateTiming.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.post(url, body: {
        'timingId': id,
        'from': from,
        'till': till
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }

  Future<dynamic> deleteTiming(id) async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Admin/deleteTiming.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.post(url, body: {
        'timingId': id,
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }

  Future<dynamic> saveNews(id, news) async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Admin/saveNews.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.post(url, body: {
        'id': id,
        'news': news,
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }

  Future<dynamic> getAllData() async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Admin/getAllData.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }
}