// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Financial Planner';

  @override
  String unitName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'AED': 'UAE dirham',
      'AUD': 'Australian dollar',
      'BDT': 'Bangladeshi taka',
      'BHD': 'Bahraini dinar',
      'CAD': 'Canadian dollar',
      'CHF': 'Swiss franc',
      'CNY': 'Chinese yuan',
      'DKK': 'Danish krone',
      'DZD': 'Algerian dinar',
      'EGP': 'Egyptian pound',
      'EUR': 'Euro',
      'GBP': 'Pound sterling',
      'HKD': 'Hong Kong dollar',
      'IDR': 'Indonesian rupiah',
      'INR': 'Indian rupee',
      'JOD': 'Jordanian dinar',
      'JPY': 'Japanese yen',
      'KWD': 'Kuwaiti dinar',
      'MAD': 'Moroccan dirham',
      'MYR': 'Malaysian ringgit',
      'NGN': 'Nigerian naira',
      'NOK': 'Norwegian krone',
      'OMR': 'Omani rial',
      'PKR': 'Pakistani rupee',
      'QAR': 'Qatari riyal',
      'SAR': 'Saudi riyal',
      'SEK': 'Swedish krona',
      'SGD': 'Singapore dollar',
      'TND': 'Tunisian dinar',
      'TRY': 'Turkish lira',
      'USD': 'US dollar',
      'XAG_g': 'Silver, grams (999)',
      'XAU_g': 'Gold, grams (24k)',
      'ZAR': 'South African rand',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'ARE': 'UAE',
      'AUS': 'Australia',
      'BGD': 'Bangladesh',
      'BHR': 'Bahrain',
      'CAN': 'Canada',
      'CHE': 'Switzerland',
      'CHN': 'China',
      'DNK': 'Denmark',
      'DZA': 'Algeria',
      'EGY': 'Egypt',
      'EMU': 'Euro area',
      'GBR': 'United Kingdom',
      'HKG': 'Hong Kong',
      'IDN': 'Indonesia',
      'IND': 'India',
      'JOR': 'Jordan',
      'JPN': 'Japan',
      'KWT': 'Kuwait',
      'MAR': 'Morocco',
      'MYS': 'Malaysia',
      'NGA': 'Nigeria',
      'NOR': 'Norway',
      'OMN': 'Oman',
      'PAK': 'Pakistan',
      'QAT': 'Qatar',
      'SAU': 'Saudi Arabia',
      'SGP': 'Singapore',
      'SWE': 'Sweden',
      'TUN': 'Tunisia',
      'TUR': 'Turkey',
      'USA': 'United States',
      'ZAF': 'South Africa',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String marketName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'tadawul': 'Tadawul',
      'egx': 'EGX',
      'nasdaq': 'NASDAQ',
      'nyse': 'NYSE',
      'lse': 'LSE',
      'dfm': 'DFM',
      'adx': 'ADX',
      'boursaKuwait': 'Boursa Kuwait',
      'qse': 'QSE',
      'bursaMalaysia': 'Bursa Malaysia',
      'bist': 'BIST',
      'psx': 'PSX',
      'otherMarket': 'Other market',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get change => 'Change';

  @override
  String get source => 'Source';

  @override
  String get close => 'Close';

  @override
  String get add => 'Add';

  @override
  String get loading => 'Loading…';

  @override
  String get setupBaseTitle => 'What currency do you count your wealth in?';

  @override
  String get setupBaseHelp =>
      'Totals, monthly and yearly figures, and zakat set-aside use this currency. You can change it later.';

  @override
  String homeInflationLine(String country, String currency) {
    return 'Home inflation: $country (from $currency)';
  }

  @override
  String get setupZakatTitle => 'How do you calculate zakat?';

  @override
  String get zakatYearTitle => 'Zakat year';

  @override
  String get zakatYearLunar => 'Lunar — 2.5 % over 354 days';

  @override
  String get zakatYearSolar => 'Solar — 2.577 % over 365 days (AAOIFI)';

  @override
  String get zakatYearWhy =>
      'Some scholars allow a solar year with an adjusted rate; others keep the lunar year.';

  @override
  String get longTermTitle => 'Long-held shares and funds';

  @override
  String get longTermDividendsOnly => 'Dividends only (IIFA)';

  @override
  String get longTermProxy25 => '25 % of value (NZF proxy)';

  @override
  String get longTermFullValue => 'Full value (precaution)';

  @override
  String get longTermPerItem => 'I\'ll decide per item';

  @override
  String get longTermNotNow => 'Not now';

  @override
  String get longTermWhy =>
      'When company data is unknown, scholars use different methods.';

  @override
  String get addInvestment => 'Add investment';

  @override
  String get assumptions => 'Assumptions';

  @override
  String asOfDate(String date) {
    return 'as of $date';
  }

  @override
  String get showIn => 'Show in';

  @override
  String get viewGold => 'Gold g';

  @override
  String get viewSilver => 'Silver g';

  @override
  String excludesItems(String count, String pairs) {
    return 'Excludes $count — rate missing: $pairs';
  }

  @override
  String verdictKept(String year, String amount) {
    return '$year so far: purchasing power kept $amount';
  }

  @override
  String verdictLost(String year, String amount) {
    return '$year so far: purchasing power lost $amount';
  }

  @override
  String verdictNotAvailable(String year) {
    return '$year so far: purchasing power not available';
  }

  @override
  String inflationShipped(String country, String source, String year) {
    return '$country inflation: shipped ($source, as of $year)';
  }

  @override
  String inflationYours(String country) {
    return '$country inflation: your values';
  }

  @override
  String inflationAssumed(String year) {
    return 'inflation assumed from $year';
  }

  @override
  String inflationEmpty(String country) {
    return 'No inflation data for $country';
  }

  @override
  String staleBanner(String values, String rates) {
    return 'Not updated this month: $values values, $rates rates';
  }

  @override
  String get updateAll => 'Update all';

  @override
  String get sortLabel => 'Sort';

  @override
  String get sortValue => 'Value';

  @override
  String get sortReturn => 'Return since start';

  @override
  String get sortName => 'Name';

  @override
  String get sortOldest => 'Oldest update first';

  @override
  String closedSection(String count) {
    return 'Closed ($count)';
  }

  @override
  String get notUpdatedThisMonth => 'Not updated this month';

  @override
  String get metalRateNotUpdated => 'Metal rate not updated this month';

  @override
  String rateMissingAdd(String from, String to) {
    return '$from→$to rate missing · Add';
  }

  @override
  String get emptyTitle => 'No investments yet.';

  @override
  String get dataStaysOnPhone => 'Your data stays on this phone.';

  @override
  String get presetMonthlyFund => 'Monthly fund';

  @override
  String get presetGold => 'Gold';

  @override
  String get presetStock => 'Stock';

  @override
  String pureGrams(String grams) {
    return '$grams pure';
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
  String get pickUnit => 'Choose a unit';

  @override
  String get searchUnits => 'Search by code or name';

  @override
  String get mostUsed => 'Most used';

  @override
  String get allUnits => 'All units';

  @override
  String get chooseCountry => 'Choose a country';

  @override
  String get typeStock => 'Stock';

  @override
  String get typeFund => 'Fund / ETF';

  @override
  String get typeSukuk => 'Sukuk';

  @override
  String get typeGold => 'Gold';

  @override
  String get typeSilver => 'Silver';

  @override
  String get typeCash => 'Cash deposit';

  @override
  String get typeCrypto => 'Crypto';

  @override
  String get typeOther => 'Other';

  @override
  String get intentTrading => 'Trading';

  @override
  String get intentLongTerm => 'Long-term';

  @override
  String get intentPersonalUse => 'Personal use';

  @override
  String get intentRental => 'Rental';

  @override
  String get openSection => 'Open';

  @override
  String get somethingWrong => 'Something went wrong.';

  @override
  String get whyWhat => 'What it is';

  @override
  String get whyNumbers => 'Your numbers';

  @override
  String get whyAssumptions => 'Assumptions used';

  @override
  String get whySource => 'Source';

  @override
  String get sourceUnverified => 'source not yet verified';

  @override
  String get src_A1A2 =>
      '2.5 % of the zakatable base once per lunar year: Abu Dawud 1573 (A1). A solar year at 2.577 %: AAOIFI Shari\'ah Standard 35, reported by the National Zakat Foundation UK (A2) — section number not yet verified. Other scholars (Hanafi, Mufti Online) keep exactly 2.5 % and the lunar date.';

  @override
  String get src_B1 =>
      'Cash and bank balances are zakatable in full: Quran 9:34–35; Abu Dawud 1573; IIFA Res 21 (9/3) (B1).';

  @override
  String get src_B2 =>
      'Gold and silver held as savings: zakat on market value (Quran 9:34; Abu Dawud 1573). Worn jewellery: Hanafis say zakat is due (Abu Dawud 1563); Malikis, Shafi\'is and Hanbalis say it is not (B2).';

  @override
  String get src_B3 =>
      'Trading shares: 100 % of market value (IIFA Res 28 (3/4) §3, Res 121 (3/13)). Held long term with no company data: dividends only (IIFA Res 28 §3); or 25 % of value as a proxy (National Zakat Foundation UK); or full value as a precaution. A company that pays zakat itself: shareholder does not pay again (IIFA Res 28 §1) (B3).';

  @override
  String get src_B4 =>
      'Funds and ETFs follow the share rules at fund level. Sukuk: 100 % of face or market value by default, with override (B4); AAOIFI SS 35 and SS 17 section numbers not yet verified.';

  @override
  String get src_B5 =>
      'Personal-use property is not zakatable. Rental property: zakat is not on the property; rent still held counts with cash (IIFA Res 2 (2/2)). Bought to resell: 100 % of market value (B5).';

  @override
  String get src_B8 =>
      'Scholars differ on whether holding crypto is permitted (IIFA Res 237 (8/24) gave no final ruling). Those who permit it say zakat is due on its full market value (B8).';

  @override
  String get src_Z6 =>
      'Interest is not the owner\'s wealth: it is not return and not in the zakat base, and it is given away (Quran 2:278–279). Giving it away does not count as zakat (B1). AAOIFI SS 21 section not yet verified.';

  @override
  String get src_A6 =>
      'Zakat is always on the actual value on the zakat date, never on an inflation-adjusted value (IIFA Res 28 (3/4) §3). The real return is shown for planning only (A6).';

  @override
  String get src_A3 =>
      'Nisab: gold 85 g (20 dinars) and silver 595 g (200 dirhams): Abu Dawud 1573; Bukhari 1447; Muslim 979. Which metal to use for cash is a point of difference (A3).';

  @override
  String get sourceName => 'World Bank';

  @override
  String get verdictCaption => 'After set-aside, after home inflation';

  @override
  String get rateMissingTitle => 'Rate missing';

  @override
  String get openSource => 'Source';

  @override
  String returnLine(String date) {
    return 'Return (since $date)';
  }

  @override
  String valueFromDate(String date) {
    return 'Value from $date';
  }

  @override
  String get whyToPurifyTitle => 'Interest to purify';

  @override
  String get whyToPurifyWhat =>
      'All interest recorded minus all interest given away. It is not return and not in the zakat base. Giving it away does not count as zakat. It is never netted against the set-aside.';

  @override
  String get formTitleAdd => 'Add investment';

  @override
  String get formTitleEdit => 'Edit investment';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldMarket => 'Market';

  @override
  String get fieldMarketCountry => 'Market country';

  @override
  String get fieldUnit => 'Item unit';

  @override
  String get fieldStartDate => 'Start date';

  @override
  String get fieldPaid => 'Paid (first money in)';

  @override
  String get fieldPaidUnit => 'Paid in';

  @override
  String get fieldCurrentValue => 'Current value (optional)';

  @override
  String get fieldValueDate => 'Value date';

  @override
  String get fieldQuantity => 'Quantity (optional)';

  @override
  String get fieldGrams => 'Grams (gross)';

  @override
  String get fieldPurity => 'Purity';

  @override
  String get fieldIntent => 'Intent';

  @override
  String get fieldShare => 'Zakat share (% of value)';

  @override
  String get fieldNotes => 'Notes (optional)';

  @override
  String karat(String k) {
    return '${k}k';
  }

  @override
  String fineness(String k) {
    return '$k';
  }

  @override
  String pureGramsPreview(String grams) {
    return '= $grams pure';
  }

  @override
  String get errName => 'Enter a name';

  @override
  String get errType => 'Choose a type';

  @override
  String get errIntent => 'Choose an intent';

  @override
  String get errMarket => 'Choose a market';

  @override
  String get errMarketCountry => 'Choose the market\'s country';

  @override
  String get errUnit => 'Choose a unit';

  @override
  String get errStartDate => 'Choose the start date';

  @override
  String get errFirstPaid => 'Enter what you paid';

  @override
  String get errGrams => 'Enter the grams';

  @override
  String get errPurity => 'Choose the purity';

  @override
  String get errZero => 'Must be more than 0';

  @override
  String get errFuture => 'The date cannot be in the future';

  @override
  String get errShare => 'Enter the zakat share, 0 to 100 %';

  @override
  String get errLongTerm => 'Choose how long-held shares are handled';

  @override
  String get errJewellery => 'Choose the jewellery ruling';

  @override
  String errSummary(String count) {
    return '$count fields need attention';
  }

  @override
  String get errSave => 'Could not save. Nothing was changed. Try again.';

  @override
  String get savedToast => 'Saved';

  @override
  String get discardTitle => 'Discard this investment?';

  @override
  String get discard => 'Discard';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String zakatLinePercent(String share) {
    return 'Zakat: on $share of value';
  }

  @override
  String get zakatLineDividends => 'Zakat: on dividends only, when received';

  @override
  String get zakatLineCompany => 'Zakat: 0 % — the company pays zakat';

  @override
  String get zakatNeedsChoice =>
      'Zakat: not set yet — answer the zakat question in this form';

  @override
  String get zakatReasonTrading =>
      'You hold this to sell. Trade goods pay 2.5 % of market value.';

  @override
  String get zakatReasonSavings => 'Held as savings: zakat on market value.';

  @override
  String get zakatReasonCash => 'Cash is zakatable in full.';

  @override
  String get zakatReasonSukuk => 'Sukuk: 100 % of value by default.';

  @override
  String get zakatReasonJewellery => 'Worn jewellery: follows your ruling.';

  @override
  String get zakatReasonCustom => 'You set this share yourself.';

  @override
  String get noticeDividends =>
      'Zakat is set aside on dividends received from this item (IIFA Res 28 (3/4)). Don\'t record them again in a cash item.';

  @override
  String get noticeCrypto =>
      'Scholars differ on whether holding crypto is permitted. Those who permit it say zakat is on its full market value.';

  @override
  String get companyPays => 'Company pays zakat for me (0 %)';

  @override
  String get jewelleryAsk => 'Is worn jewellery zakatable?';

  @override
  String get jewelleryYes => 'Zakatable';

  @override
  String get jewelleryNo => 'Not zakatable';

  @override
  String get jewelleryWhy => 'The schools differ on jewellery that is worn.';

  @override
  String get hintLongTerm =>
      'Enter the zakatable part of the business: cash, receivables and stock for sale, less short-term debts. Machines and buildings are not counted.';

  @override
  String get hintRental =>
      'Zakat is not on the property; rent you still hold is counted with your cash. Usually 0 %.';

  @override
  String get hintPersonalUse => 'Personal-use items: usually 0 %.';

  @override
  String get hintTrading => 'Bought to resell: usually 100 % of market value.';

  @override
  String useShare(String share) {
    return 'Use $share %';
  }

  @override
  String inlineRateLabel(String from, String to, String date) {
    return '1 $from = ____ $to on $date';
  }

  @override
  String get inlineRateField => 'Rate';

  @override
  String get rateSaved => 'Rate saved';

  @override
  String get fetchRate => 'Fetch';

  @override
  String get errRate => 'Enter a rate above 0';

  @override
  String get deleteInvestment => 'Delete investment';

  @override
  String get deleteConfirm => 'Delete investment and its whole history?';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get deleted => 'Deleted';

  @override
  String get edit => 'Edit';

  @override
  String get valueNow => 'Value now';

  @override
  String approxInBase(String amount) {
    return '≈ $amount';
  }

  @override
  String get sinceStart => 'Since start';

  @override
  String colItem(String unit) {
    return 'In $unit';
  }

  @override
  String get rowGain => 'Gain';

  @override
  String get rowReturn => 'Return';

  @override
  String get rowPerYear => 'Per year';

  @override
  String get rowSetAside => 'Estimated zakat set-aside (planning)';

  @override
  String get setAsideNote =>
      'Actual zakat is due once a year on your zakat date.';

  @override
  String get rowReturnAfter => 'Return after set-aside';

  @override
  String rowRealOwn(String country) {
    return 'Real · own market ($country)';
  }

  @override
  String rowRealBase(String country) {
    return 'Real · in your money ($country)';
  }

  @override
  String get realLabel =>
      'Purchasing power (for planning only — zakat is always on today\'s actual value)';

  @override
  String get byMonthYear => 'By month and year';

  @override
  String needsRate(String from, String to) {
    return 'Needs $from→$to rate';
  }

  @override
  String toPurifyItem(String amount) {
    return 'Interest to purify: $amount · not counted as return';
  }

  @override
  String get recordGivenAway => 'Record given away';

  @override
  String get history => 'History';

  @override
  String get record => 'Record';

  @override
  String closedOn(String date) {
    return 'Closed on $date';
  }

  @override
  String get kindMoneyIn => 'Money in';

  @override
  String get kindSale => 'Sale';

  @override
  String get kindIncome => 'Income received';

  @override
  String get kindValue => 'Value update';

  @override
  String get kindInterestKept => 'Interest kept inside';

  @override
  String get kindInterestPaid => 'Interest paid out';

  @override
  String get kindGivenInside => 'Interest given away (from inside)';

  @override
  String get kindGivenPaid => 'Interest given away (from paid out)';

  @override
  String get tabValue => 'Value';

  @override
  String get tabIn => 'In';

  @override
  String get tabOut => 'Out';

  @override
  String get tabInterest => 'Interest';

  @override
  String get interestReceived => 'Received';

  @override
  String get interestGivenAway => 'Given away';

  @override
  String get interestWhere => 'Where is it?';

  @override
  String get interestPaidOut => 'Paid out to me';

  @override
  String get interestKeptInside => 'Kept inside this item';

  @override
  String get interestNote =>
      'Interest is not counted as return and not in the zakat base. It is shown as \"to purify\" so you can give it away.';

  @override
  String get givenFrom => 'Given from';

  @override
  String get givenAwayNote => 'Giving it away does not count as zakat.';

  @override
  String get effectKept =>
      'Lowers the item\'s value and the to-purify total by the same amount. Return is not affected.';

  @override
  String get effectPaid =>
      'Lowers the to-purify total. The item\'s value does not change.';

  @override
  String get fieldAmount => 'Amount';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldValue => 'Value';

  @override
  String get fieldValueAfter => 'Value after (optional)';

  @override
  String get fieldValueLeft => 'Value left';

  @override
  String get incomeNoValueChange => 'Income does not change the item\'s value.';

  @override
  String get fieldKind => 'Kind';

  @override
  String lastValue(String value, String date) {
    return 'Last: $value on $date';
  }

  @override
  String typoCheck(String times) {
    return 'This is $times× the last value. Check the number.';
  }

  @override
  String get valueLeftRequired =>
      'This is more than the item\'s value. Enter what is left (0 or more).';

  @override
  String get closesInvestment =>
      'This closes the investment. It stays in past months.';

  @override
  String errBeforeStart(String date) {
    return 'Can\'t be before the start date ($date)';
  }

  @override
  String errGivenTooMuch(String amount) {
    return 'You have $amount interest still to purify there. Enter that or less.';
  }

  @override
  String replaceValueTitle(String date) {
    return 'Replace the value of $date?';
  }

  @override
  String get replace => 'Replace';

  @override
  String get nothingToPurify => 'No interest left to give away.';

  @override
  String get perUnit => 'Per unit';

  @override
  String get total => 'Total';

  @override
  String get zakatSectionTitle => 'Zakat';

  @override
  String get whyReturnTitle => 'Return';

  @override
  String get whyReturnWhat =>
      'Money-weighted return (Modified Dietz): deposits are not profit. Over long periods with large flows it can differ from the exact money-weighted return.';

  @override
  String whyReturnNumbers(String r, String ev, String bv, String cf, String d) {
    return '$r = ($ev − $bv − $cf) ÷ $d  (end value − start value − money in/out, ÷ average money invested)';
  }

  @override
  String get whySetAsideTitle => 'Estimated zakat set-aside (planning)';

  @override
  String get whySetAsideWhat =>
      'Rate × zakat share × end value × days ÷ year length, plus rate × dividends received (dividends-only method), in the matched pair you chose. Actual zakat is due once a year on your zakat date.';

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
  String get whyRealTitle => 'Real return';

  @override
  String get whyRealWhat =>
      '(1 + return) ÷ (1 + inflation) − 1. For planning only; it never changes the zakat base.';

  @override
  String whyRealNumbers(String r, String i, String real) {
    return 'return $r, inflation $i → $real';
  }

  @override
  String get whyGapTitle => 'Purchasing-power gap';

  @override
  String get whyGapWhat =>
      '(End value − set-aside) compared with (start value + money in/out + inflation on the average money invested). Zero or more means purchasing power was kept.';

  @override
  String whyGapNumbers(String gap, String needed) {
    return 'gap $gap; needed end value $needed';
  }

  @override
  String get whyShareTitle => 'Zakat share';

  @override
  String get whyInflationTitle => 'Inflation';

  @override
  String get whyInflationWhat =>
      'Yearly rates of the series, pro-rated by days for this period.';

  @override
  String get monthsYears => 'By month and year';

  @override
  String get updateAllTitle => 'Update all';

  @override
  String get refreshRates => 'Refresh rates online';

  @override
  String get refreshHelp =>
      'Downloads the same public price list for everyone. Nothing about you is sent.';

  @override
  String lastRefresh(String date, String source) {
    return 'Last refresh: rates as of $date · $source';
  }

  @override
  String get refreshRunning => 'Refreshing…';

  @override
  String refreshDone(String date, String source, String count) {
    return 'Rates as of $date · $source · $count of your rates updated';
  }

  @override
  String get refreshFailed =>
      'Couldn\'t refresh. Nothing changed. Your saved rates are still used — type a rate below if you have a newer one.';

  @override
  String get refreshSource => 'currency-api (fawazahmed0)';

  @override
  String get asOfLabel => 'As of';

  @override
  String get showAll => 'Show all';

  @override
  String get ratesStillOld => 'Rates still old';

  @override
  String get valuesHeading => 'Values';

  @override
  String get same => 'Same';

  @override
  String filledCount(String filled, String total) {
    return '$filled of $total filled';
  }

  @override
  String updatedToast(String count, String left) {
    return 'Updated $count values. $left still old.';
  }

  @override
  String get ratesSavedValuesNot => 'Rates saved, values not saved — try again';

  @override
  String allUpToDate(String month) {
    return 'Everything is up to date for $month';
  }

  @override
  String saveUpdatesTitle(String count) {
    return 'Save $count updates?';
  }

  @override
  String lastHint(String value, String date) {
    return 'last $value · $date';
  }

  @override
  String rateRowLabel(String from, String to) {
    return '1 $from = ____ $to';
  }

  @override
  String get periodTitle => 'Period view';

  @override
  String get allInvestments => 'All investments';

  @override
  String get monthLabel => 'Month';

  @override
  String get yearLabel => 'Year';

  @override
  String rowInflation(String country) {
    return 'Inflation ($country)';
  }

  @override
  String get rowRealAfter => 'Real return after set-aside';

  @override
  String rowRealBefore(String value) {
    return 'Real return before set-aside: $value';
  }

  @override
  String inflationForPeriod(String value) {
    return '$value for this period';
  }

  @override
  String get verdictKeptTitle => 'KEPT purchasing power, after set-aside';

  @override
  String get verdictLostTitle => 'LOST purchasing power, after set-aside';

  @override
  String neededEnd(String value, String pct) {
    return 'Needed: end value $value (return $pct)';
  }

  @override
  String lostGrams(String value) {
    return 'Lost $value after set-aside';
  }

  @override
  String keptGrams(String value) {
    return 'Kept $value after set-aside';
  }

  @override
  String get yardstick =>
      'Gold is a yardstick, not a price index. In gold, the gram is the measure: there is no inflation step.';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notAvailableWhy =>
      'The average money invested in this period is zero or less.';

  @override
  String markersStale(String count) {
    return '$count items not updated this period';
  }

  @override
  String get markerStaleRate => 'rate not updated in this period';

  @override
  String get markerNotUpdated => 'value not updated';

  @override
  String get itemsHeading => 'Items';

  @override
  String get excludedHeading => 'Excluded';

  @override
  String excludedLine(String name, String from, String to) {
    return '$name — $from→$to rate missing';
  }

  @override
  String basedOn(String count, String total) {
    return 'Based on $count of $total items';
  }

  @override
  String toPurifyPeriod(String amount) {
    return 'Interest to purify: $amount — not in return, not netted against the set-aside';
  }

  @override
  String noZakatSwitch(String year) {
    return 'No zakat due for $year';
  }

  @override
  String get noZakatHelp =>
      'Decide using all your zakatable wealth, not only this list.';

  @override
  String get noZakatEffect => '0 — no zakat due this year';

  @override
  String nisabGold(String amount) {
    return 'Nisab: 85 g gold = $amount';
  }

  @override
  String nisabSilver(String amount) {
    return 'Nisab: 595 g silver = $amount';
  }

  @override
  String get nisabNoGold => 'Add a gold rate to see the nisab';

  @override
  String get nisabNoSilver => 'Add a silver rate to see the nisab';

  @override
  String zakatableTotal(String amount) {
    return 'Zakatable total in this list: $amount';
  }

  @override
  String get otherPeriods => 'Other periods';

  @override
  String get measureReturn => 'Return';

  @override
  String get measureAfter => 'After set-aside';

  @override
  String get measureReal => 'Real after set-aside';

  @override
  String get assumptionsTitle => 'Assumptions';

  @override
  String get baseAndHome => 'Base and home';

  @override
  String baseLine(String currency) {
    return 'Base currency: $currency';
  }

  @override
  String get baseChangeWarning => 'All totals and months recalculate.';

  @override
  String get ratesHeading => 'Rates';

  @override
  String rateLine(String from, String rate, String to, String date) {
    return '1 $from = $rate $to · as of $date';
  }

  @override
  String get rateTagTyped => 'Typed by you';

  @override
  String rateTagFetched(String source) {
    return '$source';
  }

  @override
  String rateTypedUsed(String rate) {
    return 'Your rate is used (source gave $rate)';
  }

  @override
  String get rateStaleMarker => 'not updated this month';

  @override
  String get rateMissingMarker => 'missing';

  @override
  String get noRatesYet => 'Rates appear here when an investment needs one.';

  @override
  String rateHistoryTitle(String from, String to) {
    return 'Rates $from→$to';
  }

  @override
  String get addRate => 'Add rate';

  @override
  String get editRate => 'Edit rate';

  @override
  String get swapDirection => 'Swap direction';

  @override
  String inverseLine(String to, String rate, String from) {
    return '1 $to = $rate $from';
  }

  @override
  String get rateFetchedNote =>
      'Fetched rates are overridden by typing a rate for the same date.';

  @override
  String get inflationHeading => 'Inflation';

  @override
  String inflationRow(String country) {
    return '$country';
  }

  @override
  String inflationYearLine(String year, String rate, String tag) {
    return '$year: $rate · $tag';
  }

  @override
  String get tagShipped => 'Shipped';

  @override
  String get tagYours => 'Yours';

  @override
  String tagAssumed(String year) {
    return 'Assumed from $year';
  }

  @override
  String get resetToShipped => 'Reset to shipped';

  @override
  String overrideTitle(String country, String year) {
    return '$country $year';
  }

  @override
  String get inflationPercentField => 'Inflation (%)';

  @override
  String get errInflation => 'Enter a rate from -50 to 1000 %';

  @override
  String emptySeries(String country) {
    return 'No data for $country. Add a year to see real figures for items using it.';
  }

  @override
  String get zakatHeading => 'Zakat';

  @override
  String get jewelleryNotAsked => 'Not asked yet';

  @override
  String get noZakatByYear => 'No zakat due by year';

  @override
  String get perItemRewritten =>
      'Items that followed the old method keep it now.';

  @override
  String get rateAddedToast => 'Rate saved';

  @override
  String get errRateFuture => 'The rate date cannot be in the future';

  @override
  String get customShareSwitch => 'Set my own zakat share';

  @override
  String zakatChangedFrom(String share) {
    return 'You changed this from $share';
  }

  @override
  String get moreSection => 'More';

  @override
  String get inflationSeriesField => 'Inflation series';

  @override
  String get inflationSeriesDefault => 'Default for this item';

  @override
  String get fetchFailed => 'Couldn\'t fetch. Type the rate.';

  @override
  String fetchNotCovered(String from, String to) {
    return 'Source has no $from→$to. Type it.';
  }

  @override
  String fetchedRateLine(
    String from,
    String rate,
    String to,
    String date,
    String source,
  ) {
    return '1 $from = $rate $to · as of $date · $source';
  }

  @override
  String get src_B6 =>
      'Business ownership: the owner pays on their share of the zakatable assets (cash, receivables, stock for sale) less short-term debts; fixed assets are not zakatable (IIFA Res 28 (3/4) §2). AAOIFI SS 35 net-assets method — section not yet verified (B6).';

  @override
  String get src_B7 =>
      'Pension with withdrawal limits: no zakat until it can be accessed (Dr. Main Al-Qudah, AMJA fatwa 21964); or zakat on the accessible amount after penalty and tax (Fiqh Council of North America — source not yet verified); or the full balance as a precaution (B7).';

  @override
  String get typePrivateEquity => 'Private equity';

  @override
  String get typePrivateEquityHint =>
      'A stake in a business not on a market — e.g. a friend\'s project.';

  @override
  String get fieldSharesInProject => 'Shares in the project (optional)';

  @override
  String get peIntentTrading => 'To sell';

  @override
  String get peIntentLongTerm => 'Long-term (for its profit)';

  @override
  String get zakatPeTrading =>
      'Zakat: on 100 % of value. You hold this to sell. — IIFA Res 28 (3/4) §3.';

  @override
  String get peMethodKnown => 'Known zakatable %';

  @override
  String get peMethodKnownSource => 'IIFA Res 121 (3/13) §1';

  @override
  String get peMethodProfit => 'Zakat on profit received only';

  @override
  String get peMethodFull => 'Full value';

  @override
  String get peMethodFullNote => 'Precaution.';

  @override
  String get peMethodPick => 'Pick how zakat is counted';

  @override
  String get peMethodsHelp =>
      'If the project mostly buys and sells goods, most of its value is usually zakatable.';

  @override
  String noticeProfitPayoutsOnly(String rate) {
    return 'Zakat: $rate of each profit payout you record, not of the project\'s value. Each payout is counted once.';
  }

  @override
  String get noticeCapitalBackIsDebt =>
      'This works like money you lent. Zakat is on the full amount, as a debt owed to you. — IIFA Res 1 (1/2).';

  @override
  String get zakatCaseC => 'Zakat on 100 %.';

  @override
  String get q2CapitalBack =>
      'If the project loses money, do you still get all your money back?';

  @override
  String get answerNo => 'No';

  @override
  String get answerYes => 'Yes';

  @override
  String get answerNotSure => 'Not sure';

  @override
  String get q1ProfitBasis =>
      'Is this % a share of the project\'s real profit, or a fixed % of the money you put in?';

  @override
  String get q1Share => 'Share of the real profit';

  @override
  String get q1Fixed => 'Fixed % of my money';

  @override
  String get errPickOne => 'Pick one. \'Not sure\' is fine.';

  @override
  String get noticeCaseB =>
      'A fixed % of the money you put in is not a valid profit share. In a partnership, your profit must be a part of the project\'s real profit. You may want to change the terms with your partner.';

  @override
  String get noticeCaseC =>
      'Your money comes back even if the project loses. This works like a loan. Extra money on a loan is riba. The app shows these payouts as \"to purify\", not as profit.';

  @override
  String get noticeCaseNotSure =>
      'Ask your partner two things: Is your profit a part of the real profit? Can you lose money? The answers decide if this is a partnership or a loan.';

  @override
  String get srcCaseB =>
      'IIFA Res 30 (5/4) item 4: no guarantee of the capital or a fixed profit; such a clause is void. AAOIFI SS 13 §8/1 — section not yet verified (B6.1).';

  @override
  String get srcCaseC =>
      'IIFA Res 10 (10/2): an increase on a loan agreed at its start is riba. Quran 2:279 (B6.1).';

  @override
  String get srcCaseNotSure =>
      'IIFA Res 30 (5/4): profit in a partnership is a share of the real profit (B6.1).';

  @override
  String get caseBTagPreview =>
      'This item will be tagged Shariah risk. Payouts still count as return. · source not yet verified';

  @override
  String get accountKindQuestion =>
      'Is this an Islamic account (profit share) or a conventional account (interest)?';

  @override
  String get accountIslamic => 'Islamic account (profit share)';

  @override
  String get accountConventional => 'Conventional account (interest)';

  @override
  String get errPickAccountKind => 'Pick the account kind';

  @override
  String get noticeConventional =>
      'This is interest. Record it as money out \"interest (to purify)\", not as income.';

  @override
  String get expectedTitle => 'Expected (optional)';

  @override
  String get expectedSubtitle =>
      'Plan payouts or value checks. An estimate, not a promise.';

  @override
  String get blockPayouts => 'Payouts';

  @override
  String get blockValueChecks => 'Value checks';

  @override
  String get fieldPayoutSchedule => 'Payout schedule';

  @override
  String get fieldValueCheckSchedule => 'Value-check schedule';

  @override
  String get scheduleNone => 'None';

  @override
  String get scheduleMonthly => 'Monthly';

  @override
  String get scheduleQuarterly => 'Every 3 months';

  @override
  String get scheduleHalfYearly => 'Every 6 months';

  @override
  String get scheduleYearly => 'Yearly';

  @override
  String get fieldExpectedProfit =>
      'Expected profit (your estimate, % per year)';

  @override
  String get fieldExpectedGrowth =>
      'Expected value growth (your estimate, % per year)';

  @override
  String get estimateHelp =>
      'An estimate, not a promise. Not used for zakat or return.';

  @override
  String payoutPreview(String amount, int months, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: 'month',
    );
    return '= $amount every $_temp0 · first on $date';
  }

  @override
  String growthPreview(String date, String amount) {
    return 'Your estimate for $date: $amount (if nothing else is added or taken out).';
  }

  @override
  String get errPickPayoutSchedule =>
      'Pick a payout schedule, or clear this %.';

  @override
  String get errPickValueSchedule =>
      'Pick a value-check schedule, or clear this %.';

  @override
  String get errProfitPositive =>
      'Must be more than 0. Leave it empty for no %.';

  @override
  String get errGrowthTooLow => 'Must be more than −100 %.';

  @override
  String needsRateForEstimates(String pair, String date) {
    return 'Needs $pair rate on $date for your estimates';
  }

  @override
  String get editRecalculates =>
      'This recalculates every past month for this item.';

  @override
  String get editRowsRebuilt =>
      'Rows to confirm are rebuilt for the new dates. Your recorded payouts and values stay.';

  @override
  String editStartAfterRecord(String date) {
    return 'Can\'t be after $date: this item has a record on that date. Move or delete that record first.';
  }

  @override
  String editStartMaxDate(String date) {
    return 'Latest allowed: $date (your earliest other record).';
  }

  @override
  String get editStartMoves =>
      'Your first money in moves to this date. Every past month for this item is recalculated.';

  @override
  String get editStartMovesMetal =>
      'Your first money in and starting grams move to this date. Every past month for this item is recalculated.';

  @override
  String toConfirmTitle(int count) {
    return 'To confirm · $count';
  }

  @override
  String get confirmAll => 'Confirm all as expected';

  @override
  String get confirmAllLine => 'Confirm only money that really came in.';

  @override
  String get confirmValueLine =>
      'Confirm only if the value is still about this.';

  @override
  String get rowPayout => 'Expected payout (not received yet)';

  @override
  String get rowPayoutPurify => 'Expected payout (to purify when received)';

  @override
  String get rowInterest => 'Expected interest (to purify)';

  @override
  String get rowValue => 'Value check';

  @override
  String get rowValueExpected => 'Expected value (check it)';

  @override
  String get receivedThisAmount => 'Received this amount';

  @override
  String get valueAsExpected => 'Value is as expected';

  @override
  String get addAmount => 'Add amount';

  @override
  String get addValue => 'Add value';

  @override
  String get skipRow => 'Skip';

  @override
  String noPayoutLine(String from, String to, String date) {
    return 'No payout recorded for $from – $to. Expected around $date.';
  }

  @override
  String get noPayoutPartnership =>
      'In a partnership, no profit means no payout.';

  @override
  String recordedSnack(String amount, String date) {
    return 'Recorded $amount on $date';
  }

  @override
  String recordedAllSnack(int count) {
    return 'Recorded $count as expected';
  }

  @override
  String get skippedSnack => 'Skipped';

  @override
  String rowsNeedAmount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows need an amount',
      one: '1 row needs an amount',
    );
    return '$_temp0';
  }

  @override
  String showMoreRows(int count) {
    return 'Show $count more';
  }

  @override
  String get kindSkipped => 'Skipped';

  @override
  String get valueBelowEstimate => 'Value is below your estimate.';

  @override
  String get planCardTitle => 'Plan vs actual';

  @override
  String get expectedSoFar => 'Expected so far (your estimate)';

  @override
  String get receivedLabel => 'Received';

  @override
  String get differenceLabel => 'Difference';

  @override
  String receivedSinceStart(String amount) {
    return 'Received since start: $amount';
  }

  @override
  String get caseCReceived =>
      'Counted as received. Shown as to purify, not profit.';

  @override
  String valueVsEstimate(
    String actual,
    String estimate,
    String diff,
    String pct,
  ) {
    return 'Actual $actual · Your estimate $estimate · $diff ($pct)';
  }

  @override
  String get estimatesFooter => 'Estimates only. Not used for zakat or return.';

  @override
  String get chartLegend => '— Actual · - - Your estimate · ○ To confirm';

  @override
  String chartPayoutsSummary(String expected, String received, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows',
      one: '1 row',
    );
    return 'Payouts chart. Your estimate so far $expected. Received $received. $_temp0 to confirm.';
  }

  @override
  String chartValueSummary(String expected, String actual, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows',
      one: '1 row',
    );
    return 'Value chart. Your estimate today $expected. Last value $actual. $_temp0 to confirm.';
  }

  @override
  String get stateReceived => 'received';

  @override
  String get stateRecorded => 'recorded';

  @override
  String get stateToConfirm => 'to confirm';

  @override
  String get stateSkipped => 'skipped';

  @override
  String get shariahRiskTag => 'Shariah risk';

  @override
  String get caseBReturnLine =>
      'Payouts count as return. · source not yet verified';

  @override
  String get changeAnswers => 'Change answers';

  @override
  String get caseCReturnsLine =>
      'Payouts are not counted as return: your money comes back even if the project loses.';

  @override
  String get kindPayoutPurify => 'Payout · to purify';

  @override
  String toPurifyIncludesPayouts(String amount) {
    return 'includes $amount of payouts';
  }

  @override
  String get givenAwayFromPayouts => 'Given away from payouts (to purify)';

  @override
  String get givenAwayFromPayoutsHelp =>
      'Money from these payouts that you gave to charity. Giving it away does not count as zakat.';

  @override
  String toConfirmPill(int count) {
    return '$count to confirm';
  }

  @override
  String rowPlanProfit(String pct) {
    return 'est. payouts $pct/yr';
  }

  @override
  String rowPlanGrowth(String pct) {
    return 'est. growth $pct/yr';
  }

  @override
  String rowPlanBoth(String p, String g) {
    return 'est. payouts $p/yr · growth $g/yr';
  }

  @override
  String rowPlanGrowthOnly(String pct) {
    return 'growth $pct/yr';
  }

  @override
  String expectedHeader(String amount, String date) {
    return 'Expected $amount on $date';
  }

  @override
  String alsoRecordsPayout(String date) {
    return 'This also records the expected payout of $date.';
  }

  @override
  String alsoRecordsValue(String date) {
    return 'This also records the value check of $date.';
  }

  @override
  String errOutsideWindow(String from, String to) {
    return 'Pick a date from $from to $to.';
  }

  @override
  String periodPayouts(String expected, String received) {
    return 'Payouts: your estimate $expected · received $received';
  }

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabInvestments => 'Investments';

  @override
  String get tabZakat => 'Zakat';

  @override
  String get tabPlan => 'Plan';

  @override
  String get comingSoon => 'This page is coming soon.';

  @override
  String get overviewTotal => 'Investments total';

  @override
  String thisYearTitle(String year) {
    return '$year so far';
  }

  @override
  String get byTypeTitle => 'By asset type';

  @override
  String typeShare(String value, String share) {
    return '$value · $share';
  }

  @override
  String get sinceStartGain => 'Gain';

  @override
  String get sinceStartRoi => 'Return on money paid in';

  @override
  String sinceStartExcludes(String count) {
    return 'Excludes $count — rate missing';
  }

  @override
  String get shariahCheckTitle => 'Shariah notes';

  @override
  String get exposureRisk => 'Value in items tagged Shariah risk';

  @override
  String get exposureCrypto => 'Value in crypto';

  @override
  String get shariahNoScreening =>
      'The app does not screen companies for halal yet.';

  @override
  String get trendTitle => 'Value, last 12 months';

  @override
  String get paidInTitle => 'Paid in vs value';

  @override
  String get monthlyReturnTitle => 'Monthly return';

  @override
  String get byCurrencyTitle => 'By currency';

  @override
  String get chartValue => 'Value';

  @override
  String get chartPaidIn => 'Paid in';

  @override
  String get notEnoughMonths =>
      'Not enough months yet. A chart needs at least 2.';

  @override
  String get settings => 'Settings';

  @override
  String assumptionsSummary(String currency, String zakatYear) {
    return '$currency · $zakatYear';
  }

  @override
  String get settingsReadError => 'Could not read settings.';

  @override
  String get aiHeading => 'AI';

  @override
  String get aiCloudTitle => 'Use cloud AI';

  @override
  String get aiCloudSubtitle =>
      'When on, the text you send to AI leaves your phone and goes to the AI provider you choose below.';

  @override
  String get aiProviderHeading => 'AI provider';

  @override
  String aiVendorSubtitle(String notice) {
    return 'Your own key. $notice';
  }

  @override
  String aiKeyLabel(String vendor) {
    return '$vendor API key';
  }

  @override
  String aiKeyHelper(String help) {
    return '$help Stored only on this phone.';
  }

  @override
  String get aiKeySaved => 'A key is saved';

  @override
  String get aiRemoveKey => 'Remove key';

  @override
  String get aiSaveKey => 'Save key';

  @override
  String get aiStatusOff => 'Cloud AI is off.';

  @override
  String get aiStatusPickVendor => 'Pick an AI provider to use it.';

  @override
  String aiStatusAddKey(String vendor) {
    return 'Add your $vendor key to use it.';
  }

  @override
  String aiStatusUsingKey(String vendor) {
    return 'Using your own $vendor key.';
  }

  @override
  String hijriMonth(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      '1': 'Muharram',
      '2': 'Safar',
      '3': 'Rabi\' al-Awwal',
      '4': 'Rabi\' al-Thani',
      '5': 'Jumada al-Ula',
      '6': 'Jumada al-Akhirah',
      '7': 'Rajab',
      '8': 'Sha\'ban',
      '9': 'Ramadan',
      '10': 'Shawwal',
      '11': 'Dhu al-Qa\'dah',
      '12': 'Dhu al-Hijjah',
      'other': '$m',
    });
    return '$_temp0';
  }

  @override
  String get zakatSetupNisabTitle => 'Which nisab do you use?';

  @override
  String get zakatNisabGold => 'Gold — 85 g';

  @override
  String get zakatNisabSilver => 'Silver — 595 g';

  @override
  String zakatNisabAtRate(String amount, String date) {
    return '= $amount at your rate of $date';
  }

  @override
  String zakatNisabAddRate(String metal) {
    String _temp0 = intl.Intl.selectLogic(metal, {
      'gold': 'Add a gold rate to see it',
      'silver': 'Add a silver rate to see it',
      'other': '$metal',
    });
    return '$_temp0';
  }

  @override
  String get zakatNisabWhy =>
      'Zakat is due only if your zakatable wealth reaches the nisab. Scholars differ on which metal to use for money.';

  @override
  String get zakatSetupCycleTitle => 'When does your zakat year end?';

  @override
  String zakatCycleHelp(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'Your zakat date is the day your wealth first reached nisab, counted in Hijri months. If you already give zakat on a set date, use that date.',
      'solar': 'Your zakat date is the day your wealth first reached nisab, counted in Gregorian months. If you already give zakat on a set date, use that date.',
      'other': '$calendar',
    });
    return '$_temp0';
  }

  @override
  String get zakatCycleNotToday =>
      'Not today\'s date, unless that is your zakat date.';

  @override
  String zakatCalendarLine(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'Hijri calendar (Umm al-Qura), because your zakat year is lunar',
      'solar': 'Gregorian calendar, because your zakat year is solar',
      'other': '$calendar',
    });
    return '$_temp0';
  }

  @override
  String zakatNextDue(String date) {
    return 'Next due date: $date';
  }

  @override
  String zakatThisYearCalled(String label) {
    return 'This year is called $label.';
  }

  @override
  String zakatPastYears(String year) {
    return 'Zakat from years before $year is not counted here. If any of it was not given, it is still owed.';
  }

  @override
  String get zakatDay30 =>
      'In a year where this month has 29 days, the 29th is used.';

  @override
  String get zakatFeb29 => 'In other years, 28 February is used.';

  @override
  String get zakatSetupMonth => 'Month';

  @override
  String get zakatSetupDay => 'Day';

  @override
  String zakatBadDay(String month, String days) {
    return '$month has $days days. Pick a day.';
  }

  @override
  String zakatMonthSemantics(String name, String n) {
    return 'Zakat month, $name, $n of 12';
  }

  @override
  String zakatDaySemantics(String n) {
    return 'Zakat day, $n';
  }

  @override
  String get zakatSetupRemindTitle => 'Remind me';

  @override
  String get reminderDaysLabel => 'Days before';

  @override
  String get reminderDaysHelp => '0 = on the due date.';

  @override
  String get reminderDaysError => 'Enter 0 to 60.';

  @override
  String get reminderTimeLabel => 'Time';

  @override
  String reminderPreview(String date, String time, String text) {
    return 'One notification on $date at $time: “$text”';
  }

  @override
  String reminderPast(String year) {
    return 'This time has passed for $year, so $year gets no notification. This tab still shows when its year ends.';
  }

  @override
  String get reminderPermissionLine =>
      'Your phone will ask if this app may show notifications. Nothing is sent from your phone.';

  @override
  String get reminderDenied =>
      'Notifications are off. This tab still shows when your zakat year ends.';

  @override
  String get reminderTitle => 'Zakat';

  @override
  String reminderBodyToday(String year) {
    return 'Your zakat year $year ends today. Open to see your zakat.';
  }

  @override
  String reminderBodyOn(String year, String date) {
    return 'Your zakat year $year ends on $date. Open to see your zakat.';
  }

  @override
  String get reminderSwitch => 'Year-end notification';

  @override
  String get reminderOffSubtitle =>
      'Off. This tab still shows when your zakat year ends.';

  @override
  String reminderOnSubtitle(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days before the due date at $time',
      one: '1 day before the due date at $time',
      zero: 'On the due date at $time',
    );
    return '$_temp0';
  }

  @override
  String get reminderBlocked =>
      'Notifications are off for this app in your phone settings.';

  @override
  String get reminderOpenSettings => 'Open settings';

  @override
  String zakatYearLabel(String calendar, String n) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': '$n AH',
      'solar': '$n',
      'other': '$n',
    });
    return '$_temp0';
  }

  @override
  String zakatState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'open': 'Open',
      'due': 'Due',
      'distributing': 'Distributing',
      'settled': 'Settled',
      'belowNisab': 'Below nisab: no zakat due',
      'other': '$state',
    });
    return '$_temp0';
  }

  @override
  String get zakatEstimateTag => 'Estimate';

  @override
  String zakatDueIs(String year) {
    return 'Your zakat for $year is due.';
  }

  @override
  String zakatDueBelow(String year, String date) {
    return 'Your zakat year $year ended on $date. Below nisab: no zakat due.';
  }

  @override
  String zakatDueIncomplete(String year, String date) {
    return 'Your zakat year $year ended on $date. Complete it to see your zakat.';
  }

  @override
  String get zakatDueDelayLine =>
      'Most scholars hold that zakat should be given when it falls due, and not delayed without a valid reason.';

  @override
  String get zakatUmmAlQuraLine =>
      'Hijri dates use the Umm al-Qura calendar. If your month began on another day where you live, move your due date.';

  @override
  String zakatMovedFrom(String calendar, String date) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'Moved from $date (Umm al-Qura)',
      'solar': 'Moved from $date',
      'other': '$date',
    });
    return '$_temp0';
  }

  @override
  String get zakatMoveDate => 'Move date';

  @override
  String zakatResultOpenLine(String date) {
    return 'Estimate. Your zakat year ends on $date.';
  }

  @override
  String get zakatResultUsesToday => 'Uses today\'s values and rates.';

  @override
  String zakatResultStartFrom(String date) {
    return 'You can start distribution from $date.';
  }

  @override
  String get zakatResultDue => 'Zakat due';

  @override
  String zakatResultRateOf(String rate, String amount) {
    return '$rate of $amount zakatable wealth';
  }

  @override
  String get zakatResultBelow => 'Below nisab: no zakat due for this year.';

  @override
  String zakatResultBelowFigures(String wealth, String nisab) {
    return 'Zakatable $wealth · nisab $nisab';
  }

  @override
  String get zakatResultEmpty => 'Nothing to count yet.';

  @override
  String get zakatAddInvestment => 'Add investment';

  @override
  String get zakatAddLineHere => 'Add a line here';

  @override
  String zakatResultIncomplete(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n things are missing:',
      one: '1 thing is missing:',
    );
    return 'Zakat can\'t be worked out yet. $_temp0';
  }

  @override
  String get zakatStart => 'Start distribution';

  @override
  String get zakatStartExplain =>
      'Freezes this year\'s figures. Later changes to your investments, rates or settings will not change it.';

  @override
  String get zakatClose => 'Close this year';

  @override
  String get zakatCloseExplain =>
      'Freezes this year\'s figures. No zakat is due.';

  @override
  String get zakatRemaining => 'Remaining';

  @override
  String get zakatSettledLine => 'The amounts you logged reach the zakat due.';

  @override
  String get zakatFrozenBelow => 'Below nisab: no zakat due.';

  @override
  String zakatStartedSnack(String label) {
    return '$label started. Figures frozen.';
  }

  @override
  String zakatClosedSnack(String label) {
    return '$label closed. Below nisab: no zakat due.';
  }

  @override
  String zakatReachedSnack(String label) {
    return 'The amounts you logged reach the zakat due for $label.';
  }

  @override
  String zakatFixRate(String pair, String date, String names) {
    return '$pair rate missing on $date · $names';
  }

  @override
  String zakatFixJewellery(String names) {
    return 'Is jewellery that is worn zakatable? Not answered · $names';
  }

  @override
  String zakatFixLongTerm(String names) {
    return 'How are long-held shares counted? Not chosen · $names';
  }

  @override
  String get zakatFixNisab => 'Nisab not chosen';

  @override
  String get zakatFixAddRate => 'Add rate';

  @override
  String get zakatFixAnswer => 'Answer';

  @override
  String get zakatFixChoose => 'Choose';

  @override
  String zakatFrozenBanner(String date) {
    return 'Frozen on $date. Later changes do not change this year.';
  }

  @override
  String get zakatRecompute => 'Recompute';

  @override
  String zakatStartedHeader(String date, String calendar, String rate) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'Lunar',
      'solar': 'Solar',
      'other': '$calendar',
    });
    return 'Started on $date · $_temp0 · $rate';
  }

  @override
  String get zakatAddsTitle => 'How it adds up';

  @override
  String get zakatAddsLines => 'Lines total';

  @override
  String get zakatAddsDebts => 'Debts within 12 months';

  @override
  String get zakatAddsNotDeducted => 'not deducted';

  @override
  String get zakatAddsBase => 'Zakatable wealth';

  @override
  String zakatAddsNisab(String metal) {
    String _temp0 = intl.Intl.selectLogic(metal, {
      'gold': 'Nisab · gold 85 g',
      'silver': 'Nisab · silver 595 g',
      'other': '$metal',
    });
    return '$_temp0';
  }

  @override
  String zakatAddsNisabCalc(String grams, String rate, String date) {
    return '$grams g × $rate on $date';
  }

  @override
  String get zakatAddsReaches => 'Reaches nisab?';

  @override
  String zakatAddsYes(String wealth, String nisab) {
    return 'Yes — $wealth ≥ $nisab';
  }

  @override
  String get zakatAddsNo => 'No — below nisab';

  @override
  String zakatAddsRate(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'Rate (lunar)',
      'solar': 'Rate (solar)',
      'other': 'Rate',
    });
    return '$_temp0';
  }

  @override
  String get zakatAddsRounding =>
      'Worked out from the zakatable wealth, not by adding the line amounts, so lines can differ by up to 0.01 each.';

  @override
  String get zakatAddsDeductionOffWhy =>
      'With deduction off, the full total is compared with nisab (Shafi\'i view).';

  @override
  String zakatLineShare(String share, String amount) {
    return '$share of $amount';
  }

  @override
  String zakatLineZakat(String amount) {
    return 'zakat $amount';
  }

  @override
  String zakatLineConverted(String amount, String rate, String date) {
    return '$amount · converted at $rate on $date';
  }

  @override
  String zakatLineValueDate(String date) {
    return 'value of $date';
  }

  @override
  String zakatLineNotRateOf(String date) {
    return 'not the rate of $date';
  }

  @override
  String zakatOldDateNote(String date) {
    return 'Zakat is on the value on your due date. If it changed, add a value or rate for $date.';
  }

  @override
  String zakatAddValueFor(String date) {
    return 'Add value for $date';
  }

  @override
  String zakatAddRateFor(String date) {
    return 'Add rate for $date';
  }

  @override
  String get zakatRecomputeForNewer => 'Recompute to use a newer value.';

  @override
  String zakatLineRateMissing(String pair) {
    return '$pair rate missing';
  }

  @override
  String zakatQuestionName(String question) {
    String _temp0 = intl.Intl.selectLogic(question, {
      'jewellery': 'Is jewellery that is worn zakatable?',
      'longTermMethod': 'How are long-held shares counted?',
      'other': '$question',
    });
    return '$_temp0';
  }

  @override
  String get zakatNotAnswered => 'Not answered';

  @override
  String zakatLineNetInterest(String amount) {
    return 'net of $amount interest kept inside (to purify)';
  }

  @override
  String get zakatLineDividendsNotice =>
      'Zakat on your dividends is counted with your cash. If that cash is not in this year\'s lines, add it as an extra cash line.';

  @override
  String get zakatAddCashLine => 'Add cash line';

  @override
  String get zakatLineDeleted => 'Deleted from your investments';

  @override
  String zakatLineFrozenBanner(String label) {
    return '$label is frozen. Changes here do not change it. Recompute it to use new values.';
  }

  @override
  String zakatInvestmentsTitle(int n) {
    return 'Your investments ($n)';
  }

  @override
  String get zakatNoInvestments => 'No investments on this date.';

  @override
  String zakatExtraTitle(int n) {
    return 'Extra lines ($n)';
  }

  @override
  String get zakatAddLine => 'Add line';

  @override
  String get zakatExtraSheetTitle => 'Extra line';

  @override
  String get zakatExtraKindCash => 'Cash not in the list';

  @override
  String get zakatExtraKindOwed => 'Money owed to me';

  @override
  String get zakatExtraOtherAssets =>
      'Other assets (gold, goods for sale, a business) go in My Investments, where each gets its zakat share.';

  @override
  String get zakatOpenInvestments => 'Open My Investments';

  @override
  String get zakatExtraLabel => 'Label';

  @override
  String get zakatExtraGoodDebt =>
      'The person is able and willing to pay me back.';

  @override
  String get zakatExtraDoubtful =>
      'A doubtful debt has no zakat until you receive it.';

  @override
  String zakatExtraCountedOnly(String year) {
    return 'Counted in $year only.';
  }

  @override
  String zakatExtraLive(String amount, String rate, String date) {
    return '= $amount at $rate on $date';
  }

  @override
  String get zakatErrExtraLabel => 'Enter a label.';

  @override
  String get zakatErrGoodDebt =>
      'Confirm that the person is able and willing to pay.';

  @override
  String get zakatErrAmount => 'Enter an amount above 0.';

  @override
  String get zakatDebtsTitle => 'Debts I must pay within 12 months';

  @override
  String get zakatDebtsHelp => 'Instalments and bills due in the next year.';

  @override
  String get zakatDebtsWhy =>
      'Scholars differ on long-term debts such as a mortgage. Some deduct only the part due in the next 12 months, some the whole debt, some none. This app deducts only what you enter here.';

  @override
  String get zakatDebtsDeduct => 'Deduct';

  @override
  String zakatDebtsZakat(String amount) {
    return 'zakat −$amount';
  }

  @override
  String get zakatGiftTitle => 'Amount given';

  @override
  String get zakatGiftAdd => 'Add amount given';

  @override
  String zakatGiftGivenOf(String given, String due) {
    return 'Given $given of $due';
  }

  @override
  String zakatGiftRemaining(String amount) {
    return 'Remaining $amount';
  }

  @override
  String zakatGiftSemantics(String given, String due, String remaining) {
    return 'Given $given of $due. Remaining $remaining.';
  }

  @override
  String get zakatGiftEmpty => 'Nothing logged yet. Add each amount you give.';

  @override
  String zakatGiftDateError(String date) {
    return 'Pick a date after $date, the end of your previous zakat year.';
  }

  @override
  String get zakatGiftDateFuture => 'Pick a date that is not in the future.';

  @override
  String get zakatGiftViewTitle => 'Which rate counts this amount?';

  @override
  String get zakatGiftViewDay =>
      'the rate on the day you gave (Abu Yusuf and Muhammad)';

  @override
  String get zakatGiftViewDue => 'the rate on your due date (Abu Hanifa)';

  @override
  String get zakatGiftViewHelp => 'Scholars differ on the rate.';

  @override
  String zakatGiftCountedAt(
    String amount,
    String rate,
    String date,
    String view,
  ) {
    String _temp0 = intl.Intl.selectLogic(view, {
      'dayGiven': 'rate on the day you gave',
      'dueDate': 'rate on your due date',
      'other': '$view',
    });
    return '$amount · counted at $rate on $date ($_temp0)';
  }

  @override
  String zakatGiftLive(String counted, String rate, String date) {
    return '= $counted · counted at $rate on $date';
  }

  @override
  String zakatGiftTypeRate(String from, String to, String date) {
    return '1 $from = ____ $to on $date';
  }

  @override
  String get zakatGiftEarly => 'Given before the due date';

  @override
  String get zakatGiftEarlyHelp =>
      'This counts if you held nisab when you gave it and you gave it as zakat. The Maliki school accepts this only shortly before the due date.';

  @override
  String zakatGiftOver(String amount) {
    return 'Given $amount more than due.';
  }

  @override
  String get zakatGiftOverHelp =>
      'Some scholars (Hanafi) let you count this toward next year if you gave it as zakat. Others (Shafi\'i) count it as sadaqah. The app does not move it.';

  @override
  String get zakatGiftLogNote =>
      'The app counts what you log. It cannot check that each person may receive zakat (Quran 9:60), or that you gave it as zakat. Do not log interest you gave away: it is not zakat.';

  @override
  String get zakatGiftAbout => 'About logging';

  @override
  String get zakatRateViewChanged =>
      'Amounts already logged keep the rate they were counted at. Edit an amount to count it with the new view.';

  @override
  String zakatRecomputeTitle(String label, String date) {
    return 'Recompute $label from today\'s data for $date?';
  }

  @override
  String zakatRecomputePreview(String before, String after, String given) {
    return 'Zakat due: $before → $after · given stays $given';
  }

  @override
  String get zakatRecomputeHelp =>
      'What you already gave counts toward the new figure.';

  @override
  String get zakatNoteA4 => 'Nisab is checked on the due date only.';

  @override
  String get zakatNoteA8 =>
      'Gold, silver and all other wealth are added together by value.';

  @override
  String get zakatNoteZ4 =>
      'Based on the lines of this year only. Add other cash or money owed to you as an extra line. Add other assets in My Investments.';

  @override
  String get zakatHistoryTitle => 'History';

  @override
  String zakatHistoryGiven(String amount) {
    return 'given $amount';
  }

  @override
  String get zakatSettingsTooltip => 'Zakat settings';

  @override
  String get zakatSettingsNisab => 'Nisab standard';

  @override
  String get zakatSettingsNisabHelp =>
      'Frozen years keep the nisab they were started with.';

  @override
  String get zakatSettingsCycle => 'Zakat cycle date';

  @override
  String zakatCycleValue(String calendar, String day, String month) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': '$day $month (Hijri)',
      'solar': '$day $month (Gregorian)',
      'other': '$day $month',
    });
    return '$_temp0';
  }

  @override
  String get zakatNotSetYet => 'Not set yet';

  @override
  String get zakatSettingsRateView => 'Rate for giving in another currency';

  @override
  String get zakatSettingsRateViewNone => 'Not asked yet';

  @override
  String zakatChangeToTitle(String calendar) {
    String _temp0 = intl.Intl.selectLogic(calendar, {
      'lunar': 'Change to lunar (Hijri)?',
      'solar': 'Change to solar (Gregorian)?',
      'other': 'Change?',
    });
    return '$_temp0';
  }

  @override
  String get zakatChangeCycleTitle => 'Change the zakat cycle date?';

  @override
  String get zakatChangeKeep => 'These years keep their dates and rate:';

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
      'lunar': 'Your lunar cycle starts after $date.',
      'solar': 'Your solar cycle starts after $date.',
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
      'lunar': 'First lunar year: $label, ends $date ($rate).',
      'solar': 'First solar year: $label, ends $date ($rate).',
      'other': '$label',
    });
    return '$_temp0';
  }

  @override
  String zakatChangeAppliesFrom(String label) {
    return 'The new date applies from the year after $label.';
  }

  @override
  String get zakatMoveTitle => 'Move the due date';

  @override
  String get zakatMoveUmmAlQura => 'Umm al-Qura';

  @override
  String get zakatMoveSolarLine =>
      'You can move a solar date earlier only. Giving early is allowed; giving later delays zakat.';

  @override
  String get zakatMoveInfo =>
      'All figures and the notification use the new date. Next year is not affected.';

  @override
  String get src_A4 =>
      'One zakat date a year. If your wealth held nisab for a full lunar year, zakat is due on all zakatable wealth you hold that day, including money added during the year: Abu Dawud 1573; IIFA Res 28 (3/4) §4. Shafi\'i and Hanbali schools give new wealth its own year from the day it was acquired; this app uses the single date. Nisab is checked on the due date only. Hanafi: nisab must exist at the start and the end of the year (A4).';

  @override
  String get src_A5 =>
      'Debts you must pay within 12 months may be deducted from zakatable wealth. Scholars differ on long-term debts such as a mortgage: deduct the next 12 months of instalments, deduct all, or deduct none. The Shafi\'i view is that debt does not reduce zakat (al-Nawawi, al-Majmu\') — source not yet verified. AAOIFI SS 35 lists deductible liabilities — section numbers not yet verified (A5, C4).';

  @override
  String get src_A7 =>
      'Every currency is money for zakat (IIFA Res 21 (9/3)). Convert each holding at the rate on the due date (Darul Iftaa Mahmudiyyah; no AAOIFI or IIFA text found on the rate date) and add them (National Zakat Foundation UK). Giving zakat in another currency is allowed (A7).';

  @override
  String get src_A8 =>
      'Gold, silver and all other wealth are added together by value. Hanafis and Malikis combine by value; Shafi\'is do not combine gold and silver — primary source not yet verified (A8).';

  @override
  String get src_B9 =>
      'A good debt (the debtor is able and willing to pay) is zakatable every year, as if it were cash in hand. A doubtful debt has no zakat until it is received (IIFA Res 1 (1/2); Saudi Permanent Committee) (B9).';

  @override
  String get src_Z4 =>
      'Based on the lines of this year only. Extra lines take cash and good debts only (IIFA Res 1 (1/2)); gold, goods for sale and a business belong in My Investments. Nisab is priced as grams of the metal you chose times its rate on the due date; the pricing rule is not yet verified (Z-4, C5).';

  @override
  String get src_C1 =>
      'Zakat falls due when 12 lunar months have passed since your wealth first reached nisab: Abu Dawud 1573; Quran 9:36 and 2:189; Darul Iftaa Birmingham. If the date is not known, use a best estimate — common fatwa practice, source not yet verified (C1).';

  @override
  String get src_C2 =>
      'Zakat that is already due must not be pushed later. Most scholars hold that zakat is given when it falls due and not delayed without a valid reason (Saudi Permanent Committee, islamqa 13981; primary texts not yet verified). Hanafi: a zakat date may not be changed; you may give early on an estimate, then check the amount on the real date and make up any shortfall (FatwaCentre, 178985) (C2).';

  @override
  String get src_C3 =>
      'A lunar month starts when the new moon is seen and has 29 or 30 days (Bukhari 1909 and 1907; Quran 2:189). Umm al-Qura is a calculated calendar and can differ from local sighting by a day or two. Using it is a product choice, and moving the date by up to 2 days is the consultant\'s reading — source not yet verified. A cycle day 30 in a 29-day month uses the 29th — reading not yet verified. A solar date may move earlier only (C3).';

  @override
  String get src_C4 =>
      'Value all zakatable wealth on the due date and take off the debts you deduct. If what is left reaches nisab, zakat is due (Hanafi: Ibn Abidin, Radd al-Muhtar 2/260, via Council of Ulama Eastern Cape). Shafi\'i: debt does not cancel zakat; in the app that is deduction off. Below nisab, nothing is due (Abu Dawud 1573) (C4).';

  @override
  String get src_C5 =>
      'A good debt counts in full every year; a doubtful debt counts nothing until it is received (IIFA Res 1 (1/2)). Other wealth (gold, goods for sale, a business) goes in My Investments (C5).';

  @override
  String get src_C6 =>
      'Giving zakat before it falls due is allowed: Abu Dawud 1624 (Ali; al-Abbas asked to give early and the Prophet allowed it; graded hasan by al-Albani, da\'if by Zubair Ali Zai). Conditions: you hold nisab when you give it and you give it as zakat; the Shafi\'i school limits it to one year ahead (Darul Iftaa Jordan, Q 2974); Hanafi: give early, then check the amount on the real date (FatwaCentre 178985). The Maliki school accepts this only shortly before the due date — source not yet verified (C6).';

  @override
  String get src_C7 =>
      'Hanafi: an extra amount given as zakat may count toward next year (Darul Uloom Deoband, fatwa 28/76/D=01/1435). Shafi\'i: the extra is sadaqah, because each year\'s zakat needs its own intention (Darul Iftaa Jordan, Q 3602). The app does not move it, which is valid under both views (C7).';

  @override
  String get src_C8 =>
      'Scholars differ on the exchange rate that counts zakat given in another currency. The rate on the day you gave: Abu Yusuf and Muhammad (the Sahibayn); several contemporary Hanafi muftis prefer it (Muftionline 46417; fatwa-ca 178598). The rate on the due date: Abu Hanifa (Darul Iftaa Mahmudiyyah 134900, which allows a higher rate). The primary text, Radd al-Muhtar, is not yet verified (C8).';

  @override
  String get src_C9 =>
      'Zakat due is the correct amount on the due date, not the first figure the app worked out. What you already gave counts toward the corrected figure, and any shortfall is still owed (FatwaCentre 178985; SeekersGuidance, Mawlana Ilyas Patel). If the corrected figure is lower than what you gave, see C7 (C9).';

  @override
  String get src_C10 =>
      'Nothing is due below 20 dinars or 200 dirhams (Abu Dawud 1573). The notification says only that your zakat year ends, because the app has not yet checked that your wealth reaches nisab (C10).';

  @override
  String get src_C11 =>
      'Zakat is correct only when it is given as zakat to the eight groups named in Quran 9:60, and each year\'s zakat needs its own intention (Darul Iftaa Jordan, Q 3602). Sadaqah given in good faith to someone who did not qualify still counted as sadaqah (Bukhari 1421; Muslim 1022). Whether that also covers obligatory zakat is disputed (Abu Hanifa and Muhammad: yes, if the giver took care; Abu Yusuf: no) — not yet verified, and the app does not judge it. Interest given away is not zakat (Z-6) (C11).';

  @override
  String zakatFixMetalRate(String metal, String date) {
    String _temp0 = intl.Intl.selectLogic(metal, {
      'gold': 'Add a gold rate to see the nisab on $date',
      'silver': 'Add a silver rate to see the nisab on $date',
      'other': '$metal',
    });
    return '$_temp0';
  }

  @override
  String get zakatWhyLinesTotal =>
      'The sum of the zakatable amount of every line, each converted to your base currency at the rate on the due date.';

  @override
  String get zakatWhyBase =>
      'The lines total minus the debts you deduct. Never below 0.';

  @override
  String get zakatWhyNisab =>
      'Grams of the metal you chose times its rate on the due date.';

  @override
  String get zakatWhyReaches =>
      'Zakat is due only if the zakatable wealth reaches the nisab.';

  @override
  String get zakatWhyRate =>
      'The rate of your zakat year setting, for a full year. There is no day factor.';

  @override
  String get zakatWhyBelow =>
      'The zakatable wealth is below the nisab on the due date, so no zakat is due for this year.';

  @override
  String get zakatWhyLineValue =>
      'The value at the end of the due date: market value, not cost, net of interest kept inside, never adjusted for inflation.';

  @override
  String get zakatWhyLineRate =>
      'The latest rate on or before the due date, typed or fetched.';

  @override
  String get zakatWhyExtra => 'A line you added for this year only.';

  @override
  String get zakatWhyGiven =>
      'The sum of the amounts you logged, in the currency of this year. Remaining is the zakat due minus what you gave, never below 0.';

  @override
  String get zakatErrExtraUnit =>
      'Pick a currency. Gold and silver go in My Investments.';
}
