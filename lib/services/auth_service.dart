import 'package:http/http.dart' as http;

class AuthService {
  final baseUrl = 'http://127.0.0.1:8000/api';

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse('$baseUrl/user/register');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, String>{
        'email': email,
        'password': password,
      },
    );
  }
}
