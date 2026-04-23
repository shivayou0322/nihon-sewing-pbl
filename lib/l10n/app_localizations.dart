import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ja.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ja'),
    Locale('my'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'ポカヨケ・デジタル'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを入力してください'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In ja, this message translates to:
  /// **'パスワードが正しくありません'**
  String get loginError;

  /// No description provided for @adminLogin.
  ///
  /// In ja, this message translates to:
  /// **'管理者ログイン'**
  String get adminLogin;

  /// No description provided for @searchTitle.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号を入力'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号'**
  String get searchHint;

  /// No description provided for @searchButton.
  ///
  /// In ja, this message translates to:
  /// **'検索'**
  String get searchButton;

  /// No description provided for @notFound.
  ///
  /// In ja, this message translates to:
  /// **'該当する伝票番号が見つかりません'**
  String get notFound;

  /// No description provided for @backButton.
  ///
  /// In ja, this message translates to:
  /// **'戻る'**
  String get backButton;

  /// No description provided for @logout.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logout;

  /// No description provided for @detailTitle.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号: {ticketNumber}'**
  String detailTitle(String ticketNumber);

  /// No description provided for @description.
  ///
  /// In ja, this message translates to:
  /// **'説明'**
  String get description;

  /// No description provided for @designImage.
  ///
  /// In ja, this message translates to:
  /// **'デザイン画像'**
  String get designImage;

  /// No description provided for @adminAuthTitle.
  ///
  /// In ja, this message translates to:
  /// **'管理者ログイン'**
  String get adminAuthTitle;

  /// No description provided for @adminAuthStep1.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを入力'**
  String get adminAuthStep1;

  /// No description provided for @adminAuthStep2.
  ///
  /// In ja, this message translates to:
  /// **'管理者コードを入力'**
  String get adminAuthStep2;

  /// No description provided for @adminCodeError.
  ///
  /// In ja, this message translates to:
  /// **'管理者コードが正しくありません'**
  String get adminCodeError;

  /// No description provided for @stepOf.
  ///
  /// In ja, this message translates to:
  /// **'ステップ {current}/{total}'**
  String stepOf(String current, String total);

  /// No description provided for @next.
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get next;

  /// No description provided for @adminMenu.
  ///
  /// In ja, this message translates to:
  /// **'管理メニュー'**
  String get adminMenu;

  /// No description provided for @itemManagement.
  ///
  /// In ja, this message translates to:
  /// **'伝票データ管理'**
  String get itemManagement;

  /// No description provided for @passwordChange.
  ///
  /// In ja, this message translates to:
  /// **'パスワード変更'**
  String get passwordChange;

  /// No description provided for @dataExport.
  ///
  /// In ja, this message translates to:
  /// **'データエクスポート'**
  String get dataExport;

  /// No description provided for @dataImport.
  ///
  /// In ja, this message translates to:
  /// **'データインポート'**
  String get dataImport;

  /// No description provided for @processing.
  ///
  /// In ja, this message translates to:
  /// **'処理中...'**
  String get processing;

  /// No description provided for @webNotSupported.
  ///
  /// In ja, this message translates to:
  /// **'Web版ではこの機能はサポートされていません'**
  String get webNotSupported;

  /// No description provided for @exportComplete.
  ///
  /// In ja, this message translates to:
  /// **'エクスポートが完了しました'**
  String get exportComplete;

  /// No description provided for @exportFailed.
  ///
  /// In ja, this message translates to:
  /// **'エクスポートに失敗しました'**
  String get exportFailed;

  /// No description provided for @importConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'インポート確認'**
  String get importConfirmTitle;

  /// No description provided for @importConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'インポートすると、同じ伝票番号のデータは上書きされます。\n続けますか？'**
  String get importConfirmMessage;

  /// No description provided for @importComplete.
  ///
  /// In ja, this message translates to:
  /// **'{count}件のデータをインポートしました'**
  String importComplete(int count);

  /// No description provided for @importFailed.
  ///
  /// In ja, this message translates to:
  /// **'インポートに失敗しました'**
  String get importFailed;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @itemListTitle.
  ///
  /// In ja, this message translates to:
  /// **'伝票データ管理'**
  String get itemListTitle;

  /// No description provided for @addNew.
  ///
  /// In ja, this message translates to:
  /// **'新規追加'**
  String get addNew;

  /// No description provided for @noData.
  ///
  /// In ja, this message translates to:
  /// **'データがありません\n右下の「新規追加」から追加してください'**
  String get noData;

  /// No description provided for @ticketNumberLabel.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号'**
  String get ticketNumberLabel;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除確認'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号「{ticketNumber}」を削除しますか？\nこの操作は取り消せません。'**
  String deleteConfirmMessage(String ticketNumber);

  /// No description provided for @delete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// No description provided for @deleted.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号「{ticketNumber}」を削除しました'**
  String deleted(String ticketNumber);

  /// No description provided for @edit.
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get edit;

  /// No description provided for @editTitle.
  ///
  /// In ja, this message translates to:
  /// **'データ編集'**
  String get editTitle;

  /// No description provided for @addTitle.
  ///
  /// In ja, this message translates to:
  /// **'新規追加'**
  String get addTitle;

  /// No description provided for @descriptionLabel.
  ///
  /// In ja, this message translates to:
  /// **'説明文'**
  String get descriptionLabel;

  /// No description provided for @ticketNumberHint.
  ///
  /// In ja, this message translates to:
  /// **'例: 01'**
  String get ticketNumberHint;

  /// No description provided for @descriptionHint.
  ///
  /// In ja, this message translates to:
  /// **'例: 左ポケットあり、ボタンなし'**
  String get descriptionHint;

  /// No description provided for @imageLabel.
  ///
  /// In ja, this message translates to:
  /// **'画像'**
  String get imageLabel;

  /// No description provided for @selectFromGallery.
  ///
  /// In ja, this message translates to:
  /// **'ギャラリーから選択'**
  String get selectFromGallery;

  /// No description provided for @tapToSelectImage.
  ///
  /// In ja, this message translates to:
  /// **'タップして画像を選択'**
  String get tapToSelectImage;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @update.
  ///
  /// In ja, this message translates to:
  /// **'更新'**
  String get update;

  /// No description provided for @saved.
  ///
  /// In ja, this message translates to:
  /// **'追加しました'**
  String get saved;

  /// No description provided for @updated.
  ///
  /// In ja, this message translates to:
  /// **'更新しました'**
  String get updated;

  /// No description provided for @enterTicketNumber.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号を入力してください'**
  String get enterTicketNumber;

  /// No description provided for @enterDescription.
  ///
  /// In ja, this message translates to:
  /// **'説明文を入力してください'**
  String get enterDescription;

  /// No description provided for @duplicateTicketNumber.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号「{ticketNumber}」は既に登録されています'**
  String duplicateTicketNumber(String ticketNumber);

  /// No description provided for @passwordChangeTitle.
  ///
  /// In ja, this message translates to:
  /// **'パスワード変更'**
  String get passwordChangeTitle;

  /// No description provided for @appPasswordSection.
  ///
  /// In ja, this message translates to:
  /// **'通常パスワード（従業員用）'**
  String get appPasswordSection;

  /// No description provided for @adminCodeSection.
  ///
  /// In ja, this message translates to:
  /// **'管理者コード'**
  String get adminCodeSection;

  /// No description provided for @currentPassword.
  ///
  /// In ja, this message translates to:
  /// **'現在のパスワード'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワード'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワード（確認）'**
  String get confirmPassword;

  /// No description provided for @currentAdminCode.
  ///
  /// In ja, this message translates to:
  /// **'現在の管理者コード'**
  String get currentAdminCode;

  /// No description provided for @newAdminCode.
  ///
  /// In ja, this message translates to:
  /// **'新しい管理者コード'**
  String get newAdminCode;

  /// No description provided for @confirmAdminCode.
  ///
  /// In ja, this message translates to:
  /// **'新しい管理者コード（確認）'**
  String get confirmAdminCode;

  /// No description provided for @saveChanges.
  ///
  /// In ja, this message translates to:
  /// **'変更を保存'**
  String get saveChanges;

  /// No description provided for @wrongCurrentPassword.
  ///
  /// In ja, this message translates to:
  /// **'現在のパスワードが正しくありません'**
  String get wrongCurrentPassword;

  /// No description provided for @wrongCurrentAdminCode.
  ///
  /// In ja, this message translates to:
  /// **'現在の管理者コードが正しくありません'**
  String get wrongCurrentAdminCode;

  /// No description provided for @enterNewPassword.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワードを入力してください'**
  String get enterNewPassword;

  /// No description provided for @enterNewAdminCode.
  ///
  /// In ja, this message translates to:
  /// **'新しい管理者コードを入力してください'**
  String get enterNewAdminCode;

  /// No description provided for @passwordMismatch.
  ///
  /// In ja, this message translates to:
  /// **'新しいパスワードが一致しません'**
  String get passwordMismatch;

  /// No description provided for @adminCodeMismatch.
  ///
  /// In ja, this message translates to:
  /// **'新しい管理者コードが一致しません'**
  String get adminCodeMismatch;

  /// No description provided for @passwordChanged.
  ///
  /// In ja, this message translates to:
  /// **'パスワードを変更しました'**
  String get passwordChanged;

  /// No description provided for @adminCodeChanged.
  ///
  /// In ja, this message translates to:
  /// **'管理者コードを変更しました'**
  String get adminCodeChanged;

  /// No description provided for @languageSettings.
  ///
  /// In ja, this message translates to:
  /// **'言語設定'**
  String get languageSettings;

  /// No description provided for @japanese.
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @myanmar.
  ///
  /// In ja, this message translates to:
  /// **'ミャンマー語 (မြန်မာဘာသာ)'**
  String get myanmar;

  /// No description provided for @clearButton.
  ///
  /// In ja, this message translates to:
  /// **'C'**
  String get clearButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ja', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ja':
      return AppLocalizationsJa();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
