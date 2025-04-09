import 'package:http/http.dart' as http;

Future<void> ping() async {
  // try {
  await http.get(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/ping/'),
    headers: {'Content-Type': 'application/json'},
  );
  // } catch (e) {
  //   print(e);
  // }
}
