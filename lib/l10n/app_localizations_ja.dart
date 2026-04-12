// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '工程確認アプリ';

  @override
  String get loginTitle => 'パスワードを入力してください';

  @override
  String get loginButton => 'ログイン';

  @override
  String get loginError => 'パスワードが正しくありません';

  @override
  String get searchTitle => '伝票番号を入力';

  @override
  String get searchHint => '伝票番号';

  @override
  String get searchButton => '検索';

  @override
  String get notFound => '該当する伝票番号が見つかりません';

  @override
  String get backButton => '戻る';
}
