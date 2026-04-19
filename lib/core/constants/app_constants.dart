class AppConstants {
  // Phase 1: パスワード（Hiveに保存された値がなければこの初期値を使う）
  static const String defaultAppPassword = '1234';
  static const String defaultAdminCode = '9999';

  // Hiveのボックス名・キー
  static const String settingsBox = 'settings';
  static const String itemsBox = 'items';
  static const String appPasswordKey = 'appPassword';
  static const String adminCodeKey = 'adminCode';

  // UI定数
  static const double minTapTarget = 48.0;
  static const double keypadButtonSize = 72.0;
}
