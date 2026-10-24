// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'المخطط المالي';

  @override
  String unitName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'AED': 'درهم إماراتي',
      'AUD': 'دولار أسترالي',
      'BDT': 'تاكا بنغلاديشي',
      'BHD': 'دينار بحريني',
      'CAD': 'دولار كندي',
      'CHF': 'فرنك سويسري',
      'CNY': 'يوان صيني',
      'DKK': 'كرونة دنماركية',
      'DZD': 'دينار جزائري',
      'EGP': 'جنيه مصري',
      'EUR': 'يورو',
      'GBP': 'جنيه إسترليني',
      'HKD': 'دولار هونغ كونغ',
      'IDR': 'روبية إندونيسية',
      'INR': 'روبية هندية',
      'JOD': 'دينار أردني',
      'JPY': 'ين ياباني',
      'KWD': 'دينار كويتي',
      'MAD': 'درهم مغربي',
      'MYR': 'رينغيت ماليزي',
      'NGN': 'نايرا نيجيرية',
      'NOK': 'كرونة نرويجية',
      'OMR': 'ريال عماني',
      'PKR': 'روبية باكستانية',
      'QAR': 'ريال قطري',
      'SAR': 'ريال سعودي',
      'SEK': 'كرونة سويدية',
      'SGD': 'دولار سنغافوري',
      'TND': 'دينار تونسي',
      'TRY': 'ليرة تركية',
      'USD': 'دولار أمريكي',
      'XAG_g': 'فضة بالغرام (999)',
      'XAU_g': 'ذهب بالغرام (عيار 24)',
      'ZAR': 'راند جنوب أفريقي',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'ARE': 'الإمارات',
      'AUS': 'أستراليا',
      'BGD': 'بنغلاديش',
      'BHR': 'البحرين',
      'CAN': 'كندا',
      'CHE': 'سويسرا',
      'CHN': 'الصين',
      'DNK': 'الدنمارك',
      'DZA': 'الجزائر',
      'EGY': 'مصر',
      'EMU': 'منطقة اليورو',
      'GBR': 'المملكة المتحدة',
      'HKG': 'هونغ كونغ',
      'IDN': 'إندونيسيا',
      'IND': 'الهند',
      'JOR': 'الأردن',
      'JPN': 'اليابان',
      'KWT': 'الكويت',
      'MAR': 'المغرب',
      'MYS': 'ماليزيا',
      'NGA': 'نيجيريا',
      'NOR': 'النرويج',
      'OMN': 'عُمان',
      'PAK': 'باكستان',
      'QAT': 'قطر',
      'SAU': 'السعودية',
      'SGP': 'سنغافورة',
      'SWE': 'السويد',
      'TUN': 'تونس',
      'TUR': 'تركيا',
      'USA': 'الولايات المتحدة',
      'ZAF': 'جنوب أفريقيا',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String marketName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'tadawul': 'تداول',
      'egx': 'البورصة المصرية',
      'nasdaq': 'ناسداك',
      'nyse': 'بورصة نيويورك',
      'lse': 'بورصة لندن',
      'dfm': 'سوق دبي المالي',
      'adx': 'سوق أبوظبي',
      'boursaKuwait': 'بورصة الكويت',
      'qse': 'بورصة قطر',
      'bursaMalaysia': 'بورصة ماليزيا',
      'bist': 'بورصة إسطنبول',
      'psx': 'بورصة باكستان',
      'otherMarket': 'سوق أخرى',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get done => 'تم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get change => 'تغيير';

  @override
  String get source => 'المصدر';

  @override
  String get close => 'إغلاق';

  @override
  String get add => 'إضافة';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get setupBaseTitle => 'بأي عملة تحسب ثروتك؟';

  @override
  String get setupBaseHelp =>
      'تُستخدم هذه العملة في الإجماليات والأرقام الشهرية والسنوية وفي المبلغ المخصص للزكاة. يمكنك تغييرها لاحقًا.';

  @override
  String homeInflationLine(String country, String currency) {
    return 'التضخم المحلي: $country (من $currency)';
  }

  @override
  String get setupZakatTitle => 'كيف تحسب الزكاة؟';

  @override
  String get zakatYearTitle => 'السنة الزكوية';

  @override
  String get zakatYearLunar => 'قمرية — 2.5 % على 354 يومًا';

  @override
  String get zakatYearSolar => 'شمسية — 2.577 % على 365 يومًا (أيوفي)';

  @override
  String get zakatYearWhy =>
      'يجيز بعض العلماء السنة الشمسية بنسبة معدّلة، ويلتزم آخرون بالسنة القمرية.';

  @override
  String get longTermTitle => 'الأسهم والصناديق المقتناة للأجل الطويل';

  @override
  String get longTermDividendsOnly =>
      'الأرباح الموزعة فقط (مجمع الفقه الإسلامي الدولي)';

  @override
  String get longTermProxy25 => '25 % من القيمة (تقدير صندوق الزكاة الوطني)';

  @override
  String get longTermFullValue => 'القيمة كاملة (احتياطًا)';

  @override
  String get longTermPerItem => 'سأقرر لكل استثمار على حدة';

  @override
  String get longTermNotNow => 'ليس الآن';

  @override
  String get longTermWhy => 'عند عدم معرفة بيانات الشركة تختلف طرق العلماء.';

  @override
  String get addInvestment => 'إضافة استثمار';

  @override
  String get assumptions => 'الافتراضات';

  @override
  String asOfDate(String date) {
    return 'بتاريخ $date';
  }

  @override
  String get showIn => 'العرض بـ';

  @override
  String get viewGold => 'ذهب (غرام)';

  @override
  String get viewSilver => 'فضة (غرام)';

  @override
  String excludesItems(String count, String pairs) {
    return 'يستثني $count — سعر الصرف غير متوفر: $pairs';
  }

  @override
  String verdictKept(String year, String amount) {
    return '$year حتى الآن: حافظت القوة الشرائية بزيادة $amount';
  }

  @override
  String verdictLost(String year, String amount) {
    return '$year حتى الآن: فقدت القوة الشرائية $amount';
  }

  @override
  String verdictNotAvailable(String year) {
    return '$year حتى الآن: القوة الشرائية غير متاحة';
  }

  @override
  String inflationShipped(String country, String source, String year) {
    return 'تضخم $country: مضمّن في التطبيق ($source، حتى $year)';
  }

  @override
  String inflationYours(String country) {
    return 'تضخم $country: قيمك أنت';
  }

  @override
  String inflationAssumed(String year) {
    return 'التضخم مفترض من سنة $year';
  }

  @override
  String inflationEmpty(String country) {
    return 'لا توجد بيانات تضخم لـ $country';
  }

  @override
  String staleBanner(String values, String rates) {
    return 'لم تُحدَّث هذا الشهر: $values قيم، $rates أسعار';
  }

  @override
  String get updateAll => 'تحديث الكل';

  @override
  String get sortLabel => 'الترتيب';

  @override
  String get sortValue => 'القيمة';

  @override
  String get sortReturn => 'العائد منذ البداية';

  @override
  String get sortName => 'الاسم';

  @override
  String get sortOldest => 'الأقدم تحديثًا أولًا';

  @override
  String closedSection(String count) {
    return 'مغلقة ($count)';
  }

  @override
  String get notUpdatedThisMonth => 'لم تُحدَّث هذا الشهر';

  @override
  String get metalRateNotUpdated => 'سعر المعدن لم يُحدَّث هذا الشهر';

  @override
  String rateMissingAdd(String from, String to) {
    return 'سعر $from→$to غير متوفر · أضِفه';
  }

  @override
  String get emptyTitle => 'لا توجد استثمارات بعد.';

  @override
  String get dataStaysOnPhone => 'بياناتك تبقى على هذا الهاتف.';

  @override
  String get presetMonthlyFund => 'صندوق شهري';

  @override
  String get presetGold => 'ذهب';

  @override
  String get presetStock => 'سهم';

  @override
  String pureGrams(String grams) {
    return '$grams صافٍ';
  }

  @override
  String typeAndMarket(String type, String market) {
    return '$type · $market';
  }

  @override
  String amountWithUnit(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get pickUnit => 'اختر وحدة';

  @override
  String get searchUnits => 'ابحث بالرمز أو الاسم';

  @override
  String get mostUsed => 'الأكثر استخدامًا';

  @override
  String get allUnits => 'كل الوحدات';

  @override
  String get chooseCountry => 'اختر دولة';

  @override
  String get typeStock => 'سهم';

  @override
  String get typeFund => 'صندوق / ETF';

  @override
  String get typeSukuk => 'صكوك';

  @override
  String get typeGold => 'ذهب';

  @override
  String get typeSilver => 'فضة';

  @override
  String get typeCash => 'وديعة نقدية';

  @override
  String get typeCrypto => 'عملات رقمية';

  @override
  String get typeOther => 'أخرى';

  @override
  String get intentTrading => 'متاجرة';

  @override
  String get intentLongTerm => 'طويل الأجل';

  @override
  String get intentPersonalUse => 'استعمال شخصي';

  @override
  String get intentRental => 'تأجير';

  @override
  String get openSection => 'مفتوحة';

  @override
  String get somethingWrong => 'حدث خطأ ما.';

  @override
  String get whyWhat => 'ما هذا';

  @override
  String get whyNumbers => 'أرقامك';

  @override
  String get whyAssumptions => 'الافتراضات المستخدمة';

  @override
  String get whySource => 'المصدر';

  @override
  String get sourceUnverified => 'المصدر لم يُتحقق منه بعد';

  @override
  String get src_A1A2 =>
      '2.5 % من الوعاء الزكوي مرة كل سنة قمرية: سنن أبي داود 1573 (A1). والسنة الشمسية بنسبة 2.577 %: المعيار الشرعي رقم 35 لأيوفي كما نقلته مؤسسة الزكاة الوطنية في بريطانيا (A2) — رقم البند لم يُتحقق منه بعد. ويرى آخرون (الحنفية، دار الإفتاء بجنوب أفريقيا) بقاء النسبة 2.5 % والتاريخ القمري.';

  @override
  String get src_B1 =>
      'النقود والأرصدة المصرفية تجب فيها الزكاة كاملة: القرآن 9:34–35؛ سنن أبي داود 1573؛ قرار مجمع الفقه 21 (9/3) (B1).';

  @override
  String get src_B2 =>
      'الذهب والفضة المدخران: الزكاة على القيمة السوقية (القرآن 9:34؛ أبو داود 1573). الحلي المستعمل: يرى الحنفية وجوب الزكاة (أبو داود 1563) ويرى المالكية والشافعية والحنابلة عدمه (B2).';

  @override
  String get src_B3 =>
      'أسهم المتاجرة: 100 % من القيمة السوقية (قرار المجمع 28 (3/4) §3، 121 (3/13)). المقتناة للأجل الطويل دون بيانات الشركة: الأرباح الموزعة فقط (قرار 28 §3)، أو 25 % من القيمة تقديرًا (مؤسسة الزكاة الوطنية في بريطانيا)، أو القيمة كاملة احتياطًا. والشركة التي تخرج زكاتها بنفسها لا يزكي المساهم عن سهمه ثانية (قرار 28 §1) (B3).';

  @override
  String get src_B4 =>
      'الصناديق المتداولة تتبع أحكام الأسهم على مستوى الصندوق. الصكوك: 100 % من القيمة الاسمية أو السوقية افتراضيًا مع إمكان التعديل (B4)؛ أرقام بنود معياري أيوفي 35 و17 لم يُتحقق منها بعد.';

  @override
  String get src_B5 =>
      'العقار المخصص للاستعمال الشخصي لا زكاة فيه. العقار المؤجر: لا زكاة في العقار نفسه، وما بقي من الأجرة يضم إلى النقود (قرار المجمع 2 (2/2)). وما اشتُري للبيع: 100 % من القيمة السوقية (B5).';

  @override
  String get src_B8 =>
      'يختلف العلماء في جواز اقتناء العملات الرقمية (لم يصدر المجمع حكمًا نهائيًا في قراره 237 (8/24)). ومن أجازها قال بوجوب الزكاة في قيمتها السوقية كاملة (B8).';

  @override
  String get src_Z6 =>
      'الفوائد ليست من مال المالك: فهي ليست عائدًا ولا تدخل في الوعاء الزكوي ويُتخلص منها (القرآن 2:278–279). والتخلص منها لا يُحتسب زكاة (B1). رقم البند في المعيار الشرعي 21 لأيوفي لم يُتحقق منه بعد.';

  @override
  String get src_A6 =>
      'الزكاة تكون دائمًا على القيمة الفعلية يوم وجوبها لا على قيمة معدّلة بالتضخم (قرار المجمع 28 (3/4) §3). ويُعرض العائد الحقيقي للتخطيط فقط (A6).';

  @override
  String get src_A3 =>
      'النصاب: الذهب 85 غرامًا (20 دينارًا) والفضة 595 غرامًا (200 درهم): أبو داود 1573؛ البخاري 1447؛ مسلم 979. واختيار المعدن المعتمد للنقود محل خلاف (A3).';

  @override
  String get sourceName => 'البنك الدولي';

  @override
  String get verdictCaption => 'بعد المخصص الزكوي وبعد التضخم المحلي';

  @override
  String get rateMissingTitle => 'سعر الصرف غير متوفر';

  @override
  String get openSource => 'المصدر';

  @override
  String returnLine(String date) {
    return 'العائد (منذ $date)';
  }

  @override
  String valueFromDate(String date) {
    return 'القيمة بتاريخ $date';
  }

  @override
  String get whyToPurifyTitle => 'فوائد ربوية للتطهير';

  @override
  String get whyToPurifyWhat =>
      'كل الفوائد المسجلة مطروحًا منها ما تم التخلص منه. ليست عائدًا ولا تدخل في الوعاء الزكوي. والتخلص منها لا يُحتسب زكاة. ولا تُخصم أبدًا من المبلغ المخصص للزكاة.';

  @override
  String get formTitleAdd => 'إضافة استثمار';

  @override
  String get formTitleEdit => 'تعديل الاستثمار';

  @override
  String get fieldName => 'الاسم';

  @override
  String get fieldType => 'النوع';

  @override
  String get fieldMarket => 'السوق';

  @override
  String get fieldMarketCountry => 'دولة السوق';

  @override
  String get fieldUnit => 'وحدة الاستثمار';

  @override
  String get fieldStartDate => 'تاريخ البداية';

  @override
  String get fieldPaid => 'المبلغ المدفوع (أول إيداع)';

  @override
  String get fieldPaidUnit => 'المدفوع بوحدة';

  @override
  String get fieldCurrentValue => 'القيمة الحالية (اختياري)';

  @override
  String get fieldValueDate => 'تاريخ القيمة';

  @override
  String get fieldQuantity => 'الكمية (اختياري)';

  @override
  String get fieldGrams => 'الغرامات (إجمالي)';

  @override
  String get fieldPurity => 'العيار';

  @override
  String get fieldIntent => 'النية';

  @override
  String get fieldShare => 'نسبة الزكاة ( % من القيمة)';

  @override
  String get fieldNotes => 'ملاحظات (اختياري)';

  @override
  String karat(String k) {
    return 'عيار $k';
  }

  @override
  String fineness(String k) {
    return 'نقاء $k';
  }

  @override
  String pureGramsPreview(String grams) {
    return '= $grams صافٍ';
  }

  @override
  String get errName => 'أدخل اسمًا';

  @override
  String get errType => 'اختر النوع';

  @override
  String get errIntent => 'اختر النية';

  @override
  String get errMarket => 'اختر السوق';

  @override
  String get errMarketCountry => 'اختر دولة السوق';

  @override
  String get errUnit => 'اختر وحدة';

  @override
  String get errStartDate => 'اختر تاريخ البداية';

  @override
  String get errFirstPaid => 'أدخل المبلغ المدفوع';

  @override
  String get errGrams => 'أدخل الغرامات';

  @override
  String get errPurity => 'اختر العيار';

  @override
  String get errZero => 'يجب أن يكون أكبر من صفر';

  @override
  String get errFuture => 'لا يمكن أن يكون التاريخ في المستقبل';

  @override
  String get errShare => 'أدخل نسبة الزكاة من 0 إلى 100 %';

  @override
  String get errLongTerm => 'اختر طريقة التعامل مع الأسهم طويلة الأجل';

  @override
  String get errJewellery => 'اختر حكم الحلي';

  @override
  String errSummary(String count) {
    return '$count حقول تحتاج إلى انتباه';
  }

  @override
  String get errSave => 'تعذّر الحفظ. لم يتغير شيء. حاول مرة أخرى.';

  @override
  String get savedToast => 'تم الحفظ';

  @override
  String get discardTitle => 'تجاهل هذا الاستثمار؟';

  @override
  String get discard => 'تجاهل';

  @override
  String get keepEditing => 'متابعة التعديل';

  @override
  String zakatLinePercent(String share) {
    return 'الزكاة: على $share من القيمة';
  }

  @override
  String get zakatLineDividends =>
      'الزكاة: على الأرباح الموزعة فقط عند استلامها';

  @override
  String get zakatLineCompany => 'الزكاة: 0 % — الشركة تخرج زكاتها';

  @override
  String get zakatNeedsChoice =>
      'الزكاة: لم تُحدد بعد — أجب عن سؤال الزكاة في هذا النموذج';

  @override
  String get zakatReasonTrading =>
      'تحتفظ بهذا للبيع. وعروض التجارة تُزكى بنسبة 2.5 % من قيمتها السوقية.';

  @override
  String get zakatReasonSavings =>
      'محتفظ به ادخارًا: الزكاة على القيمة السوقية.';

  @override
  String get zakatReasonCash => 'النقود تجب فيها الزكاة كاملة.';

  @override
  String get zakatReasonSukuk => 'الصكوك: 100 % من القيمة افتراضيًا.';

  @override
  String get zakatReasonJewellery => 'الحلي المستعمل: وفق حكمك.';

  @override
  String get zakatReasonCustom => 'حددت هذه النسبة بنفسك.';

  @override
  String get noticeDividends =>
      'يُخصص مبلغ للزكاة عن الأرباح الموزعة المستلمة من هذا الاستثمار (قرار المجمع 28 (3/4)). لا تسجلها مرة أخرى في استثمار نقدي.';

  @override
  String get noticeCrypto =>
      'يختلف العلماء في جواز اقتناء العملات الرقمية. ومن أجازها قال بوجوب الزكاة في قيمتها السوقية كاملة.';

  @override
  String get companyPays => 'الشركة تخرج الزكاة عني (0 %)';

  @override
  String get jewelleryAsk => 'هل تجب الزكاة في الحلي المستعمل؟';

  @override
  String get jewelleryYes => 'تجب فيه الزكاة';

  @override
  String get jewelleryNo => 'لا تجب فيه الزكاة';

  @override
  String get jewelleryWhy => 'تختلف المذاهب في الحلي المستعمل.';

  @override
  String get hintLongTerm =>
      'أدخل الجزء الزكوي من النشاط: النقد والديون المرجوة والبضاعة المعدة للبيع مطروحًا منها الديون قصيرة الأجل. لا تُحتسب الآلات والمباني.';

  @override
  String get hintRental =>
      'لا زكاة في العقار نفسه، وما بقي معك من الأجرة يُضم إلى نقودك. غالبًا 0 %.';

  @override
  String get hintPersonalUse => 'ما كان للاستعمال الشخصي: غالبًا 0 %.';

  @override
  String get hintTrading => 'ما اشتُري للبيع: غالبًا 100 % من القيمة السوقية.';

  @override
  String useShare(String share) {
    return 'استخدم $share %';
  }

  @override
  String inlineRateLabel(String from, String to, String date) {
    return '1 $from = ____ $to بتاريخ $date';
  }

  @override
  String get inlineRateField => 'السعر';

  @override
  String get rateSaved => 'تم حفظ السعر';

  @override
  String get fetchRate => 'جلب';

  @override
  String get errRate => 'أدخل سعرًا أكبر من صفر';

  @override
  String get deleteInvestment => 'حذف الاستثمار';

  @override
  String get deleteConfirm => 'حذف الاستثمار وكل سجله؟';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'تراجع';

  @override
  String get deleted => 'تم الحذف';

  @override
  String get edit => 'تعديل';

  @override
  String get valueNow => 'القيمة الآن';

  @override
  String approxInBase(String amount) {
    return '≈ $amount';
  }

  @override
  String get sinceStart => 'منذ البداية';

  @override
  String colItem(String unit) {
    return 'بـ $unit';
  }

  @override
  String get rowGain => 'الربح';

  @override
  String get rowReturn => 'العائد';

  @override
  String get rowPerYear => 'سنويًا';

  @override
  String get rowSetAside => 'المخصص التقديري للزكاة (للتخطيط)';

  @override
  String get setAsideNote => 'الزكاة الفعلية تجب مرة في السنة في يوم وجوبها.';

  @override
  String get rowReturnAfter => 'العائد بعد المخصص';

  @override
  String rowRealOwn(String country) {
    return 'حقيقي · سوق الأصل ($country)';
  }

  @override
  String rowRealBase(String country) {
    return 'حقيقي · بعملتك ($country)';
  }

  @override
  String get realLabel =>
      'القوة الشرائية (للتخطيط فقط — الزكاة دائمًا على القيمة الفعلية اليوم)';

  @override
  String get byMonthYear => 'حسب الشهر والسنة';

  @override
  String needsRate(String from, String to) {
    return 'يحتاج سعر $from→$to';
  }

  @override
  String toPurifyItem(String amount) {
    return 'فوائد ربوية للتطهير: $amount · لا تُحتسب عائدًا';
  }

  @override
  String get recordGivenAway => 'تسجيل ما تم التخلص منه';

  @override
  String get history => 'السجل';

  @override
  String get record => 'تسجيل';

  @override
  String closedOn(String date) {
    return 'أُغلق بتاريخ $date';
  }

  @override
  String get kindMoneyIn => 'إيداع';

  @override
  String get kindSale => 'بيع';

  @override
  String get kindIncome => 'دخل مُستلم';

  @override
  String get kindValue => 'تحديث القيمة';

  @override
  String get kindInterestKept => 'فوائد باقية داخل الاستثمار';

  @override
  String get kindInterestPaid => 'فوائد مدفوعة لي';

  @override
  String get kindGivenInside => 'فوائد تم التخلص منها (من داخل الاستثمار)';

  @override
  String get kindGivenPaid => 'فوائد تم التخلص منها (من المدفوعة)';

  @override
  String get tabValue => 'القيمة';

  @override
  String get tabIn => 'إيداع';

  @override
  String get tabOut => 'سحب';

  @override
  String get tabInterest => 'فوائد';

  @override
  String get interestReceived => 'مستلمة';

  @override
  String get interestGivenAway => 'تم التخلص منها';

  @override
  String get interestWhere => 'أين هي؟';

  @override
  String get interestPaidOut => 'مدفوعة لي';

  @override
  String get interestKeptInside => 'باقية داخل الاستثمار';

  @override
  String get interestNote =>
      'لا تُحتسب الفوائد عائدًا ولا تدخل في الوعاء الزكوي. وتظهر \"للتخلص منها\" لتتخلص منها.';

  @override
  String get givenFrom => 'التخلص منها من';

  @override
  String get givenAwayNote => 'التخلص من الفوائد لا يُحتسب زكاة.';

  @override
  String get effectKept =>
      'يخفض قيمة الاستثمار والمطلوب التخلص منه بالمقدار نفسه. العائد لا يتأثر.';

  @override
  String get effectPaid => 'يخفض المطلوب التخلص منه. قيمة الاستثمار لا تتغير.';

  @override
  String get fieldAmount => 'المبلغ';

  @override
  String get fieldDate => 'التاريخ';

  @override
  String get fieldValue => 'القيمة';

  @override
  String get fieldValueAfter => 'القيمة بعد العملية (اختياري)';

  @override
  String get fieldValueLeft => 'القيمة المتبقية';

  @override
  String get incomeNoValueChange => 'الدخل لا يغيّر قيمة الاستثمار.';

  @override
  String get fieldKind => 'النوع';

  @override
  String lastValue(String value, String date) {
    return 'آخر قيمة: $value بتاريخ $date';
  }

  @override
  String typoCheck(String times) {
    return 'هذا $times أضعاف آخر قيمة. تحقق من الرقم.';
  }

  @override
  String get valueLeftRequired =>
      'هذا أكبر من قيمة الاستثمار. أدخل ما تبقى (صفر أو أكثر).';

  @override
  String get closesInvestment =>
      'سيُغلق هذا الاستثمار ويبقى في الأشهر السابقة.';

  @override
  String errBeforeStart(String date) {
    return 'لا يمكن أن يكون قبل تاريخ البداية ($date)';
  }

  @override
  String errGivenTooMuch(String amount) {
    return 'لديك $amount من الفوائد المتبقية للتخلص منها هناك. أدخل هذا المبلغ أو أقل.';
  }

  @override
  String replaceValueTitle(String date) {
    return 'استبدال قيمة $date؟';
  }

  @override
  String get replace => 'استبدال';

  @override
  String get nothingToPurify => 'لا توجد فوائد متبقية للتخلص منها.';

  @override
  String get perUnit => 'للوحدة';

  @override
  String get total => 'الإجمالي';

  @override
  String get zakatSectionTitle => 'الزكاة';

  @override
  String get whyReturnTitle => 'العائد';

  @override
  String get whyReturnWhat =>
      'عائد موزون بالمال (طريقة ديتز المعدلة): الإيداعات ليست ربحًا. وقد يختلف في الفترات الطويلة ذات التدفقات الكبيرة عن العائد الموزون الدقيق.';

  @override
  String whyReturnNumbers(String r, String ev, String bv, String cf, String d) {
    return '$r = ($ev − $bv − $cf) ÷ $d  (القيمة النهائية − قيمة البداية − الإيداعات والسحوبات ÷ متوسط المال المستثمر)';
  }

  @override
  String get whySetAsideTitle => 'المخصص التقديري للزكاة (للتخطيط)';

  @override
  String get whySetAsideWhat =>
      'النسبة × نسبة الزكاة × القيمة النهائية × الأيام ÷ طول السنة، مضافًا إليها النسبة × الأرباح الموزعة المستلمة (طريقة الأرباح فقط)، وفق الزوج المتطابق الذي اخترته. الزكاة الفعلية تجب مرة في السنة في يوم وجوبها.';

  @override
  String whySetAsideNumbers(
    String z,
    String rate,
    String share,
    String ev,
    String days,
    String year,
    String dividends,
  ) {
    return '$z = $rate × $share × $ev × $days ÷ $year + $rate × $dividends';
  }

  @override
  String get whyRealTitle => 'العائد الحقيقي';

  @override
  String get whyRealWhat =>
      '(1 + العائد) ÷ (1 + التضخم) − 1. للتخطيط فقط ولا يغيّر الوعاء الزكوي.';

  @override
  String whyRealNumbers(String r, String i, String real) {
    return 'العائد $r، التضخم $i ← $real';
  }

  @override
  String get whyGapTitle => 'فرق القوة الشرائية';

  @override
  String get whyGapWhat =>
      '(القيمة النهائية − المخصص) مقارنة بـ (قيمة البداية + الإيداعات والسحوبات + التضخم على متوسط المال المستثمر). صفر أو أكثر يعني أن القوة الشرائية حُفظت.';

  @override
  String whyGapNumbers(String gap, String needed) {
    return 'الفرق $gap؛ القيمة النهائية المطلوبة $needed';
  }

  @override
  String get whyShareTitle => 'نسبة الزكاة';

  @override
  String get whyInflationTitle => 'التضخم';

  @override
  String get whyInflationWhat =>
      'معدلات السلسلة السنوية موزعة على أيام هذه الفترة.';

  @override
  String get monthsYears => 'حسب الشهر والسنة';

  @override
  String get updateAllTitle => 'تحديث الكل';

  @override
  String get refreshRates => 'تحديث الأسعار عبر الإنترنت';

  @override
  String get refreshHelp =>
      'ينزّل قائمة الأسعار العامة نفسها للجميع. لا يُرسل أي شيء عنك.';

  @override
  String lastRefresh(String date, String source) {
    return 'آخر تحديث: أسعار بتاريخ $date · $source';
  }

  @override
  String get refreshRunning => 'جارٍ التحديث…';

  @override
  String refreshDone(String date, String source, String count) {
    return 'أسعار بتاريخ $date · $source · تم تحديث $count من أسعارك';
  }

  @override
  String get refreshFailed =>
      'تعذّر التحديث. لم يتغير شيء. ما زالت أسعارك المحفوظة مستخدمة — اكتب سعرًا أدناه إن توفر لديك أحدث.';

  @override
  String get refreshSource => 'currency-api (fawazahmed0)';

  @override
  String get asOfLabel => 'بتاريخ';

  @override
  String get showAll => 'عرض الكل';

  @override
  String get ratesStillOld => 'أسعار ما زالت قديمة';

  @override
  String get valuesHeading => 'القيم';

  @override
  String get same => 'كما هي';

  @override
  String filledCount(String filled, String total) {
    return 'تمت تعبئة $filled من $total';
  }

  @override
  String updatedToast(String count, String left) {
    return 'تم تحديث $count قيم. بقي $left قديمة.';
  }

  @override
  String get ratesSavedValuesNot =>
      'حُفظت الأسعار ولم تُحفظ القيم — حاول مرة أخرى';

  @override
  String allUpToDate(String month) {
    return 'كل شيء محدّث لشهر $month';
  }

  @override
  String saveUpdatesTitle(String count) {
    return 'حفظ $count تحديثات؟';
  }

  @override
  String lastHint(String value, String date) {
    return 'آخر قيمة $value · $date';
  }

  @override
  String rateRowLabel(String from, String to) {
    return '1 $from = ____ $to';
  }

  @override
  String get periodTitle => 'عرض الفترات';

  @override
  String get allInvestments => 'كل الاستثمارات';

  @override
  String get monthLabel => 'شهر';

  @override
  String get yearLabel => 'سنة';

  @override
  String rowInflation(String country) {
    return 'التضخم ($country)';
  }

  @override
  String get rowRealAfter => 'العائد الحقيقي بعد المخصص';

  @override
  String rowRealBefore(String value) {
    return 'العائد الحقيقي قبل المخصص: $value';
  }

  @override
  String inflationForPeriod(String value) {
    return '$value لهذه الفترة';
  }

  @override
  String get verdictKeptTitle => 'حافظت القوة الشرائية بعد المخصص';

  @override
  String get verdictLostTitle => 'فقدت القوة الشرائية بعد المخصص';

  @override
  String neededEnd(String value, String pct) {
    return 'المطلوب: قيمة نهائية $value (عائد $pct)';
  }

  @override
  String lostGrams(String value) {
    return 'خسارة $value بعد المخصص';
  }

  @override
  String keptGrams(String value) {
    return 'زيادة $value بعد المخصص';
  }

  @override
  String get yardstick =>
      'الذهب مقياس وليس مؤشر أسعار. بالذهب يكون الغرام هو المقياس: لا توجد خطوة تضخم.';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get notAvailableWhy =>
      'متوسط المال المستثمر في هذه الفترة صفر أو أقل.';

  @override
  String markersStale(String count) {
    return '$count استثمارات لم تُحدَّث في هذه الفترة';
  }

  @override
  String get markerStaleRate => 'السعر لم يُحدَّث في هذه الفترة';

  @override
  String get markerNotUpdated => 'القيمة لم تُحدَّث';

  @override
  String get itemsHeading => 'الاستثمارات';

  @override
  String get excludedHeading => 'مستثناة';

  @override
  String excludedLine(String name, String from, String to) {
    return '$name — سعر $from→$to غير متوفر';
  }

  @override
  String basedOn(String count, String total) {
    return 'بناءً على $count من $total استثمارات';
  }

  @override
  String toPurifyPeriod(String amount) {
    return 'فوائد ربوية للتطهير: $amount — ليست في العائد ولا تُخصم من المخصص';
  }

  @override
  String noZakatSwitch(String year) {
    return 'لا زكاة مستحقة لسنة $year';
  }

  @override
  String get noZakatHelp =>
      'قرّر بالنظر إلى كل مالك الزكوي لا إلى هذه القائمة وحدها.';

  @override
  String get noZakatEffect => '0 — لا زكاة مستحقة هذه السنة';

  @override
  String nisabGold(String amount) {
    return 'النصاب: 85 غرامًا من الذهب = $amount';
  }

  @override
  String nisabSilver(String amount) {
    return 'النصاب: 595 غرامًا من الفضة = $amount';
  }

  @override
  String get nisabNoGold => 'أضِف سعر الذهب لترى النصاب';

  @override
  String get nisabNoSilver => 'أضِف سعر الفضة لترى النصاب';

  @override
  String zakatableTotal(String amount) {
    return 'إجمالي الوعاء الزكوي في هذه القائمة: $amount';
  }

  @override
  String get otherPeriods => 'فترات أخرى';

  @override
  String get measureReturn => 'العائد';

  @override
  String get measureAfter => 'بعد المخصص';

  @override
  String get measureReal => 'حقيقي بعد المخصص';

  @override
  String get assumptionsTitle => 'الافتراضات';

  @override
  String get baseAndHome => 'العملة الأساسية والتضخم المحلي';

  @override
  String baseLine(String currency) {
    return 'العملة الأساسية: $currency';
  }

  @override
  String get baseChangeWarning => 'ستُعاد حسابات كل الإجماليات والأشهر.';

  @override
  String get ratesHeading => 'الأسعار';

  @override
  String rateLine(String from, String rate, String to, String date) {
    return '1 $from = $rate $to · بتاريخ $date';
  }

  @override
  String get rateTagTyped => 'أدخلته أنت';

  @override
  String rateTagFetched(String source) {
    return '$source';
  }

  @override
  String rateTypedUsed(String rate) {
    return 'يُستخدم سعرك (المصدر أعطى $rate)';
  }

  @override
  String get rateStaleMarker => 'لم يُحدَّث هذا الشهر';

  @override
  String get rateMissingMarker => 'غير متوفر';

  @override
  String get noRatesYet => 'تظهر الأسعار هنا عندما يحتاج استثمار إلى سعر.';

  @override
  String rateHistoryTitle(String from, String to) {
    return 'أسعار $from→$to';
  }

  @override
  String get addRate => 'إضافة سعر';

  @override
  String get editRate => 'تعديل السعر';

  @override
  String get swapDirection => 'عكس الاتجاه';

  @override
  String inverseLine(String to, String rate, String from) {
    return '1 $to = $rate $from';
  }

  @override
  String get rateFetchedNote =>
      'يمكن تجاوز الأسعار المجلوبة بكتابة سعر لليوم نفسه.';

  @override
  String get inflationHeading => 'التضخم';

  @override
  String inflationRow(String country) {
    return '$country';
  }

  @override
  String inflationYearLine(String year, String rate, String tag) {
    return '$year: $rate · $tag';
  }

  @override
  String get tagShipped => 'مضمّن';

  @override
  String get tagYours => 'لك';

  @override
  String tagAssumed(String year) {
    return 'مفترض من $year';
  }

  @override
  String get resetToShipped => 'العودة إلى المضمّن';

  @override
  String overrideTitle(String country, String year) {
    return '$country $year';
  }

  @override
  String get inflationPercentField => 'التضخم ( %)';

  @override
  String get errInflation => 'أدخل نسبة بين -50 و 1000 %';

  @override
  String emptySeries(String country) {
    return 'لا توجد بيانات لـ $country. أضِف سنة لترى الأرقام الحقيقية للاستثمارات التي تستخدمها.';
  }

  @override
  String get zakatHeading => 'الزكاة';

  @override
  String get jewelleryNotAsked => 'لم يُسأل بعد';

  @override
  String get noZakatByYear => 'عدم وجوب الزكاة حسب السنة';

  @override
  String get perItemRewritten =>
      'الاستثمارات التي كانت تتبع الطريقة السابقة تحتفظ بها الآن.';

  @override
  String get rateAddedToast => 'تم حفظ السعر';

  @override
  String get errRateFuture => 'لا يمكن أن يكون تاريخ السعر في المستقبل';

  @override
  String get customShareSwitch => 'أحدد نسبة الزكاة بنفسي';

  @override
  String zakatChangedFrom(String share) {
    return 'غيّرت هذا من $share';
  }

  @override
  String get moreSection => 'المزيد';

  @override
  String get inflationSeriesField => 'سلسلة التضخم';

  @override
  String get inflationSeriesDefault => 'الافتراضي لهذا الاستثمار';

  @override
  String get fetchFailed => 'تعذّر الجلب. اكتب السعر.';

  @override
  String fetchNotCovered(String from, String to) {
    return 'المصدر لا يوفر $from→$to. اكتبه.';
  }

  @override
  String fetchedRateLine(
    String from,
    String rate,
    String to,
    String date,
    String source,
  ) {
    return '1 $from = $rate $to · بتاريخ $date · $source';
  }

  @override
  String get src_B6 =>
      'ملكية نشاط تجاري: يزكي المالك حصته من الأصول الزكوية (النقد والديون المرجوة والبضاعة المعدة للبيع) مطروحًا منها الديون قصيرة الأجل، ولا زكاة في الأصول الثابتة (قرار المجمع 28 (3/4) §2). طريقة صافي الأصول في المعيار الشرعي 35 لأيوفي — رقم البند لم يُتحقق منه بعد (B6).';

  @override
  String get src_B7 =>
      'معاش تقاعدي بقيود على السحب: لا زكاة حتى يمكن الوصول إليه (د. مين القضاة، فتوى أمجا 21964)؛ أو الزكاة على المبلغ المتاح بعد الغرامة والضريبة (مجلس الفقه لأمريكا الشمالية — المصدر لم يُتحقق منه بعد)؛ أو الرصيد كاملًا احتياطًا (B7).';

  @override
  String get typePrivateEquity => 'ملكية خاصة';

  @override
  String get typePrivateEquityHint =>
      'حصة في نشاط تجاري غير مدرج في سوق — مثل مشروع صديق.';

  @override
  String get fieldSharesInProject => 'حصص في المشروع (اختياري)';

  @override
  String get peIntentTrading => 'للبيع';

  @override
  String get peIntentLongTerm => 'طويل الأجل (لأجل ربحه)';

  @override
  String get zakatPeTrading =>
      'الزكاة: على 100 ٪ من القيمة. تحتفظ بها للبيع. — قرار المجمع 28 (3/4) §3.';

  @override
  String get peMethodKnown => 'نسبة زكوية معروفة';

  @override
  String get peMethodKnownSource => 'قرار المجمع 121 (3/13) §1';

  @override
  String get peMethodProfit => 'الزكاة على الربح المستلم فقط';

  @override
  String get peMethodFull => 'القيمة كاملة';

  @override
  String get peMethodFullNote => 'احتياطًا.';

  @override
  String get peMethodPick => 'اختر طريقة حساب الزكاة';

  @override
  String get peMethodsHelp =>
      'إذا كان المشروع يشتري البضائع ويبيعها في الغالب، فمعظم قيمته زكوية عادةً.';

  @override
  String noticeProfitPayoutsOnly(String rate) {
    return 'الزكاة: $rate من كل دفعة ربح تسجلها، لا من قيمة المشروع. تُحسب كل دفعة مرة واحدة.';
  }

  @override
  String get noticeCapitalBackIsDebt =>
      'هذا مثل مال أقرضته. الزكاة على المبلغ كاملًا، كدين لك. — قرار المجمع 1 (1/2).';

  @override
  String get zakatCaseC => 'الزكاة على 100 ٪.';

  @override
  String get q2CapitalBack => 'إذا خسر المشروع، هل يعود إليك مالك كله رغم ذلك؟';

  @override
  String get answerNo => 'لا';

  @override
  String get answerYes => 'نعم';

  @override
  String get answerNotSure => 'لست متأكدًا';

  @override
  String get q1ProfitBasis =>
      'هل هذه النسبة حصة من الربح الفعلي للمشروع، أم نسبة ثابتة من المال الذي وضعته؟';

  @override
  String get q1Share => 'حصة من الربح الفعلي';

  @override
  String get q1Fixed => 'نسبة ثابتة من مالي';

  @override
  String get errPickOne => 'اختر إجابة. «لست متأكدًا» مقبولة.';

  @override
  String get noticeCaseB =>
      'النسبة الثابتة من المال الذي وضعته ليست حصة ربح صحيحة. في الشراكة يجب أن يكون ربحك جزءًا من الربح الفعلي للمشروع. قد ترغب في تغيير الشروط مع شريكك.';

  @override
  String get noticeCaseC =>
      'يعود إليك مالك حتى لو خسر المشروع. هذا مثل القرض. والزيادة على القرض ربا. يعرض التطبيق هذه الدفعات «للتطهير»، لا ربحًا.';

  @override
  String get noticeCaseNotSure =>
      'اسأل شريكك سؤالين: هل ربحك جزء من الربح الفعلي؟ هل يمكن أن تخسر مالك؟ الإجابتان تحددان هل هذه شراكة أم قرض.';

  @override
  String get srcCaseB =>
      'قرار المجمع 30 (5/4) البند 4: لا ضمان لرأس المال ولا لربح مقطوع، وهذا الشرط باطل. المعيار الشرعي 13 لأيوفي §8/1 — لم يُتحقق منه بعد (B6.1).';

  @override
  String get srcCaseC =>
      'قرار المجمع 10 (10/2): الزيادة على القرض المشروطة في بدايته ربا. سورة البقرة 2:279 (B6.1).';

  @override
  String get srcCaseNotSure =>
      'قرار المجمع 30 (5/4): الربح في الشراكة حصة من الربح الفعلي (B6.1).';

  @override
  String get caseBTagPreview =>
      'سيُوسم هذا الاستثمار بـ«مخاطرة شرعية». تبقى الدفعات محسوبة عائدًا. · المصدر لم يُتحقق منه بعد';

  @override
  String get accountKindQuestion =>
      'هل هذا حساب إسلامي (حصة من الربح) أم حساب تقليدي (فائدة)؟';

  @override
  String get accountIslamic => 'حساب إسلامي (حصة من الربح)';

  @override
  String get accountConventional => 'حساب تقليدي (فائدة)';

  @override
  String get errPickAccountKind => 'اختر نوع الحساب';

  @override
  String get noticeConventional =>
      'هذه فائدة. سجّلها مالًا خارجًا «فائدة (للتطهير)»، لا دخلًا.';

  @override
  String get expectedTitle => 'المتوقع (اختياري)';

  @override
  String get expectedSubtitle =>
      'خطّط للدفعات أو لمراجعات القيمة. تقدير، لا وعد.';

  @override
  String get blockPayouts => 'الدفعات';

  @override
  String get blockValueChecks => 'مراجعات القيمة';

  @override
  String get fieldPayoutSchedule => 'جدول الدفعات';

  @override
  String get fieldValueCheckSchedule => 'جدول مراجعة القيمة';

  @override
  String get scheduleNone => 'بدون';

  @override
  String get scheduleMonthly => 'شهريًا';

  @override
  String get scheduleQuarterly => 'كل 3 أشهر';

  @override
  String get scheduleHalfYearly => 'كل 6 أشهر';

  @override
  String get scheduleYearly => 'سنويًا';

  @override
  String get fieldExpectedProfit => 'الربح المتوقع (تقديرك، ٪ سنويًا)';

  @override
  String get fieldExpectedGrowth => 'نمو القيمة المتوقع (تقديرك، ٪ سنويًا)';

  @override
  String get estimateHelp =>
      'تقدير، لا وعد. لا يُستخدم في الزكاة ولا في العائد.';

  @override
  String payoutPreview(String amount, int months, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months شهرًا',
      few: '$months أشهر',
      two: 'شهرين',
      one: 'شهر',
    );
    return '= $amount كل $_temp0 · أول دفعة في $date';
  }

  @override
  String growthPreview(String date, String amount) {
    return 'تقديرك في $date: $amount (إن لم يُضف شيء أو يُسحب).';
  }

  @override
  String get errPickPayoutSchedule => 'اختر جدول دفعات، أو امسح هذه النسبة.';

  @override
  String get errPickValueSchedule =>
      'اختر جدول مراجعة القيمة، أو امسح هذه النسبة.';

  @override
  String get errProfitPositive =>
      'يجب أن تكون أكبر من 0. اتركها فارغة إن لم توجد نسبة.';

  @override
  String get errGrowthTooLow => 'يجب أن تكون أكبر من −100 ٪.';

  @override
  String needsRateForEstimates(String pair, String date) {
    return 'يلزم سعر $pair في $date لعرض تقديراتك';
  }

  @override
  String get editRecalculates =>
      'سيُعاد حساب كل الأشهر الماضية لهذا الاستثمار.';

  @override
  String get editRowsRebuilt =>
      'يُعاد بناء صفوف التأكيد للتواريخ الجديدة. تبقى دفعاتك وقيمك المسجلة كما هي.';

  @override
  String editStartAfterRecord(String date) {
    return 'لا يمكن أن يكون بعد $date: لهذا الاستثمار سجل في ذلك التاريخ. انقل ذلك السجل أو احذفه أولًا.';
  }

  @override
  String editStartMaxDate(String date) {
    return 'آخر تاريخ مسموح: $date (أقدم سجل آخر لديك).';
  }

  @override
  String get editStartMoves =>
      'تنتقل أول دفعة إلى هذا التاريخ، ويُعاد حساب كل الأشهر الماضية لهذا الاستثمار.';

  @override
  String get editStartMovesMetal =>
      'تنتقل أول دفعة وجرامات البداية إلى هذا التاريخ، ويُعاد حساب كل الأشهر الماضية لهذا الاستثمار.';

  @override
  String toConfirmTitle(int count) {
    return 'للتأكيد · $count';
  }

  @override
  String get confirmAll => 'تأكيد الكل كما هو متوقع';

  @override
  String get confirmAllLine => 'أكّد فقط المال الذي وصل فعلًا.';

  @override
  String get confirmValueLine =>
      'أكّد فقط إذا كانت القيمة ما زالت قريبة من هذا.';

  @override
  String get rowPayout => 'دفعة متوقعة (لم تُستلم بعد)';

  @override
  String get rowPayoutPurify => 'دفعة متوقعة (للتطهير عند استلامها)';

  @override
  String get rowInterest => 'فائدة متوقعة (للتطهير)';

  @override
  String get rowValue => 'مراجعة القيمة';

  @override
  String get rowValueExpected => 'القيمة المتوقعة (راجعها)';

  @override
  String get receivedThisAmount => 'استلمت هذا المبلغ';

  @override
  String get valueAsExpected => 'القيمة كما توقعتها';

  @override
  String get addAmount => 'أضف المبلغ';

  @override
  String get addValue => 'أضِف القيمة';

  @override
  String get skipRow => 'تخطٍّ';

  @override
  String noPayoutLine(String from, String to, String date) {
    return 'لم تُسجَّل دفعة عن الفترة $from – $to. المتوقع نحو $date.';
  }

  @override
  String get noPayoutPartnership => 'في الشراكة، لا ربح يعني لا دفعة.';

  @override
  String recordedSnack(String amount, String date) {
    return 'سُجّل $amount في $date';
  }

  @override
  String recordedAllSnack(int count) {
    return 'سُجّل $count كما هو متوقع';
  }

  @override
  String get skippedSnack => 'تم التخطي';

  @override
  String rowsNeedAmount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفوف تحتاج إلى مبلغ',
      one: 'صف واحد يحتاج إلى مبلغ',
    );
    return '$_temp0';
  }

  @override
  String showMoreRows(int count) {
    return 'عرض $count أخرى';
  }

  @override
  String get kindSkipped => 'تم تخطيه';

  @override
  String get valueBelowEstimate => 'القيمة أقل من تقديرك.';

  @override
  String get planCardTitle => 'الخطة مقابل الفعلي';

  @override
  String get expectedSoFar => 'المتوقع حتى الآن (تقديرك)';

  @override
  String get receivedLabel => 'المستلم';

  @override
  String get differenceLabel => 'الفرق';

  @override
  String receivedSinceStart(String amount) {
    return 'المستلم منذ البداية: $amount';
  }

  @override
  String get caseCReceived => 'يُحسب مستلمًا. ويُعرض للتطهير، لا ربحًا.';

  @override
  String valueVsEstimate(
    String actual,
    String estimate,
    String diff,
    String pct,
  ) {
    return 'الفعلي $actual · تقديرك $estimate · $diff ($pct)';
  }

  @override
  String get estimatesFooter =>
      'تقديرات فقط. لا تُستخدم في الزكاة ولا في العائد.';

  @override
  String get chartLegend => '— الفعلي · - - تقديرك · ○ للتأكيد';

  @override
  String chartPayoutsSummary(String expected, String received, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفوف',
      one: 'صف واحد',
    );
    return 'رسم الدفعات. تقديرك حتى الآن $expected. المستلم $received. $_temp0 للتأكيد.';
  }

  @override
  String chartValueSummary(String expected, String actual, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفوف',
      one: 'صف واحد',
    );
    return 'رسم القيمة. تقديرك اليوم $expected. آخر قيمة $actual. $_temp0 للتأكيد.';
  }

  @override
  String get stateReceived => 'مستلم';

  @override
  String get stateRecorded => 'مسجل';

  @override
  String get stateToConfirm => 'للتأكيد';

  @override
  String get stateSkipped => 'تم تخطيه';

  @override
  String get shariahRiskTag => 'مخاطرة شرعية';

  @override
  String get caseBReturnLine =>
      'تُحسب الدفعات عائدًا. · المصدر لم يُتحقق منه بعد';

  @override
  String get changeAnswers => 'تغيير الإجابات';

  @override
  String get caseCReturnsLine =>
      'لا تُحسب الدفعات عائدًا: يعود إليك مالك حتى لو خسر المشروع.';

  @override
  String get kindPayoutPurify => 'دفعة · للتطهير';

  @override
  String toPurifyIncludesPayouts(String amount) {
    return 'منها $amount من الدفعات';
  }

  @override
  String get givenAwayFromPayouts => 'ما تصدّقتَ به من الدفعات (للتطهير)';

  @override
  String get givenAwayFromPayoutsHelp =>
      'مال من هذه الدفعات تصدّقت به. إخراجه لا يُحسب زكاة.';

  @override
  String toConfirmPill(int count) {
    return '$count للتأكيد';
  }

  @override
  String rowPlanProfit(String pct) {
    return 'تقدير الدفعات $pct سنويًا';
  }

  @override
  String rowPlanGrowth(String pct) {
    return 'تقدير النمو $pct سنويًا';
  }

  @override
  String rowPlanBoth(String p, String g) {
    return 'تقدير: دفعات $p · نمو $g سنويًا';
  }

  @override
  String rowPlanGrowthOnly(String pct) {
    return 'نمو $pct سنويًا';
  }

  @override
  String expectedHeader(String amount, String date) {
    return 'المتوقع $amount في $date';
  }

  @override
  String alsoRecordsPayout(String date) {
    return 'هذا يسجّل أيضًا الدفعة المتوقعة في $date.';
  }

  @override
  String alsoRecordsValue(String date) {
    return 'هذا يسجّل أيضًا مراجعة القيمة في $date.';
  }

  @override
  String errOutsideWindow(String from, String to) {
    return 'اختر تاريخًا من $from إلى $to.';
  }

  @override
  String periodPayouts(String expected, String received) {
    return 'الدفعات: تقديرك $expected · المستلم $received';
  }

  @override
  String get tabOverview => 'نظرة عامة';

  @override
  String get tabInvestments => 'الاستثمارات';

  @override
  String get tabZakat => 'الزكاة';

  @override
  String get tabPlan => 'الخطة';

  @override
  String get comingSoon => 'هذه الصفحة قادمة قريبًا.';

  @override
  String get overviewTotal => 'إجمالي الاستثمارات';

  @override
  String thisYearTitle(String year) {
    return '$year حتى الآن';
  }

  @override
  String get byTypeTitle => 'حسب نوع الأصل';

  @override
  String typeShare(String value, String share) {
    return '$value · $share';
  }

  @override
  String get sinceStartGain => 'الربح';

  @override
  String get sinceStartRoi => 'العائد على المبلغ المدفوع';

  @override
  String sinceStartExcludes(String count) {
    return 'يستثني $count — سعر الصرف غير متوفر';
  }

  @override
  String get shariahCheckTitle => 'ملاحظات شرعية';

  @override
  String get exposureRisk => 'القيمة في عناصر عليها علامة «مخاطرة شرعية»';

  @override
  String get exposureCrypto => 'القيمة في العملات الرقمية';

  @override
  String get shariahNoScreening => 'التطبيق لا يفحص الشركات شرعيًا بعد.';

  @override
  String get trendTitle => 'القيمة، آخر 12 شهرًا';

  @override
  String get paidInTitle => 'المدفوع مقابل القيمة';

  @override
  String get monthlyReturnTitle => 'العائد الشهري';

  @override
  String get byCurrencyTitle => 'حسب العملة';

  @override
  String get chartValue => 'القيمة';

  @override
  String get chartPaidIn => 'المدفوع';

  @override
  String get notEnoughMonths =>
      'لا توجد أشهر كافية بعد. الرسم يحتاج شهرين على الأقل.';

  @override
  String get settings => 'الإعدادات';

  @override
  String assumptionsSummary(String currency, String zakatYear) {
    return '$currency · $zakatYear';
  }

  @override
  String get settingsReadError => 'تعذّرت قراءة الإعدادات.';

  @override
  String get aiHeading => 'الذكاء الاصطناعي';

  @override
  String get aiCloudTitle => 'استخدام الذكاء الاصطناعي السحابي';

  @override
  String get aiCloudSubtitle =>
      'عند التشغيل، يغادر النص الذي ترسله إلى الذكاء الاصطناعي هاتفك ويذهب إلى المزوّد الذي تختاره أدناه.';

  @override
  String get aiProviderHeading => 'مزوّد الذكاء الاصطناعي';

  @override
  String aiVendorSubtitle(String notice) {
    return 'مفتاحك الخاص. $notice';
  }

  @override
  String aiKeyLabel(String vendor) {
    return 'مفتاح واجهة $vendor';
  }

  @override
  String aiKeyHelper(String help) {
    return '$help يُحفظ على هذا الهاتف فقط.';
  }

  @override
  String get aiKeySaved => 'يوجد مفتاح محفوظ';

  @override
  String get aiRemoveKey => 'حذف المفتاح';

  @override
  String get aiSaveKey => 'حفظ المفتاح';

  @override
  String get aiStatusOff => 'الذكاء الاصطناعي السحابي متوقف.';

  @override
  String get aiStatusPickVendor => 'اختر مزوّدًا للذكاء الاصطناعي لاستخدامه.';

  @override
  String aiStatusAddKey(String vendor) {
    return 'أضف مفتاح $vendor لاستخدامه.';
  }

  @override
  String aiStatusUsingKey(String vendor) {
    return 'تستخدم مفتاح $vendor الخاص بك.';
  }

  @override
  String hijriMonth(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      '1': 'محرم',
      '2': 'صفر',
      '3': 'ربيع الأول',
      '4': 'ربيع الآخر',
      '5': 'جمادى الأولى',
      '6': 'جمادى الآخرة',
      '7': 'رجب',
      '8': 'شعبان',
      '9': 'رمضان',
      '10': 'شوال',
      '11': 'ذو القعدة',
      '12': 'ذو الحجة',
      'other': '$m',
    });
    return '$_temp0';
  }

  @override
  String get zakatSetupNisabTitle => 'أي نصاب تعتمد؟';

  @override
  String get zakatNisabGold => 'الذهب — 85 غرامًا';

  @override
  String get zakatNisabSilver => 'الفضة — 595 غرامًا';

  @override
  String zakatNisabAtRate(String amount, String date) {
    return '= $amount بحسب سعرك بتاريخ $date';
  }

  @override
  String zakatNisabAddRate(String metal) {
    String _temp0 = intl.Intl.selectLogic(metal, {
      'gold': 'أضِف سعر الذهب لتراه',
      'silver': 'أضِف سعر الفضة لتراه',
      'other': '$metal',
    });
    return '$_temp0';
  }

  @override
  String get zakatNisabWhy =>
      'لا تجب الزكاة إلا إذا بلغ مالك الزكوي النصاب. ويختلف العلماء في أي المعدنين يُعتمد في النقود.';

  @override
  String get zakatSetupCycleTitle => 'متى تنتهي سنتك الزكوية؟';

  @override
  String zakatCycleHelp(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'تاريخ زكاتك هو اليوم الذي بلغ فيه مالك النصاب أول مرة، محسوبًا بالأشهر الهجرية. وإن كنت تزكّي في تاريخ ثابت فاعتمد ذلك التاريخ.',
      'solar': 'تاريخ زكاتك هو اليوم الذي بلغ فيه مالك النصاب أول مرة، محسوبًا بالأشهر الميلادية. وإن كنت تزكّي في تاريخ ثابت فاعتمد ذلك التاريخ.',
      'other': '$calendar',
    });
    return '$_temp0';
  }

  @override
  String get zakatCycleNotToday =>
      'ليس تاريخ اليوم، إلا إن كان هو تاريخ زكاتك.';

  @override
  String zakatCalendarLine(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'التقويم الهجري (أم القرى)، لأن سنتك الزكوية قمرية',
      'solar': 'التقويم الميلادي، لأن سنتك الزكوية شمسية',
      'other': '$calendar',
    });
    return '$_temp0';
  }

  @override
  String zakatNextDue(String date) {
    return 'تاريخ الاستحقاق القادم: $date';
  }

  @override
  String zakatThisYearCalled(String label) {
    return 'تُسمّى هذه السنة $label.';
  }

  @override
  String zakatPastYears(String year) {
    return 'لا تُحسب هنا زكاة السنوات التي قبل $year. وما لم يُخرَج منها فهو لا يزال واجبًا عليك.';
  }

  @override
  String get zakatDay30 =>
      'في سنة يكون فيها هذا الشهر 29 يومًا يُعتمد اليوم التاسع والعشرون.';

  @override
  String get zakatFeb29 => 'في السنوات الأخرى يُعتمد 28 فبراير.';

  @override
  String get zakatSetupMonth => 'الشهر';

  @override
  String get zakatSetupDay => 'اليوم';

  @override
  String zakatBadDay(String month, String days) {
    return '$month فيه $days يومًا. اختر يومًا.';
  }

  @override
  String zakatMonthSemantics(String name, String n) {
    return 'شهر الزكاة، $name، $n من 12';
  }

  @override
  String zakatDaySemantics(String n) {
    return 'يوم الزكاة، $n';
  }

  @override
  String get zakatSetupRemindTitle => 'ذكّرني';

  @override
  String get reminderDaysLabel => 'عدد الأيام قبل الموعد';

  @override
  String get reminderDaysHelp => '0 = في يوم الاستحقاق نفسه.';

  @override
  String get reminderDaysError => 'أدخل رقمًا من 0 إلى 60.';

  @override
  String get reminderTimeLabel => 'الوقت';

  @override
  String reminderPreview(String date, String time, String text) {
    return 'إشعار واحد يوم $date في الساعة $time: «$text»';
  }

  @override
  String reminderPast(String year) {
    return 'مرّ هذا الوقت بالنسبة إلى $year، فلن يصلك إشعار لهذه السنة. وتظل هذه الصفحة تُظهر موعد انتهائها.';
  }

  @override
  String get reminderPermissionLine =>
      'سيسألك هاتفك إن كان يجوز للتطبيق عرض الإشعارات. ولا يُرسَل شيء من هاتفك.';

  @override
  String get reminderDenied =>
      'الإشعارات متوقفة. وتظل هذه الصفحة تُظهر موعد انتهاء سنتك الزكوية.';

  @override
  String get reminderTitle => 'الزكاة';

  @override
  String reminderBodyToday(String year) {
    return 'تنتهي سنتك الزكوية $year اليوم. افتح التطبيق لترى زكاتك.';
  }

  @override
  String reminderBodyOn(String year, String date) {
    return 'تنتهي سنتك الزكوية $year في $date. افتح التطبيق لترى زكاتك.';
  }

  @override
  String get reminderSwitch => 'إشعار نهاية السنة الزكوية';

  @override
  String get reminderOffSubtitle =>
      'متوقف. وتظل هذه الصفحة تُظهر موعد انتهاء سنتك الزكوية.';

  @override
  String reminderOnSubtitle(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'قبل الاستحقاق بـ $days يومًا في الساعة $time',
      few: 'قبل الاستحقاق بـ $days أيام في الساعة $time',
      two: 'قبل الاستحقاق بيومين في الساعة $time',
      one: 'قبل الاستحقاق بيوم واحد في الساعة $time',
      zero: 'في يوم الاستحقاق في الساعة $time',
    );
    return '$_temp0';
  }

  @override
  String get reminderBlocked =>
      'الإشعارات متوقفة لهذا التطبيق في إعدادات هاتفك.';

  @override
  String get reminderOpenSettings => 'فتح الإعدادات';

  @override
  String zakatYearLabel(String calendar, String n) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': '$n هـ',
      'solar': '$n',
      'other': '$n',
    });
    return '$_temp0';
  }

  @override
  String zakatState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'open': 'مفتوحة',
      'due': 'مستحقة',
      'distributing': 'قيد التوزيع',
      'settled': 'مسجَّلة بالكامل',
      'belowNisab': 'دون النصاب: لا زكاة واجبة',
      'other': '$state',
    });
    return '$_temp0';
  }

  @override
  String get zakatEstimateTag => 'تقدير';

  @override
  String zakatDueIs(String year) {
    return 'زكاتك عن $year مستحقة.';
  }

  @override
  String zakatDueBelow(String year, String date) {
    return 'انتهت سنتك الزكوية $year في $date. دون النصاب: لا زكاة واجبة.';
  }

  @override
  String zakatDueIncomplete(String year, String date) {
    return 'انتهت سنتك الزكوية $year في $date. أكمل بياناتها لترى زكاتك.';
  }

  @override
  String get zakatDueDelayLine =>
      'يرى أكثر العلماء أن الزكاة تُخرَج عند وجوبها، ولا تؤخَّر دون عذر معتبر.';

  @override
  String get zakatUmmAlQuraLine =>
      'التواريخ الهجرية بحسب تقويم أم القرى. وإن بدأ شهرك في يوم آخر في بلدك فانقل تاريخ الاستحقاق.';

  @override
  String zakatMovedFrom(String calendar, String date) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'نُقل من $date (أم القرى)',
      'solar': 'نُقل من $date',
      'other': '$date',
    });
    return '$_temp0';
  }

  @override
  String get zakatMoveDate => 'نقل التاريخ';

  @override
  String zakatResultOpenLine(String date) {
    return 'تقدير. تنتهي سنتك الزكوية في $date.';
  }

  @override
  String get zakatResultUsesToday => 'يستخدم قيم اليوم وأسعاره.';

  @override
  String zakatResultStartFrom(String date) {
    return 'يمكنك بدء التوزيع ابتداءً من $date.';
  }

  @override
  String get zakatResultDue => 'الزكاة المستحقة';

  @override
  String zakatResultRateOf(String rate, String amount) {
    return '$rate من $amount من المال الزكوي';
  }

  @override
  String get zakatResultBelow => 'دون النصاب: لا زكاة واجبة عن هذه السنة.';

  @override
  String zakatResultBelowFigures(String wealth, String nisab) {
    return 'المال الزكوي $wealth · النصاب $nisab';
  }

  @override
  String get zakatResultEmpty => 'لا شيء يُحسب بعد.';

  @override
  String get zakatAddInvestment => 'إضافة استثمار';

  @override
  String get zakatAddLineHere => 'إضافة بند هنا';

  @override
  String zakatResultIncomplete(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ينقص $n شيئًا:',
      few: 'تنقص $n أشياء:',
      two: 'ينقص شيئان:',
      one: 'ينقص شيء واحد:',
    );
    return 'تعذّر حساب الزكاة حتى الآن. $_temp0';
  }

  @override
  String get zakatStart => 'بدء التوزيع';

  @override
  String get zakatStartExplain =>
      'يثبّت أرقام هذه السنة. ولن تغيّرها التعديلات اللاحقة على استثماراتك أو أسعارك أو إعداداتك.';

  @override
  String get zakatClose => 'إغلاق هذه السنة';

  @override
  String get zakatCloseExplain => 'يثبّت أرقام هذه السنة. لا زكاة واجبة.';

  @override
  String get zakatRemaining => 'المتبقي';

  @override
  String get zakatSettledLine => 'المبالغ التي سجّلتها بلغت الزكاة المستحقة.';

  @override
  String get zakatFrozenBelow => 'دون النصاب: لا زكاة واجبة.';

  @override
  String zakatStartedSnack(String label) {
    return 'بدأ التوزيع لسنة $label. ثُبّتت الأرقام.';
  }

  @override
  String zakatClosedSnack(String label) {
    return 'أُغلقت سنة $label. دون النصاب: لا زكاة واجبة.';
  }

  @override
  String zakatReachedSnack(String label) {
    return 'المبالغ التي سجّلتها بلغت الزكاة المستحقة لسنة $label.';
  }

  @override
  String zakatFixRate(String pair, String date, String names) {
    return 'سعر $pair غير متوفر بتاريخ $date · $names';
  }

  @override
  String zakatFixJewellery(String names) {
    return 'هل في الحلي المستعمل زكاة؟ لم تُجب بعد · $names';
  }

  @override
  String zakatFixLongTerm(String names) {
    return 'كيف تُحسب الأسهم المقتناة طويلًا؟ لم تختر بعد · $names';
  }

  @override
  String get zakatFixNisab => 'لم تختر النصاب';

  @override
  String get zakatFixAddRate => 'إضافة سعر';

  @override
  String get zakatFixAnswer => 'أجب';

  @override
  String get zakatFixChoose => 'اختر';

  @override
  String zakatFrozenBanner(String date) {
    return 'ثُبّتت في $date. التعديلات اللاحقة لا تغيّر هذه السنة.';
  }

  @override
  String get zakatRecompute => 'إعادة الحساب';

  @override
  String zakatStartedHeader(String date, String calendar, String rate) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'قمرية',
      'solar': 'شمسية',
      'other': '$calendar',
    });
    return 'بدأت في $date · $_temp0 · $rate';
  }

  @override
  String get zakatAddsTitle => 'كيف يُحسب المبلغ';

  @override
  String get zakatAddsLines => 'مجموع البنود';

  @override
  String get zakatAddsDebts => 'ديون تستحق خلال 12 شهرًا';

  @override
  String get zakatAddsNotDeducted => 'غير مخصومة';

  @override
  String get zakatAddsBase => 'المال الزكوي';

  @override
  String zakatAddsNisab(String metal) {
    String _temp0 = intl.Intl.selectLogic(metal, {
      'gold': 'النصاب · ذهب 85 غرامًا',
      'silver': 'النصاب · فضة 595 غرامًا',
      'other': '$metal',
    });
    return '$_temp0';
  }

  @override
  String zakatAddsNisabCalc(String grams, String rate, String date) {
    return '$grams غ × $rate بتاريخ $date';
  }

  @override
  String get zakatAddsReaches => 'هل بلغ النصاب؟';

  @override
  String zakatAddsYes(String wealth, String nisab) {
    return 'نعم — $wealth ≥ $nisab';
  }

  @override
  String get zakatAddsNo => 'لا — دون النصاب';

  @override
  String zakatAddsRate(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'النسبة (قمرية)',
      'solar': 'النسبة (شمسية)',
      'other': 'النسبة',
    });
    return '$_temp0';
  }

  @override
  String get zakatAddsRounding =>
      'تُحسب من المال الزكوي لا بجمع مبالغ البنود، فقد يختلف كل بند بما يصل إلى 0.01.';

  @override
  String get zakatAddsDeductionOffWhy =>
      'عند إيقاف الخصم يُقارن المجموع كاملًا بالنصاب (قول الشافعية).';

  @override
  String zakatLineShare(String share, String amount) {
    return '$share من $amount';
  }

  @override
  String zakatLineZakat(String amount) {
    return 'الزكاة $amount';
  }

  @override
  String zakatLineConverted(String amount, String rate, String date) {
    return '$amount · محوّل بسعر $rate بتاريخ $date';
  }

  @override
  String zakatLineValueDate(String date) {
    return 'قيمة بتاريخ $date';
  }

  @override
  String zakatLineNotRateOf(String date) {
    return 'ليس سعر $date';
  }

  @override
  String zakatOldDateNote(String date) {
    return 'الزكاة على القيمة في تاريخ استحقاقك. وإن تغيّرت فأضف قيمة أو سعرًا لتاريخ $date.';
  }

  @override
  String zakatAddValueFor(String date) {
    return 'إضافة قيمة لتاريخ $date';
  }

  @override
  String zakatAddRateFor(String date) {
    return 'إضافة سعر لتاريخ $date';
  }

  @override
  String get zakatRecomputeForNewer => 'أعد حساب السنة لتستخدم قيمة أحدث.';

  @override
  String zakatLineRateMissing(String pair) {
    return 'سعر $pair غير متوفر';
  }

  @override
  String zakatQuestionName(String question) {
    String _temp0 = intl.Intl.selectLogic(question, {
      'jewellery': 'هل في الحلي المستعمل زكاة؟',
      'longTermMethod': 'كيف تُحسب الأسهم المقتناة طويلًا؟',
      'other': '$question',
    });
    return '$_temp0';
  }

  @override
  String get zakatNotAnswered => 'لم تُجب بعد';

  @override
  String zakatLineNetInterest(String amount) {
    return 'بعد استبعاد فوائد $amount باقية داخل الاستثمار (يُتخلص منها)';
  }

  @override
  String get zakatLineDividendsNotice =>
      'زكاة أرباحك الموزعة تُحسب مع نقدك. وإن لم يكن ذلك النقد في بنود هذه السنة فأضفه بند نقد إضافيًا.';

  @override
  String get zakatAddCashLine => 'إضافة بند نقد';

  @override
  String get zakatLineDeleted => 'محذوف من استثماراتك';

  @override
  String zakatLineFrozenBanner(String label) {
    return 'سنة $label مثبّتة. التعديلات هنا لا تغيّرها. أعد حسابها لتستخدم القيم الجديدة.';
  }

  @override
  String zakatInvestmentsTitle(int n) {
    return 'استثماراتك ($n)';
  }

  @override
  String get zakatNoInvestments => 'لا استثمارات في هذا التاريخ.';

  @override
  String zakatExtraTitle(int n) {
    return 'بنود إضافية ($n)';
  }

  @override
  String get zakatAddLine => 'إضافة بند';

  @override
  String get zakatExtraSheetTitle => 'بند إضافي';

  @override
  String get zakatExtraKindCash => 'نقد ليس في القائمة';

  @override
  String get zakatExtraKindOwed => 'مال لي عند الغير';

  @override
  String get zakatExtraOtherAssets =>
      'الأصول الأخرى (الذهب وبضاعة البيع والنشاط التجاري) مكانها قسم الاستثمارات، حيث يأخذ كل منها نصيبه من الزكاة.';

  @override
  String get zakatOpenInvestments => 'فتح الاستثمارات';

  @override
  String get zakatExtraLabel => 'الاسم';

  @override
  String get zakatExtraGoodDebt => 'المدين قادر وراغب في سداد ما عليه لي.';

  @override
  String get zakatExtraDoubtful =>
      'الدين المشكوك في سداده لا زكاة فيه حتى تقبضه.';

  @override
  String zakatExtraCountedOnly(String year) {
    return 'يُحسب في سنة $year فقط.';
  }

  @override
  String zakatExtraLive(String amount, String rate, String date) {
    return '= $amount بسعر $rate بتاريخ $date';
  }

  @override
  String get zakatErrExtraLabel => 'أدخل اسمًا.';

  @override
  String get zakatErrGoodDebt => 'أكّد أن المدين قادر وراغب في السداد.';

  @override
  String get zakatErrAmount => 'أدخل مبلغًا أكبر من 0.';

  @override
  String get zakatDebtsTitle => 'ديون عليّ سدادها خلال 12 شهرًا';

  @override
  String get zakatDebtsHelp => 'الأقساط والفواتير المستحقة خلال السنة القادمة.';

  @override
  String get zakatDebtsWhy =>
      'يختلف العلماء في الديون طويلة الأجل كقرض السكن. فمنهم من يخصم ما يستحق خلال 12 شهرًا فقط، ومنهم من يخصم الدين كله، ومنهم من لا يخصم شيئًا. وهذا التطبيق يخصم ما تدخله هنا فقط.';

  @override
  String get zakatDebtsDeduct => 'اخصم';

  @override
  String zakatDebtsZakat(String amount) {
    return 'الزكاة −$amount';
  }

  @override
  String get zakatGiftTitle => 'المبلغ المُخرَج';

  @override
  String get zakatGiftAdd => 'إضافة مبلغ مُخرَج';

  @override
  String zakatGiftGivenOf(String given, String due) {
    return 'المُخرَج $given من $due';
  }

  @override
  String zakatGiftRemaining(String amount) {
    return 'المتبقي $amount';
  }

  @override
  String zakatGiftSemantics(String given, String due, String remaining) {
    return 'المُخرَج $given من $due. المتبقي $remaining.';
  }

  @override
  String get zakatGiftEmpty => 'لم يُسجَّل شيء بعد. أضف كل مبلغ تُخرجه.';

  @override
  String zakatGiftDateError(String date) {
    return 'اختر تاريخًا بعد $date، وهو نهاية سنتك الزكوية السابقة.';
  }

  @override
  String get zakatGiftDateFuture => 'اختر تاريخًا ليس في المستقبل.';

  @override
  String get zakatGiftViewTitle => 'أي سعر يُحتسب به هذا المبلغ؟';

  @override
  String get zakatGiftViewDay => 'سعر يوم الإخراج (أبو يوسف ومحمد)';

  @override
  String get zakatGiftViewDue => 'سعر يوم الاستحقاق (أبو حنيفة)';

  @override
  String get zakatGiftViewHelp => 'يختلف العلماء في السعر المعتبر.';

  @override
  String zakatGiftCountedAt(
    String amount,
    String rate,
    String date,
    String view,
  ) {
    String _temp0 = intl.Intl.selectLogic(view, {
      'dayGiven': 'سعر يوم الإخراج',
      'dueDate': 'سعر يوم الاستحقاق',
      'other': '$view',
    });
    return '$amount · محتسب بسعر $rate بتاريخ $date ($_temp0)';
  }

  @override
  String zakatGiftLive(String counted, String rate, String date) {
    return '= $counted · محتسب بسعر $rate بتاريخ $date';
  }

  @override
  String zakatGiftTypeRate(String from, String to, String date) {
    return '1 $from = ____ $to بتاريخ $date';
  }

  @override
  String get zakatGiftEarly => 'أُخرج قبل تاريخ الاستحقاق';

  @override
  String get zakatGiftEarlyHelp =>
      'يُحتسب هذا إن كنت تملك النصاب حين أخرجته وأخرجته على أنه زكاة. والمالكية لا يجيزون ذلك إلا قبل تاريخ الاستحقاق بوقت قصير.';

  @override
  String zakatGiftOver(String amount) {
    return 'المُخرَج يزيد على المستحق بمقدار $amount.';
  }

  @override
  String get zakatGiftOverHelp =>
      'يرى بعض العلماء (الحنفية) أن تحتسبه من زكاة السنة القادمة إن أخرجته على أنه زكاة، ويرى آخرون (الشافعية) أنه صدقة. والتطبيق لا ينقله.';

  @override
  String get zakatGiftLogNote =>
      'التطبيق يحتسب ما تسجّله. ولا يستطيع أن يتحقق من أن كل شخص يجوز له أخذ الزكاة (التوبة 60)، ولا من أنك أخرجته على أنه زكاة. ولا تسجّل فوائد تخلصت منها، فليست زكاة.';

  @override
  String get zakatGiftAbout => 'عن التسجيل';

  @override
  String get zakatRateViewChanged =>
      'المبالغ المسجَّلة سابقًا تبقى بالسعر الذي احتُسبت به. عدّل المبلغ ليُحتسب بالطريقة الجديدة.';

  @override
  String zakatRecomputeTitle(String label, String date) {
    return 'إعادة حساب سنة $label من بيانات اليوم لتاريخ $date؟';
  }

  @override
  String zakatRecomputePreview(String before, String after, String given) {
    return 'الزكاة المستحقة: $before ← $after · المُخرَج يبقى $given';
  }

  @override
  String get zakatRecomputeHelp => 'ما أخرجتَه من قبل يُحتسب من الرقم الجديد.';

  @override
  String get zakatNoteA4 => 'يُفحص النصاب في تاريخ الاستحقاق فقط.';

  @override
  String get zakatNoteA8 => 'يُجمع الذهب والفضة وسائر المال معًا بحسب القيمة.';

  @override
  String get zakatNoteZ4 =>
      'الحساب على بنود هذه السنة فقط. أضف أي نقد آخر أو مال لك عند الغير بندًا إضافيًا. وأضف الأصول الأخرى في الاستثمارات.';

  @override
  String get zakatHistoryTitle => 'السجل';

  @override
  String zakatHistoryGiven(String amount) {
    return 'المُخرَج $amount';
  }

  @override
  String get zakatSettingsTooltip => 'إعدادات الزكاة';

  @override
  String get zakatSettingsNisab => 'معيار النصاب';

  @override
  String get zakatSettingsNisabHelp =>
      'السنوات المثبّتة تبقى على النصاب الذي بدأت به.';

  @override
  String get zakatSettingsCycle => 'تاريخ دورة الزكاة';

  @override
  String zakatCycleValue(String calendar, String day, String month) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': '$day $month (هجري)',
      'solar': '$day $month (ميلادي)',
      'other': '$day $month',
    });
    return '$_temp0';
  }

  @override
  String get zakatNotSetYet => 'لم يُحدَّد بعد';

  @override
  String get zakatSettingsRateView => 'سعر الصرف عند الإخراج بعملة أخرى';

  @override
  String get zakatSettingsRateViewNone => 'لم يُسأل بعد';

  @override
  String zakatChangeToTitle(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'التحويل إلى القمري (الهجري)؟',
      'solar': 'التحويل إلى الشمسي (الميلادي)؟',
      'other': 'تغيير؟',
    });
    return '$_temp0';
  }

  @override
  String get zakatChangeCycleTitle => 'تغيير تاريخ دورة الزكاة؟';

  @override
  String get zakatChangeKeep => 'هذه السنوات تحتفظ بتواريخها ونسبتها:';

  @override
  String zakatChangeKeepRow(
    String label,
    String state,
    String date,
    String rate,
  ) {
    return '$label · $state · $date · $rate';
  }

  @override
  String zakatChangeStartsAfter(String calendar, String date) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'تبدأ دورتك القمرية بعد $date.',
      'solar': 'تبدأ دورتك الشمسية بعد $date.',
      'other': '$date',
    });
    return '$_temp0';
  }

  @override
  String zakatChangeFirstYear(
    String calendar,
    String label,
    String date,
    String rate,
  ) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'أول سنة قمرية: $label، تنتهي في $date ($rate).',
      'solar': 'أول سنة شمسية: $label، تنتهي في $date ($rate).',
      'other': '$label',
    });
    return '$_temp0';
  }

  @override
  String zakatChangeAppliesFrom(String label) {
    return 'يسري التاريخ الجديد ابتداءً من السنة التي بعد $label.';
  }

  @override
  String get zakatMoveTitle => 'نقل تاريخ الاستحقاق';

  @override
  String get zakatMoveUmmAlQura => 'أم القرى';

  @override
  String get zakatMoveSolarLine =>
      'يمكنك نقل التاريخ الشمسي إلى ما قبله فقط. الإخراج المبكر جائز، أما التأخير فيؤخّر الزكاة.';

  @override
  String get zakatMoveInfo =>
      'تستخدم كل الأرقام والإشعار التاريخ الجديد. ولا تتأثر السنة القادمة.';

  @override
  String get src_A4 =>
      'تاريخ زكاة واحد في السنة. فإن بلغ مالك النصاب حولًا قمريًا كاملًا وجبت الزكاة في كل المال الزكوي الذي تملكه ذلك اليوم، بما فيه ما أُضيف خلال السنة: سنن أبي داود 1573؛ قرار المجمع 28 (3/4) §4. ويرى الشافعية والحنابلة أن للمال الجديد حولًا خاصًا من يوم اكتسابه، وهذا التطبيق يعتمد تاريخًا واحدًا. ويُفحص النصاب في تاريخ الاستحقاق فقط. وعند الحنفية يُشترط وجود النصاب في أول السنة وآخرها (A4).';

  @override
  String get src_A5 =>
      'الديون التي يجب سدادها خلال 12 شهرًا يجوز خصمها من المال الزكوي. ويختلف العلماء في الديون طويلة الأجل كقرض السكن: فمنهم من يخصم أقساط الأشهر الاثني عشر القادمة، ومنهم من يخصم الدين كله، ومنهم من لا يخصم شيئًا. ومذهب الشافعية أن الدين لا يمنع الزكاة (النووي، المجموع) — المصدر لم يُتحقق منه بعد. ويذكر المعيار الشرعي 35 لأيوفي الالتزامات الجائز خصمها — أرقام البنود لم يُتحقق منها بعد (A5، C4).';

  @override
  String get src_A7 =>
      'كل العملات نقود تجب فيها الزكاة (قرار المجمع 21 (9/3)). تُحوَّل كل ممتلكة بسعر يوم الاستحقاق (دار الإفتاء المحمودية؛ ولم يوجد نص لأيوفي أو المجمع في تاريخ السعر) ثم تُجمع (مؤسسة الزكاة الوطنية في بريطانيا). وإخراج الزكاة بعملة أخرى جائز (A7).';

  @override
  String get src_A8 =>
      'يُجمع الذهب والفضة وسائر المال بحسب القيمة. فالحنفية والمالكية يضمّون بعضها إلى بعض بالقيمة، والشافعية لا يضمّون الذهب إلى الفضة — والمصدر الأصلي لم يُتحقق منه بعد (A8).';

  @override
  String get src_B9 =>
      'الدين المرجو (المدين قادر وراغب في السداد) تجب فيه الزكاة كل سنة كأنه نقد في يدك. والدين المشكوك فيه لا زكاة فيه حتى يُقبض (قرار المجمع 1 (1/2)؛ اللجنة الدائمة بالسعودية) (B9).';

  @override
  String get src_Z4 =>
      'الحساب على بنود هذه السنة فقط. والبنود الإضافية للنقد والديون المرجوة فقط (قرار المجمع 1 (1/2))، أما الذهب وبضاعة البيع والنشاط التجاري فمكانها الاستثمارات. ويُقدَّر النصاب بغرامات المعدن الذي اخترته في سعره يوم الاستحقاق، وقاعدة التسعير لم يُتحقق منها بعد (Z-4، C5).';

  @override
  String get src_C1 =>
      'تجب الزكاة إذا مضت اثنا عشر شهرًا قمريًا منذ أن بلغ مالك النصاب أول مرة: سنن أبي داود 1573؛ التوبة 36 والبقرة 189؛ دار الإفتاء ببرمنغهام. وإن لم يُعرف التاريخ فيُعتمد أقرب تقدير — وهو من عمل الفتوى والمصدر لم يُتحقق منه بعد (C1).';

  @override
  String get src_C2 =>
      'الزكاة التي وجبت لا يجوز تأخيرها. ويرى أكثر العلماء أن الزكاة تُخرَج عند وجوبها ولا تؤخَّر دون عذر معتبر (اللجنة الدائمة بالسعودية، islamqa 13981؛ والنصوص الأصلية لم يُتحقق منها بعد). وعند الحنفية لا يجوز تغيير تاريخ الزكاة؛ ويجوز الإخراج المبكر بالتقدير، ثم يُفحص المبلغ في التاريخ الحقيقي ويُكمَل النقص (مركز الفتوى، 178985) (C2).';

  @override
  String get src_C3 =>
      'يبدأ الشهر القمري برؤية الهلال وهو تسعة وعشرون أو ثلاثون يومًا (البخاري 1909 و1907؛ البقرة 189). وتقويم أم القرى تقويم حسابي قد يختلف عن الرؤية المحلية بيوم أو يومين. واعتماده خيار في التطبيق، وجواز نقل التاريخ يومين هو فهم المستشار الشرعي — المصدر لم يُتحقق منه بعد. واليوم الثلاثون في شهر من تسعة وعشرين يُعتمد فيه اليوم التاسع والعشرون — الفهم لم يُتحقق منه بعد. ويُنقل التاريخ الشمسي إلى ما قبله فقط (C3).';

  @override
  String get src_C4 =>
      'يُقدَّر كل المال الزكوي في تاريخ الاستحقاق ويُطرح منه ما تخصمه من الديون. فإن بلغ الباقي النصاب وجبت الزكاة (الحنفية: ابن عابدين، رد المحتار 2/260، عن مجلس علماء الكيب الشرقي). وعند الشافعية الدين لا يُسقط الزكاة، وهذا في التطبيق إيقاف الخصم. وإذا نقص عن النصاب فلا شيء واجب (سنن أبي داود 1573) (C4).';

  @override
  String get src_C5 =>
      'الدين المرجو يُحسب كاملًا كل سنة، والدين المشكوك فيه لا يُحسب حتى يُقبض (قرار المجمع 1 (1/2)). وغيرهما من المال (الذهب وبضاعة البيع والنشاط التجاري) يوضع في الاستثمارات (C5).';

  @override
  String get src_C6 =>
      'يجوز إخراج الزكاة قبل وجوبها: سنن أبي داود 1624 (علي؛ سأل العباس أن يعجّل صدقته فرخّص له النبي ﷺ؛ حسّنه الألباني وضعّفه زبير علي زئي). والشروط: أن تملك النصاب حين تخرجها وأن تخرجها على أنها زكاة؛ وقيّدها الشافعية بسنة واحدة (دار الإفتاء الأردنية، السؤال 2974)؛ وعند الحنفية يُخرج مبكرًا ثم يُفحص المبلغ في التاريخ الحقيقي (مركز الفتوى 178985). والمالكية لا يجيزون ذلك إلا قبل الاستحقاق بوقت قصير — المصدر لم يُتحقق منه بعد (C6).';

  @override
  String get src_C7 =>
      'عند الحنفية ما زاد وأُخرج على أنه زكاة يجوز احتسابه من زكاة السنة القادمة (دار العلوم ديوبند، الفتوى 28/76/D=01/1435). وعند الشافعية الزائد صدقة، لأن لكل سنة نيتها (دار الإفتاء الأردنية، السؤال 3602). والتطبيق لا ينقله، وهذا صحيح على القولين (C7).';

  @override
  String get src_C8 =>
      'يختلف العلماء في سعر الصرف الذي تُحتسب به الزكاة المُخرَجة بعملة أخرى. سعر يوم الإخراج: قول أبي يوسف ومحمد (الصاحبين)، ويرجّحه عدد من مفتي الحنفية المعاصرين (Muftionline 46417؛ fatwa-ca 178598). وسعر يوم الاستحقاق: قول أبي حنيفة (دار الإفتاء المحمودية 134900، وتجيز سعرًا أعلى). والنص الأصلي في رد المحتار لم يُتحقق منه بعد (C8).';

  @override
  String get src_C9 =>
      'الزكاة المستحقة هي المبلغ الصحيح في تاريخ الاستحقاق لا أول رقم حسبه التطبيق. وما أخرجتَه يُحتسب من الرقم المصحَّح، وما نقص منه فهو لا يزال واجبًا (مركز الفتوى 178985؛ SeekersGuidance، المولانا إلياس باتل). وإن كان الرقم المصحَّح أقل مما أخرجتَه فانظر C7 (C9).';

  @override
  String get src_C10 =>
      'لا شيء واجب فيما دون عشرين دينارًا أو مئتي درهم (سنن أبي داود 1573). ولذلك يقول الإشعار إن سنتك الزكوية تنتهي فقط، لأن التطبيق لم يتحقق بعد من بلوغ مالك النصاب (C10).';

  @override
  String get src_C11 =>
      'تصح الزكاة إذا أُخرجت على أنها زكاة إلى الأصناف الثمانية في التوبة 60، ولكل سنة نيتها (دار الإفتاء الأردنية، السؤال 3602). والصدقة التي أُعطيت بحسن نية لمن لا يستحق بقيت صدقة (البخاري 1421؛ مسلم 1022). وهل يشمل ذلك الزكاة الواجبة محل خلاف (أبو حنيفة ومحمد: نعم إن اجتهد المعطي؛ أبو يوسف: لا) — لم يُتحقق منه بعد، والتطبيق لا يحكم فيه. والفوائد التي يُتخلص منها ليست زكاة (Z-6) (C11).';

  @override
  String zakatFixMetalRate(String metal, String date) {
    String _temp0 = intl.Intl.selectLogic(metal, {
      'gold': 'أضِف سعر الذهب لترى النصاب بتاريخ $date',
      'silver': 'أضِف سعر الفضة لترى النصاب بتاريخ $date',
      'other': '$metal',
    });
    return '$_temp0';
  }

  @override
  String get zakatWhyLinesTotal =>
      'مجموع المبلغ الخاضع للزكاة في كل بند، بعد تحويل كل بند إلى عملتك الأساسية بسعر يوم الاستحقاق.';

  @override
  String get zakatWhyBase =>
      'إجمالي البنود مطروحًا منه الديون التي تخصمها. ولا يقل عن صفر.';

  @override
  String get zakatWhyNisab =>
      'غرامات المعدن الذي اخترته مضروبة في سعره يوم الاستحقاق.';

  @override
  String get zakatWhyReaches =>
      'لا تجب الزكاة إلا إذا بلغ المال الخاضع للزكاة النصاب.';

  @override
  String get zakatWhyRate =>
      'نسبة سنتك الزكوية المختارة لسنة كاملة، دون عامل أيام.';

  @override
  String get zakatWhyBelow =>
      'المال الخاضع للزكاة أقل من النصاب في تاريخ الاستحقاق، فلا زكاة واجبة عن هذه السنة.';

  @override
  String get zakatWhyLineValue =>
      'القيمة في نهاية يوم الاستحقاق: القيمة السوقية لا التكلفة، بعد طرح الفوائد المحتجزة، ودون تعديل بالتضخم.';

  @override
  String get zakatWhyLineRate =>
      'أحدث سعر في يوم الاستحقاق أو قبله، سواء أدخلتَه أو جُلب.';

  @override
  String get zakatWhyExtra => 'بند أضفتَه لهذه السنة فقط.';

  @override
  String get zakatWhyGiven =>
      'مجموع المبالغ التي سجلتَها بعملة هذه السنة. والمتبقي هو الزكاة المستحقة مطروحًا منها ما أخرجتَه، ولا يقل عن صفر.';

  @override
  String get zakatErrExtraUnit =>
      'اختر عملة. الذهب والفضة مكانهما قسم الاستثمارات.';
}
