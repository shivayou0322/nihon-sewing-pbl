import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';

class SettingsService extends ChangeNotifier {
  late Box _box;
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() => _instance;
  SettingsService._internal();

  Future<void> init() async {
    _box = await Hive.openBox(AppConstants.settingsBox);
  }

  String getAppPassword() {
    return _box.get(AppConstants.appPasswordKey, defaultValue: AppConstants.defaultAppPassword);
  }

  String getAdminCode() {
    return _box.get(AppConstants.adminCodeKey, defaultValue: AppConstants.defaultAdminCode);
  }

  Future<void> setAppPassword(String password) async {
    await _box.put(AppConstants.appPasswordKey, password);
  }

  Future<void> setAdminCode(String code) async {
    await _box.put(AppConstants.adminCodeKey, code);
  }

  Locale getLocale() {
    final code = _box.get('locale', defaultValue: 'ja');
    return Locale(code);
  }

  Future<void> setLocale(String languageCode) async {
    await _box.put('locale', languageCode);
    notifyListeners();
  }
}
