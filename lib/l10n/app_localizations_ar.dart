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
    return 'فوائد ربوية للتطهير: $amount';
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
}
