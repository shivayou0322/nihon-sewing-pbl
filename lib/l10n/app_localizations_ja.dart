// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ポカヨケ・デジタル';

  @override
  String get loginTitle => 'パスワードを入力してください';

  @override
  String get loginButton => 'ログイン';

  @override
  String get loginError => 'パスワードが正しくありません';

  @override
  String get adminLogin => '管理者ログイン';

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

  @override
  String get logout => 'ログアウト';

  @override
  String detailTitle(String ticketNumber) {
    return '伝票番号: $ticketNumber';
  }

  @override
  String get description => '説明';

  @override
  String get designImage => 'デザイン画像';

  @override
  String get adminAuthTitle => '管理者ログイン';

  @override
  String get adminAuthStep1 => 'パスワードを入力';

  @override
  String get adminAuthStep2 => '管理者コードを入力';

  @override
  String get adminCodeError => '管理者コードが正しくありません';

  @override
  String stepOf(String current, String total) {
    return 'ステップ $current/$total';
  }

  @override
  String get next => '次へ';

  @override
  String get adminMenu => '管理メニュー';

  @override
  String get itemManagement => '伝票データ管理';

  @override
  String get passwordChange => 'パスワード変更';

  @override
  String get dataExport => 'データエクスポート';

  @override
  String get dataImport => 'データインポート';

  @override
  String get processing => '処理中...';

  @override
  String get webNotSupported => 'Web版ではこの機能はサポートされていません';

  @override
  String get exportComplete => 'エクスポートが完了しました';

  @override
  String get exportFailed => 'エクスポートに失敗しました';

  @override
  String get importConfirmTitle => 'インポート確認';

  @override
  String get importConfirmMessage => 'インポートすると、同じ伝票番号のデータは上書きされます。\n続けますか？';

  @override
  String importComplete(int count) {
    return '$count件のデータをインポートしました';
  }

  @override
  String get importFailed => 'インポートに失敗しました';

  @override
  String get cancel => 'キャンセル';

  @override
  String get itemListTitle => '伝票データ管理';

  @override
  String get addNew => '新規追加';

  @override
  String get noData => 'データがありません\n右下の「新規追加」から追加してください';

  @override
  String get ticketNumberLabel => '伝票番号';

  @override
  String get deleteConfirmTitle => '削除確認';

  @override
  String deleteConfirmMessage(String ticketNumber) {
    return '伝票番号「$ticketNumber」を削除しますか？\nこの操作は取り消せません。';
  }

  @override
  String get delete => '削除';

  @override
  String deleted(String ticketNumber) {
    return '伝票番号「$ticketNumber」を削除しました';
  }

  @override
  String get edit => '編集';

  @override
  String get editTitle => 'データ編集';

  @override
  String get addTitle => '新規追加';

  @override
  String get descriptionLabel => '説明文';

  @override
  String get ticketNumberHint => '例: 01';

  @override
  String get descriptionHint => '例: 左ポケットあり、ボタンなし';

  @override
  String get imageLabel => '画像';

  @override
  String get selectFromGallery => 'ギャラリーから選択';

  @override
  String get tapToSelectImage => 'タップして画像を選択';

  @override
  String get save => '保存';

  @override
  String get update => '更新';

  @override
  String get saved => '追加しました';

  @override
  String get updated => '更新しました';

  @override
  String get enterTicketNumber => '伝票番号を入力してください';

  @override
  String get enterDescription => '説明文を入力してください';

  @override
  String duplicateTicketNumber(String ticketNumber) {
    return '伝票番号「$ticketNumber」は既に登録されています';
  }

  @override
  String get passwordChangeTitle => 'パスワード変更';

  @override
  String get appPasswordSection => '通常パスワード（従業員用）';

  @override
  String get adminCodeSection => '管理者コード';

  @override
  String get currentPassword => '現在のパスワード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get confirmPassword => '新しいパスワード（確認）';

  @override
  String get currentAdminCode => '現在の管理者コード';

  @override
  String get newAdminCode => '新しい管理者コード';

  @override
  String get confirmAdminCode => '新しい管理者コード（確認）';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get wrongCurrentPassword => '現在のパスワードが正しくありません';

  @override
  String get wrongCurrentAdminCode => '現在の管理者コードが正しくありません';

  @override
  String get enterNewPassword => '新しいパスワードを入力してください';

  @override
  String get enterNewAdminCode => '新しい管理者コードを入力してください';

  @override
  String get passwordMismatch => '新しいパスワードが一致しません';

  @override
  String get adminCodeMismatch => '新しい管理者コードが一致しません';

  @override
  String get passwordChanged => 'パスワードを変更しました';

  @override
  String get adminCodeChanged => '管理者コードを変更しました';

  @override
  String get languageSettings => '言語設定';

  @override
  String get japanese => '日本語';

  @override
  String get myanmar => 'ミャンマー語';

  @override
  String get clearButton => 'C';
}
