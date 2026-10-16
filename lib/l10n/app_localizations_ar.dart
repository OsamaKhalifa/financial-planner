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
  String get totalValue => 'القيمة الإجمالية';

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
  String toPurifyLine(String amount) {
    return 'فوائد يجب التخلص منها: $amount';
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
      'النقود والأرصدة المصرفية تجب فيها الزكاة كاملة: القرآن 9:34–35؛ سنن أبي داود 1573؛ قرار مجمع الفقه 21 (3/9) (B1).';

  @override
  String get src_B2 =>
      'الذهب والفضة المدخران: الزكاة على القيمة السوقية (القرآن 9:34؛ أبو داود 1573). الحلي المستعمل: يرى الحنفية وجوب الزكاة (أبو داود 1563) ويرى المالكية والشافعية والحنابلة عدمه (B2).';

  @override
  String get src_B3 =>
      'أسهم المتاجرة: 100 % من القيمة السوقية (قرار المجمع 28 (4/3) §3، 121 (13/3)). المقتناة للأجل الطويل دون بيانات الشركة: الأرباح الموزعة فقط (قرار 28 §3)، أو 25 % من القيمة تقديرًا (مؤسسة الزكاة الوطنية في بريطانيا)، أو القيمة كاملة احتياطًا. والشركة التي تخرج زكاتها بنفسها لا يزكي المساهم عن سهمه ثانية (قرار 28 §1) (B3).';

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
      'الزكاة تكون دائمًا على القيمة الفعلية يوم وجوبها لا على قيمة معدّلة بالتضخم (قرار المجمع 28 (4/3) §3). ويُعرض العائد الحقيقي للتخطيط فقط (A6).';

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
  String get whyToPurifyTitle => 'فوائد يجب التخلص منها';

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
  String get zakatNeedsChoice => 'الزكاة: اختر أدناه';

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
  String get noticeDividends => 'زكاة أرباحك الموزعة تُحسب مع نقودك.';

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
}
