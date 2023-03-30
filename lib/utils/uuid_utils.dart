import 'package:uuid/uuid.dart';

class UuidUtils {
  static String getUuid() {
    const Uuid uuid = Uuid();
    return uuid.v4();
  }
}
