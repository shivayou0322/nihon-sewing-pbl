// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'ポカヨケ・デジタル';

  @override
  String get loginTitle => 'စကားဝှက်ထည့်ပါ';

  @override
  String get loginButton => 'ဝင်ရောက်ရန်';

  @override
  String get loginError => 'စကားဝှက် မှားနေပါသည်';

  @override
  String get adminLogin => 'စီမံခန့်ခွဲသူ ဝင်ရောက်ရန်';

  @override
  String get searchTitle => 'ဘောင်ချာနံပါတ် ထည့်ပါ';

  @override
  String get searchHint => 'ဘောင်ချာနံပါတ်';

  @override
  String get searchButton => 'ရှာဖွေရန်';

  @override
  String get notFound => 'ဘောင်ချာနံပါတ် ရှာမတွေ့ပါ';

  @override
  String get backButton => 'နောက်သို့';

  @override
  String get logout => 'ထွက်ရန်';

  @override
  String detailTitle(String ticketNumber) {
    return 'ဘောင်ချာနံပါတ်: $ticketNumber';
  }

  @override
  String get description => 'ဖော်ပြချက်';

  @override
  String get designImage => 'ဒီဇိုင်းပုံ';

  @override
  String get adminAuthTitle => 'စီမံခန့်ခွဲသူ ဝင်ရောက်ရန်';

  @override
  String get adminAuthStep1 => 'စကားဝှက်ထည့်ပါ';

  @override
  String get adminAuthStep2 => 'စီမံခန့်ခွဲသူ ကုဒ်ထည့်ပါ';

  @override
  String get adminCodeError => 'စီမံခန့်ခွဲသူ ကုဒ် မှားနေပါသည်';

  @override
  String stepOf(String current, String total) {
    return 'အဆင့် $current/$total';
  }

  @override
  String get next => 'ရှေ့သို့';

  @override
  String get adminMenu => 'စီမံခန့်ခွဲမှု မီနူး';

  @override
  String get itemManagement => 'ဘောင်ချာ ဒေတာ စီမံခန့်ခွဲမှု';

  @override
  String get passwordChange => 'စကားဝှက် ပြောင်းလဲရန်';

  @override
  String get dataExport => 'ဒေတာ ထုတ်ယူရန်';

  @override
  String get dataImport => 'ဒေတာ သွင်းယူရန်';

  @override
  String get processing => 'လုပ်ဆောင်နေသည်...';

  @override
  String get webNotSupported =>
      'ဝက်ဘ်ဗားရှင်းတွင် ဤလုပ်ဆောင်ချက်ကို ပံ့ပိုးမထားပါ';

  @override
  String get exportComplete => 'ထုတ်ယူခြင်း ပြီးပါပြီ';

  @override
  String get exportFailed => 'ထုတ်ယူခြင်း မအောင်မြင်ပါ';

  @override
  String get importConfirmTitle => 'သွင်းယူခြင်း အတည်ပြုချက်';

  @override
  String get importConfirmMessage =>
      'သွင်းယူပါက ဘောင်ချာနံပါတ်တူသော ဒေတာများကို အစားထိုးပါမည်။\nဆက်လုပ်မလား?';

  @override
  String importComplete(int count) {
    return 'ဒေတာ $count ခု သွင်းယူပြီးပါပြီ';
  }

  @override
  String get importFailed => 'သွင်းယူခြင်း မအောင်မြင်ပါ';

  @override
  String get cancel => 'မလုပ်တော့ပါ';

  @override
  String get itemListTitle => 'ဘောင်ချာ ဒေတာ စီမံခန့်ခွဲမှု';

  @override
  String get addNew => 'အသစ်ထည့်ရန်';

  @override
  String get noData =>
      'ဒေတာ မရှိပါ\nညာဘက်အောက်ခြေမှ \"အသစ်ထည့်ရန်\" ကိုနှိပ်ပါ';

  @override
  String get ticketNumberLabel => 'ဘောင်ချာနံပါတ်';

  @override
  String get deleteConfirmTitle => 'ဖျက်ရန် အတည်ပြုချက်';

  @override
  String deleteConfirmMessage(String ticketNumber) {
    return 'ဘောင်ချာနံပါတ် \"$ticketNumber\" ကို ဖျက်မလား?\nဤလုပ်ဆောင်ချက်ကို ပြန်ဖျက်၍ မရပါ။';
  }

  @override
  String get delete => 'ဖျက်ရန်';

  @override
  String deleted(String ticketNumber) {
    return 'ဘောင်ချာနံပါတ် \"$ticketNumber\" ကို ဖျက်ပြီးပါပြီ';
  }

  @override
  String get edit => 'ပြင်ဆင်ရန်';

  @override
  String get editTitle => 'ဒေတာ ပြင်ဆင်ရန်';

  @override
  String get addTitle => 'အသစ်ထည့်ရန်';

  @override
  String get descriptionLabel => 'ဖော်ပြချက်';

  @override
  String get ticketNumberHint => 'ဥပမာ: 01';

  @override
  String get descriptionHint => 'ဥပမာ: ဘယ်အိတ်ပါ၊ ခလုတ်မပါ';

  @override
  String get imageLabel => 'ပုံ';

  @override
  String get selectFromGallery => 'ဓာတ်ပုံတိုက်မှ ရွေးချယ်ရန်';

  @override
  String get tapToSelectImage => 'ပုံရွေးရန် နှိပ်ပါ';

  @override
  String get save => 'သိမ်းဆည်းရန်';

  @override
  String get update => 'အပ်ဒိတ်လုပ်ရန်';

  @override
  String get saved => 'ထည့်သွင်းပြီးပါပြီ';

  @override
  String get updated => 'အပ်ဒိတ်လုပ်ပြီးပါပြီ';

  @override
  String get enterTicketNumber => 'ဘောင်ချာနံပါတ် ထည့်ပါ';

  @override
  String get enterDescription => 'ဖော်ပြချက် ထည့်ပါ';

  @override
  String duplicateTicketNumber(String ticketNumber) {
    return 'ဘောင်ချာနံပါတ် \"$ticketNumber\" သည် မှတ်ပုံတင်ပြီးဖြစ်သည်';
  }

  @override
  String get passwordChangeTitle => 'စကားဝှက် ပြောင်းလဲရန်';

  @override
  String get appPasswordSection => 'သာမန် စကားဝှက် (ဝန်ထမ်းသုံး)';

  @override
  String get adminCodeSection => 'စီမံခန့်ခွဲသူ ကုဒ်';

  @override
  String get currentPassword => 'လက်ရှိ စကားဝှက်';

  @override
  String get newPassword => 'စကားဝှက် အသစ်';

  @override
  String get confirmPassword => 'စကားဝှက် အသစ် (အတည်ပြုရန်)';

  @override
  String get currentAdminCode => 'လက်ရှိ စီမံခန့်ခွဲသူ ကုဒ်';

  @override
  String get newAdminCode => 'စီမံခန့်ခွဲသူ ကုဒ် အသစ်';

  @override
  String get confirmAdminCode => 'စီမံခန့်ခွဲသူ ကုဒ် အသစ် (အတည်ပြုရန်)';

  @override
  String get saveChanges => 'ပြောင်းလဲမှုကို သိမ်းဆည်းရန်';

  @override
  String get wrongCurrentPassword => 'လက်ရှိ စကားဝှက် မှားနေပါသည်';

  @override
  String get wrongCurrentAdminCode => 'လက်ရှိ စီမံခန့်ခွဲသူ ကုဒ် မှားနေပါသည်';

  @override
  String get enterNewPassword => 'စကားဝှက် အသစ် ထည့်ပါ';

  @override
  String get enterNewAdminCode => 'စီမံခန့်ခွဲသူ ကုဒ် အသစ် ထည့်ပါ';

  @override
  String get passwordMismatch => 'စကားဝှက် အသစ် မတူညီပါ';

  @override
  String get adminCodeMismatch => 'စီမံခန့်ခွဲသူ ကုဒ် အသစ် မတူညီပါ';

  @override
  String get passwordChanged => 'စကားဝှက် ပြောင်းလဲပြီးပါပြီ';

  @override
  String get adminCodeChanged => 'စီမံခန့်ခွဲသူ ကုဒ် ပြောင်းလဲပြီးပါပြီ';

  @override
  String get languageSettings => 'ဘာသာစကား ရွေးချယ်ရန်';

  @override
  String get japanese => 'ဂျပန်ဘာသာ';

  @override
  String get myanmar => 'မြန်မာဘာသာ';

  @override
  String get clearButton => 'C';
}
