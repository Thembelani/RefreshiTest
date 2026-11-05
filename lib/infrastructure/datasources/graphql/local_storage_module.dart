import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class LocalStorageModule {
  @preResolve
  @lazySingleton
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();
}
