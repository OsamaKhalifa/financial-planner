import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
  ];

  /// App name shown in the app bar and task switcher.
  ///
  /// In en, this message translates to:
  /// **'Financial Planner'**
  String get appTitle;

  /// No description provided for @unitName.
  ///
  /// In en, this message translates to:
  /// **'{code, select, AED{UAE dirham}AUD{Australian dollar}BDT{Bangladeshi taka}BHD{Bahraini dinar}CAD{Canadian dollar}CHF{Swiss franc}CNY{Chinese yuan}DKK{Danish krone}DZD{Algerian dinar}EGP{Egyptian pound}EUR{Euro}GBP{Pound sterling}HKD{Hong Kong dollar}IDR{Indonesian rupiah}INR{Indian rupee}JOD{Jordanian dinar}JPY{Japanese yen}KWD{Kuwaiti dinar}MAD{Moroccan dirham}MYR{Malaysian ringgit}NGN{Nigerian naira}NOK{Norwegian krone}OMR{Omani rial}PKR{Pakistani rupee}QAR{Qatari riyal}SAR{Saudi riyal}SEK{Swedish krona}SGD{Singapore dollar}TND{Tunisian dinar}TRY{Turkish lira}USD{US dollar}XAG_g{Silver, grams (999)}XAU_g{Gold, grams (24k)}ZAR{South African rand}other{{code}}}'**
  String unitName(String code);

  /// No description provided for @countryName.
  ///
  /// In en, this message translates to:
  /// **'{code, select, ARE{UAE}AUS{Australia}BGD{Bangladesh}BHR{Bahrain}CAN{Canada}CHE{Switzerland}CHN{China}DNK{Denmark}DZA{Algeria}EGY{Egypt}EMU{Euro area}GBR{United Kingdom}HKG{Hong Kong}IDN{Indonesia}IND{India}JOR{Jordan}JPN{Japan}KWT{Kuwait}MAR{Morocco}MYS{Malaysia}NGA{Nigeria}NOR{Norway}OMN{Oman}PAK{Pakistan}QAT{Qatar}SAU{Saudi Arabia}SGP{Singapore}SWE{Sweden}TUN{Tunisia}TUR{Turkey}USA{United States}ZAF{South Africa}other{{code}}}'**
  String countryName(String code);

  /// No description provided for @marketName.
  ///
  /// In en, this message translates to:
  /// **'{code, select, tadawul{Tadawul}egx{EGX}nasdaq{NASDAQ}nyse{NYSE}lse{LSE}dfm{DFM}adx{ADX}boursaKuwait{Boursa Kuwait}qse{QSE}bursaMalaysia{Bursa Malaysia}bist{BIST}psx{PSX}otherMarket{Other market}other{{code}}}'**
  String marketName(String code);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @setupBaseTitle.
  ///
  /// In en, this message translates to:
  /// **'What currency do you count your wealth in?'**
  String get setupBaseTitle;

  /// No description provided for @setupBaseHelp.
  ///
  /// In en, this message translates to:
  /// **'Totals, monthly and yearly figures, and zakat set-aside use this currency. You can change it later.'**
  String get setupBaseHelp;

  /// No description provided for @homeInflationLine.
  ///
  /// In en, this message translates to:
  /// **'Home inflation: {country} (from {currency})'**
  String homeInflationLine(String country, String currency);

  /// No description provided for @setupZakatTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you calculate zakat?'**
  String get setupZakatTitle;

  /// No description provided for @zakatYearTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat year'**
  String get zakatYearTitle;

  /// No description provided for @zakatYearLunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar — 2.5 % over 354 days'**
  String get zakatYearLunar;

  /// No description provided for @zakatYearSolar.
  ///
  /// In en, this message translates to:
  /// **'Solar — 2.577 % over 365 days (AAOIFI)'**
  String get zakatYearSolar;

  /// No description provided for @zakatYearWhy.
  ///
  /// In en, this message translates to:
  /// **'Some scholars allow a solar year with an adjusted rate; others keep the lunar year.'**
  String get zakatYearWhy;

  /// No description provided for @longTermTitle.
  ///
  /// In en, this message translates to:
  /// **'Long-held shares and funds'**
  String get longTermTitle;

  /// No description provided for @longTermDividendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Dividends only (IIFA)'**
  String get longTermDividendsOnly;

  /// No description provided for @longTermProxy25.
  ///
  /// In en, this message translates to:
  /// **'25 % of value (NZF proxy)'**
  String get longTermProxy25;

  /// No description provided for @longTermFullValue.
  ///
  /// In en, this message translates to:
  /// **'Full value (precaution)'**
  String get longTermFullValue;

  /// No description provided for @longTermPerItem.
  ///
  /// In en, this message translates to:
  /// **'I\'ll decide per item'**
  String get longTermPerItem;

  /// No description provided for @longTermNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get longTermNotNow;

  /// No description provided for @longTermWhy.
  ///
  /// In en, this message translates to:
  /// **'When company data is unknown, scholars use different methods.'**
  String get longTermWhy;

  /// No description provided for @addInvestment.
  ///
  /// In en, this message translates to:
  /// **'Add investment'**
  String get addInvestment;

  /// No description provided for @assumptions.
  ///
  /// In en, this message translates to:
  /// **'Assumptions'**
  String get assumptions;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total value'**
  String get totalValue;

  /// No description provided for @asOfDate.
  ///
  /// In en, this message translates to:
  /// **'as of {date}'**
  String asOfDate(String date);

  /// No description provided for @showIn.
  ///
  /// In en, this message translates to:
  /// **'Show in'**
  String get showIn;

  /// No description provided for @viewGold.
  ///
  /// In en, this message translates to:
  /// **'Gold g'**
  String get viewGold;

  /// No description provided for @viewSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver g'**
  String get viewSilver;

  /// No description provided for @excludesItems.
  ///
  /// In en, this message translates to:
  /// **'Excludes {count} — rate missing: {pairs}'**
  String excludesItems(String count, String pairs);

  /// No description provided for @toPurifyLine.
  ///
  /// In en, this message translates to:
  /// **'Interest to purify: {amount}'**
  String toPurifyLine(String amount);

  /// No description provided for @verdictKept.
  ///
  /// In en, this message translates to:
  /// **'{year} so far: purchasing power kept {amount}'**
  String verdictKept(String year, String amount);

  /// No description provided for @verdictLost.
  ///
  /// In en, this message translates to:
  /// **'{year} so far: purchasing power lost {amount}'**
  String verdictLost(String year, String amount);

  /// No description provided for @verdictNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'{year} so far: purchasing power not available'**
  String verdictNotAvailable(String year);

  /// No description provided for @inflationShipped.
  ///
  /// In en, this message translates to:
  /// **'{country} inflation: shipped ({source}, as of {year})'**
  String inflationShipped(String country, String source, String year);

  /// No description provided for @inflationYours.
  ///
  /// In en, this message translates to:
  /// **'{country} inflation: your values'**
  String inflationYours(String country);

  /// No description provided for @inflationAssumed.
  ///
  /// In en, this message translates to:
  /// **'inflation assumed from {year}'**
  String inflationAssumed(String year);

  /// No description provided for @inflationEmpty.
  ///
  /// In en, this message translates to:
  /// **'No inflation data for {country}'**
  String inflationEmpty(String country);

  /// No description provided for @staleBanner.
  ///
  /// In en, this message translates to:
  /// **'Not updated this month: {values} values, {rates} rates'**
  String staleBanner(String values, String rates);

  /// No description provided for @updateAll.
  ///
  /// In en, this message translates to:
  /// **'Update all'**
  String get updateAll;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @sortValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get sortValue;

  /// No description provided for @sortReturn.
  ///
  /// In en, this message translates to:
  /// **'Return since start'**
  String get sortReturn;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest update first'**
  String get sortOldest;

  /// No description provided for @closedSection.
  ///
  /// In en, this message translates to:
  /// **'Closed ({count})'**
  String closedSection(String count);

  /// No description provided for @notUpdatedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Not updated this month'**
  String get notUpdatedThisMonth;

  /// No description provided for @metalRateNotUpdated.
  ///
  /// In en, this message translates to:
  /// **'Metal rate not updated this month'**
  String get metalRateNotUpdated;

  /// No description provided for @rateMissingAdd.
  ///
  /// In en, this message translates to:
  /// **'{from}→{to} rate missing · Add'**
  String rateMissingAdd(String from, String to);

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No investments yet.'**
  String get emptyTitle;

  /// No description provided for @dataStaysOnPhone.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this phone.'**
  String get dataStaysOnPhone;

  /// No description provided for @presetMonthlyFund.
  ///
  /// In en, this message translates to:
  /// **'Monthly fund'**
  String get presetMonthlyFund;

  /// No description provided for @presetGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get presetGold;

  /// No description provided for @presetStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get presetStock;

  /// No description provided for @pureGrams.
  ///
  /// In en, this message translates to:
  /// **'{grams} pure'**
  String pureGrams(String grams);

  /// No description provided for @typeAndMarket.
  ///
  /// In en, this message translates to:
  /// **'{type} · {market}'**
  String typeAndMarket(String type, String market);

  /// No description provided for @amountWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit}'**
  String amountWithUnit(String amount, String unit);

  /// No description provided for @pickUnit.
  ///
  /// In en, this message translates to:
  /// **'Choose a unit'**
  String get pickUnit;

  /// No description provided for @searchUnits.
  ///
  /// In en, this message translates to:
  /// **'Search by code or name'**
  String get searchUnits;

  /// No description provided for @mostUsed.
  ///
  /// In en, this message translates to:
  /// **'Most used'**
  String get mostUsed;

  /// No description provided for @allUnits.
  ///
  /// In en, this message translates to:
  /// **'All units'**
  String get allUnits;

  /// No description provided for @chooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose a country'**
  String get chooseCountry;

  /// No description provided for @typeStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get typeStock;

  /// No description provided for @typeFund.
  ///
  /// In en, this message translates to:
  /// **'Fund / ETF'**
  String get typeFund;

  /// No description provided for @typeSukuk.
  ///
  /// In en, this message translates to:
  /// **'Sukuk'**
  String get typeSukuk;

  /// No description provided for @typeGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get typeGold;

  /// No description provided for @typeSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get typeSilver;

  /// No description provided for @typeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash deposit'**
  String get typeCash;

  /// No description provided for @typeCrypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get typeCrypto;

  /// No description provided for @typeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get typeOther;

  /// No description provided for @intentTrading.
  ///
  /// In en, this message translates to:
  /// **'Trading'**
  String get intentTrading;

  /// No description provided for @intentLongTerm.
  ///
  /// In en, this message translates to:
  /// **'Long-term'**
  String get intentLongTerm;

  /// No description provided for @intentPersonalUse.
  ///
  /// In en, this message translates to:
  /// **'Personal use'**
  String get intentPersonalUse;

  /// No description provided for @intentRental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get intentRental;

  /// No description provided for @openSection.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openSection;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWrong;

  /// No description provided for @whyWhat.
  ///
  /// In en, this message translates to:
  /// **'What it is'**
  String get whyWhat;

  /// No description provided for @whyNumbers.
  ///
  /// In en, this message translates to:
  /// **'Your numbers'**
  String get whyNumbers;

  /// No description provided for @whyAssumptions.
  ///
  /// In en, this message translates to:
  /// **'Assumptions used'**
  String get whyAssumptions;

  /// No description provided for @whySource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get whySource;

  /// No description provided for @sourceUnverified.
  ///
  /// In en, this message translates to:
  /// **'source not yet verified'**
  String get sourceUnverified;

  /// No description provided for @src_A1A2.
  ///
  /// In en, this message translates to:
  /// **'2.5 % of the zakatable base once per lunar year: Abu Dawud 1573 (A1). A solar year at 2.577 %: AAOIFI Shari\'ah Standard 35, reported by the National Zakat Foundation UK (A2) — section number not yet verified. Other scholars (Hanafi, Mufti Online) keep exactly 2.5 % and the lunar date.'**
  String get src_A1A2;

  /// No description provided for @src_B1.
  ///
  /// In en, this message translates to:
  /// **'Cash and bank balances are zakatable in full: Quran 9:34–35; Abu Dawud 1573; IIFA Res 21 (9/3) (B1).'**
  String get src_B1;

  /// No description provided for @src_B2.
  ///
  /// In en, this message translates to:
  /// **'Gold and silver held as savings: zakat on market value (Quran 9:34; Abu Dawud 1573). Worn jewellery: Hanafis say zakat is due (Abu Dawud 1563); Malikis, Shafi\'is and Hanbalis say it is not (B2).'**
  String get src_B2;

  /// No description provided for @src_B3.
  ///
  /// In en, this message translates to:
  /// **'Trading shares: 100 % of market value (IIFA Res 28 (3/4) §3, Res 121 (3/13)). Held long term with no company data: dividends only (IIFA Res 28 §3); or 25 % of value as a proxy (National Zakat Foundation UK); or full value as a precaution. A company that pays zakat itself: shareholder does not pay again (IIFA Res 28 §1) (B3).'**
  String get src_B3;

  /// No description provided for @src_B4.
  ///
  /// In en, this message translates to:
  /// **'Funds and ETFs follow the share rules at fund level. Sukuk: 100 % of face or market value by default, with override (B4); AAOIFI SS 35 and SS 17 section numbers not yet verified.'**
  String get src_B4;

  /// No description provided for @src_B5.
  ///
  /// In en, this message translates to:
  /// **'Personal-use property is not zakatable. Rental property: zakat is not on the property; rent still held counts with cash (IIFA Res 2 (2/2)). Bought to resell: 100 % of market value (B5).'**
  String get src_B5;

  /// No description provided for @src_B8.
  ///
  /// In en, this message translates to:
  /// **'Scholars differ on whether holding crypto is permitted (IIFA Res 237 (24/8) gave no final ruling). Those who permit it say zakat is due on its full market value (B8).'**
  String get src_B8;

  /// No description provided for @src_Z6.
  ///
  /// In en, this message translates to:
  /// **'Interest is not the owner\'s wealth: it is not return and not in the zakat base, and it is given away (Quran 2:278–279). Giving it away does not count as zakat (B1). AAOIFI SS 21 section not yet verified.'**
  String get src_Z6;

  /// No description provided for @src_A6.
  ///
  /// In en, this message translates to:
  /// **'Zakat is always on the actual value on the zakat date, never on an inflation-adjusted value (IIFA Res 28 (3/4) §3). The real return is shown for planning only (A6).'**
  String get src_A6;

  /// No description provided for @src_A3.
  ///
  /// In en, this message translates to:
  /// **'Nisab: gold 85 g (20 dinars) and silver 595 g (200 dirhams): Abu Dawud 1573; Bukhari 1447; Muslim 979. Which metal to use for cash is a point of difference (A3).'**
  String get src_A3;

  /// No description provided for @sourceName.
  ///
  /// In en, this message translates to:
  /// **'World Bank'**
  String get sourceName;

  /// No description provided for @verdictCaption.
  ///
  /// In en, this message translates to:
  /// **'After set-aside, after home inflation'**
  String get verdictCaption;

  /// No description provided for @rateMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate missing'**
  String get rateMissingTitle;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get openSource;

  /// No description provided for @returnLine.
  ///
  /// In en, this message translates to:
  /// **'Return (since {date})'**
  String returnLine(String date);

  /// No description provided for @valueFromDate.
  ///
  /// In en, this message translates to:
  /// **'Value from {date}'**
  String valueFromDate(String date);

  /// No description provided for @whyToPurifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Interest to purify'**
  String get whyToPurifyTitle;

  /// No description provided for @whyToPurifyWhat.
  ///
  /// In en, this message translates to:
  /// **'All interest recorded minus all interest given away. It is not return and not in the zakat base. Giving it away does not count as zakat. It is never netted against the set-aside.'**
  String get whyToPurifyWhat;

  /// No description provided for @formTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add investment'**
  String get formTitleAdd;

  /// No description provided for @formTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit investment'**
  String get formTitleEdit;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// No description provided for @fieldMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get fieldMarket;

  /// No description provided for @fieldMarketCountry.
  ///
  /// In en, this message translates to:
  /// **'Market country'**
  String get fieldMarketCountry;

  /// No description provided for @fieldUnit.
  ///
  /// In en, this message translates to:
  /// **'Item unit'**
  String get fieldUnit;

  /// No description provided for @fieldStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get fieldStartDate;

  /// No description provided for @fieldPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid (first money in)'**
  String get fieldPaid;

  /// No description provided for @fieldPaidUnit.
  ///
  /// In en, this message translates to:
  /// **'Paid in'**
  String get fieldPaidUnit;

  /// No description provided for @fieldCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'Current value (optional)'**
  String get fieldCurrentValue;

  /// No description provided for @fieldValueDate.
  ///
  /// In en, this message translates to:
  /// **'Value date'**
  String get fieldValueDate;

  /// No description provided for @fieldQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity (optional)'**
  String get fieldQuantity;

  /// No description provided for @fieldGrams.
  ///
  /// In en, this message translates to:
  /// **'Grams (gross)'**
  String get fieldGrams;

  /// No description provided for @fieldPurity.
  ///
  /// In en, this message translates to:
  /// **'Purity'**
  String get fieldPurity;

  /// No description provided for @fieldIntent.
  ///
  /// In en, this message translates to:
  /// **'Intent'**
  String get fieldIntent;

  /// No description provided for @fieldShare.
  ///
  /// In en, this message translates to:
  /// **'Zakat share (% of value)'**
  String get fieldShare;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get fieldNotes;

  /// No description provided for @karat.
  ///
  /// In en, this message translates to:
  /// **'{k}k'**
  String karat(String k);

  /// No description provided for @fineness.
  ///
  /// In en, this message translates to:
  /// **'{k}'**
  String fineness(String k);

  /// No description provided for @pureGramsPreview.
  ///
  /// In en, this message translates to:
  /// **'= {grams} pure'**
  String pureGramsPreview(String grams);

  /// No description provided for @errName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get errName;

  /// No description provided for @errType.
  ///
  /// In en, this message translates to:
  /// **'Choose a type'**
  String get errType;

  /// No description provided for @errIntent.
  ///
  /// In en, this message translates to:
  /// **'Choose an intent'**
  String get errIntent;

  /// No description provided for @errMarket.
  ///
  /// In en, this message translates to:
  /// **'Choose a market'**
  String get errMarket;

  /// No description provided for @errMarketCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose the market\'s country'**
  String get errMarketCountry;

  /// No description provided for @errUnit.
  ///
  /// In en, this message translates to:
  /// **'Choose a unit'**
  String get errUnit;

  /// No description provided for @errStartDate.
  ///
  /// In en, this message translates to:
  /// **'Choose the start date'**
  String get errStartDate;

  /// No description provided for @errFirstPaid.
  ///
  /// In en, this message translates to:
  /// **'Enter what you paid'**
  String get errFirstPaid;

  /// No description provided for @errGrams.
  ///
  /// In en, this message translates to:
  /// **'Enter the grams'**
  String get errGrams;

  /// No description provided for @errPurity.
  ///
  /// In en, this message translates to:
  /// **'Choose the purity'**
  String get errPurity;

  /// No description provided for @errZero.
  ///
  /// In en, this message translates to:
  /// **'Must be more than 0'**
  String get errZero;

  /// No description provided for @errFuture.
  ///
  /// In en, this message translates to:
  /// **'The date cannot be in the future'**
  String get errFuture;

  /// No description provided for @errShare.
  ///
  /// In en, this message translates to:
  /// **'Enter the zakat share, 0 to 100 %'**
  String get errShare;

  /// No description provided for @errLongTerm.
  ///
  /// In en, this message translates to:
  /// **'Choose how long-held shares are handled'**
  String get errLongTerm;

  /// No description provided for @errJewellery.
  ///
  /// In en, this message translates to:
  /// **'Choose the jewellery ruling'**
  String get errJewellery;

  /// No description provided for @errSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} fields need attention'**
  String errSummary(String count);

  /// No description provided for @errSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Nothing was changed. Try again.'**
  String get errSave;

  /// No description provided for @savedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedToast;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this investment?'**
  String get discardTitle;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @zakatLinePercent.
  ///
  /// In en, this message translates to:
  /// **'Zakat: on {share} of value'**
  String zakatLinePercent(String share);

  /// No description provided for @zakatLineDividends.
  ///
  /// In en, this message translates to:
  /// **'Zakat: on dividends only, when received'**
  String get zakatLineDividends;

  /// No description provided for @zakatLineCompany.
  ///
  /// In en, this message translates to:
  /// **'Zakat: 0 % — the company pays zakat'**
  String get zakatLineCompany;

  /// No description provided for @zakatNeedsChoice.
  ///
  /// In en, this message translates to:
  /// **'Zakat: choose below'**
  String get zakatNeedsChoice;

  /// No description provided for @zakatReasonTrading.
  ///
  /// In en, this message translates to:
  /// **'You hold this to sell. Trade goods pay 2.5 % of market value.'**
  String get zakatReasonTrading;

  /// No description provided for @zakatReasonSavings.
  ///
  /// In en, this message translates to:
  /// **'Held as savings: zakat on market value.'**
  String get zakatReasonSavings;

  /// No description provided for @zakatReasonCash.
  ///
  /// In en, this message translates to:
  /// **'Cash is zakatable in full.'**
  String get zakatReasonCash;

  /// No description provided for @zakatReasonSukuk.
  ///
  /// In en, this message translates to:
  /// **'Sukuk: 100 % of value by default.'**
  String get zakatReasonSukuk;

  /// No description provided for @zakatReasonJewellery.
  ///
  /// In en, this message translates to:
  /// **'Worn jewellery: follows your ruling.'**
  String get zakatReasonJewellery;

  /// No description provided for @zakatReasonCustom.
  ///
  /// In en, this message translates to:
  /// **'You set this share yourself.'**
  String get zakatReasonCustom;

  /// No description provided for @noticeDividends.
  ///
  /// In en, this message translates to:
  /// **'Zakat on your dividends is counted with your cash.'**
  String get noticeDividends;

  /// No description provided for @noticeCrypto.
  ///
  /// In en, this message translates to:
  /// **'Scholars differ on whether holding crypto is permitted. Those who permit it say zakat is on its full market value.'**
  String get noticeCrypto;

  /// No description provided for @companyPays.
  ///
  /// In en, this message translates to:
  /// **'Company pays zakat for me (0 %)'**
  String get companyPays;

  /// No description provided for @jewelleryAsk.
  ///
  /// In en, this message translates to:
  /// **'Is worn jewellery zakatable?'**
  String get jewelleryAsk;

  /// No description provided for @jewelleryYes.
  ///
  /// In en, this message translates to:
  /// **'Zakatable'**
  String get jewelleryYes;

  /// No description provided for @jewelleryNo.
  ///
  /// In en, this message translates to:
  /// **'Not zakatable'**
  String get jewelleryNo;

  /// No description provided for @jewelleryWhy.
  ///
  /// In en, this message translates to:
  /// **'The schools differ on jewellery that is worn.'**
  String get jewelleryWhy;

  /// No description provided for @hintLongTerm.
  ///
  /// In en, this message translates to:
  /// **'Enter the zakatable part of the business: cash, receivables and stock for sale, less short-term debts. Machines and buildings are not counted.'**
  String get hintLongTerm;

  /// No description provided for @hintRental.
  ///
  /// In en, this message translates to:
  /// **'Zakat is not on the property; rent you still hold is counted with your cash. Usually 0 %.'**
  String get hintRental;

  /// No description provided for @hintPersonalUse.
  ///
  /// In en, this message translates to:
  /// **'Personal-use items: usually 0 %.'**
  String get hintPersonalUse;

  /// No description provided for @hintTrading.
  ///
  /// In en, this message translates to:
  /// **'Bought to resell: usually 100 % of market value.'**
  String get hintTrading;

  /// No description provided for @useShare.
  ///
  /// In en, this message translates to:
  /// **'Use {share} %'**
  String useShare(String share);

  /// No description provided for @inlineRateLabel.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = ____ {to} on {date}'**
  String inlineRateLabel(String from, String to, String date);

  /// No description provided for @inlineRateField.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get inlineRateField;

  /// No description provided for @rateSaved.
  ///
  /// In en, this message translates to:
  /// **'Rate saved'**
  String get rateSaved;

  /// No description provided for @fetchRate.
  ///
  /// In en, this message translates to:
  /// **'Fetch'**
  String get fetchRate;

  /// No description provided for @errRate.
  ///
  /// In en, this message translates to:
  /// **'Enter a rate above 0'**
  String get errRate;

  /// No description provided for @deleteInvestment.
  ///
  /// In en, this message translates to:
  /// **'Delete investment'**
  String get deleteInvestment;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete investment and its whole history?'**
  String get deleteConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
