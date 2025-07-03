import 'package:http/http.dart' as http;

Future<bool> checkSiteIsReachable(String url) async {
  try {
    final response = await http
        .get(Uri.parse(url))
        .timeout(Duration(seconds: 5));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
