import 'package:http/http.dart' as http;

// Future<void> ping() async {
//   await http.get(
//     Uri.parse('https://fmjc-biysk-pc.cloudpub.ru/ping'),
//     headers: {'Content-Type': 'application/json'},
//   );
// }

void ping() async {
  final client = http.Client();
  try {
    final response =
        await client.get(Uri.parse('https://fmjc-biysk-pc.cloudpub.ru/ping'));
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
