import 'package:shared_preferences/shared_preferences.dart';

class UserProvider {
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonUsersList = prefs.getString('userList') ?? '';
    return jsonUsersList;
  }

  setUser(String jsonUserList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userList', jsonUserList);
  }
}
