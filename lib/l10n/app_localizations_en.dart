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
  String get totalValue => 'Total value';

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
  String toPurifyLine(String amount) {
    return 'Interest to purify: $amount';
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
      'Scholars differ on whether holding crypto is permitted (IIFA Res 237 (24/8) gave no final ruling). Those who permit it say zakat is due on its full market value (B8).';

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
  String get zakatNeedsChoice => 'Zakat: choose below';

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
      'Zakat on your dividends is counted with your cash.';

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
      'Rate × zakat share × end value × days ÷ year length, in the matched pair you chose. Actual zakat is due once a year on your zakat date.';

  @override
  String whySetAsideNumbers(
    String z,
    String rate,
    String share,
    String ev,
    String days,
    String year,
  ) {
    return '$z = $rate × $share × $ev × $days ÷ $year';
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
}
