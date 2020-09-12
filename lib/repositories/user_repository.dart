import 'dart:convert';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/providers/providers.dart';

class UserRepository {
  UserProvider provider = UserProvider();

  loadUser() async {
    final jsonUsersList = await provider.getUser();
    if (jsonUsersList == '') return null;
    final userList = json.decode(jsonUsersList).cast<Map<String, dynamic>>();
    return userList.map<User>((i) => User.fromJson(i)).toList();
  }

  saveUser(List<User> user) {
    String jsonUserList = jsonEncode(user);
    provider.setUser(jsonUserList);
  }
}
