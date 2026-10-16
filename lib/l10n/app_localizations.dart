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

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @valueNow.
  ///
  /// In en, this message translates to:
  /// **'Value now'**
  String get valueNow;

  /// No description provided for @approxInBase.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount}'**
  String approxInBase(String amount);

  /// No description provided for @sinceStart.
  ///
  /// In en, this message translates to:
  /// **'Since start'**
  String get sinceStart;

  /// No description provided for @colItem.
  ///
  /// In en, this message translates to:
  /// **'In {unit}'**
  String colItem(String unit);

  /// No description provided for @rowGain.
  ///
  /// In en, this message translates to:
  /// **'Gain'**
  String get rowGain;

  /// No description provided for @rowReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get rowReturn;

  /// No description provided for @rowPerYear.
  ///
  /// In en, this message translates to:
  /// **'Per year'**
  String get rowPerYear;

  /// No description provided for @rowSetAside.
  ///
  /// In en, this message translates to:
  /// **'Estimated zakat set-aside (planning)'**
  String get rowSetAside;

  /// No description provided for @setAsideNote.
  ///
  /// In en, this message translates to:
  /// **'Actual zakat is due once a year on your zakat date.'**
  String get setAsideNote;

  /// No description provided for @rowReturnAfter.
  ///
  /// In en, this message translates to:
  /// **'Return after set-aside'**
  String get rowReturnAfter;

  /// No description provided for @rowRealOwn.
  ///
  /// In en, this message translates to:
  /// **'Real · own market ({country})'**
  String rowRealOwn(String country);

  /// No description provided for @rowRealBase.
  ///
  /// In en, this message translates to:
  /// **'Real · in your money ({country})'**
  String rowRealBase(String country);

  /// No description provided for @realLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchasing power (for planning only — zakat is always on today\'s actual value)'**
  String get realLabel;

  /// No description provided for @byMonthYear.
  ///
  /// In en, this message translates to:
  /// **'By month and year'**
  String get byMonthYear;

  /// No description provided for @needsRate.
  ///
  /// In en, this message translates to:
  /// **'Needs {from}→{to} rate'**
  String needsRate(String from, String to);

  /// No description provided for @toPurifyItem.
  ///
  /// In en, this message translates to:
  /// **'Interest to purify: {amount} · not counted as return'**
  String toPurifyItem(String amount);

  /// No description provided for @recordGivenAway.
  ///
  /// In en, this message translates to:
  /// **'Record given away'**
  String get recordGivenAway;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @closedOn.
  ///
  /// In en, this message translates to:
  /// **'Closed on {date}'**
  String closedOn(String date);

  /// No description provided for @kindMoneyIn.
  ///
  /// In en, this message translates to:
  /// **'Money in'**
  String get kindMoneyIn;

  /// No description provided for @kindSale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get kindSale;

  /// No description provided for @kindIncome.
  ///
  /// In en, this message translates to:
  /// **'Income received'**
  String get kindIncome;

  /// No description provided for @kindValue.
  ///
  /// In en, this message translates to:
  /// **'Value update'**
  String get kindValue;

  /// No description provided for @kindInterestKept.
  ///
  /// In en, this message translates to:
  /// **'Interest kept inside'**
  String get kindInterestKept;

  /// No description provided for @kindInterestPaid.
  ///
  /// In en, this message translates to:
  /// **'Interest paid out'**
  String get kindInterestPaid;

  /// No description provided for @kindGivenInside.
  ///
  /// In en, this message translates to:
  /// **'Interest given away (from inside)'**
  String get kindGivenInside;

  /// No description provided for @kindGivenPaid.
  ///
  /// In en, this message translates to:
  /// **'Interest given away (from paid out)'**
  String get kindGivenPaid;

  /// No description provided for @tabValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get tabValue;

  /// No description provided for @tabIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get tabIn;

  /// No description provided for @tabOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get tabOut;

  /// No description provided for @tabInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get tabInterest;

  /// No description provided for @interestReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get interestReceived;

  /// No description provided for @interestGivenAway.
  ///
  /// In en, this message translates to:
  /// **'Given away'**
  String get interestGivenAway;

  /// No description provided for @interestWhere.
  ///
  /// In en, this message translates to:
  /// **'Where is it?'**
  String get interestWhere;

  /// No description provided for @interestPaidOut.
  ///
  /// In en, this message translates to:
  /// **'Paid out to me'**
  String get interestPaidOut;

  /// No description provided for @interestKeptInside.
  ///
  /// In en, this message translates to:
  /// **'Kept inside this item'**
  String get interestKeptInside;

  /// No description provided for @interestNote.
  ///
  /// In en, this message translates to:
  /// **'Interest is not counted as return and not in the zakat base. It is shown as \"to purify\" so you can give it away.'**
  String get interestNote;

  /// No description provided for @givenFrom.
  ///
  /// In en, this message translates to:
  /// **'Given from'**
  String get givenFrom;

  /// No description provided for @givenAwayNote.
  ///
  /// In en, this message translates to:
  /// **'Giving it away does not count as zakat.'**
  String get givenAwayNote;

  /// No description provided for @effectKept.
  ///
  /// In en, this message translates to:
  /// **'Lowers the item\'s value and the to-purify total by the same amount. Return is not affected.'**
  String get effectKept;

  /// No description provided for @effectPaid.
  ///
  /// In en, this message translates to:
  /// **'Lowers the to-purify total. The item\'s value does not change.'**
  String get effectPaid;

  /// No description provided for @fieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldAmount;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get fieldValue;

  /// No description provided for @fieldValueAfter.
  ///
  /// In en, this message translates to:
  /// **'Value after (optional)'**
  String get fieldValueAfter;

  /// No description provided for @fieldValueLeft.
  ///
  /// In en, this message translates to:
  /// **'Value left'**
  String get fieldValueLeft;

  /// No description provided for @fieldKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get fieldKind;

  /// No description provided for @lastValue.
  ///
  /// In en, this message translates to:
  /// **'Last: {value} on {date}'**
  String lastValue(String value, String date);

  /// No description provided for @typoCheck.
  ///
  /// In en, this message translates to:
  /// **'This is {times}× the last value. Check the number.'**
  String typoCheck(String times);

  /// No description provided for @valueLeftRequired.
  ///
  /// In en, this message translates to:
  /// **'This is more than the item\'s value. Enter what is left (0 or more).'**
  String get valueLeftRequired;

  /// No description provided for @closesInvestment.
  ///
  /// In en, this message translates to:
  /// **'This closes the investment. It stays in past months.'**
  String get closesInvestment;

  /// No description provided for @errBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Can\'t be before the start date ({date})'**
  String errBeforeStart(String date);

  /// No description provided for @errGivenTooMuch.
  ///
  /// In en, this message translates to:
  /// **'You have {amount} interest still to purify there. Enter that or less.'**
  String errGivenTooMuch(String amount);

  /// No description provided for @replaceValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace the value of {date}?'**
  String replaceValueTitle(String date);

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @nothingToPurify.
  ///
  /// In en, this message translates to:
  /// **'No interest left to give away.'**
  String get nothingToPurify;

  /// No description provided for @perUnit.
  ///
  /// In en, this message translates to:
  /// **'Per unit'**
  String get perUnit;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @zakatSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get zakatSectionTitle;

  /// No description provided for @whyReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get whyReturnTitle;

  /// No description provided for @whyReturnWhat.
  ///
  /// In en, this message translates to:
  /// **'Money-weighted return (Modified Dietz): deposits are not profit. Over long periods with large flows it can differ from the exact money-weighted return.'**
  String get whyReturnWhat;

  /// No description provided for @whyReturnNumbers.
  ///
  /// In en, this message translates to:
  /// **'{r} = ({ev} − {bv} − {cf}) ÷ {d}  (end value − start value − money in/out, ÷ average money invested)'**
  String whyReturnNumbers(String r, String ev, String bv, String cf, String d);

  /// No description provided for @whySetAsideTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated zakat set-aside (planning)'**
  String get whySetAsideTitle;

  /// No description provided for @whySetAsideWhat.
  ///
  /// In en, this message translates to:
  /// **'Rate × zakat share × end value × days ÷ year length, in the matched pair you chose. Actual zakat is due once a year on your zakat date.'**
  String get whySetAsideWhat;

  /// No description provided for @whySetAsideNumbers.
  ///
  /// In en, this message translates to:
  /// **'{z} = {rate} × {share} × {ev} × {days} ÷ {year}'**
  String whySetAsideNumbers(
    String z,
    String rate,
    String share,
    String ev,
    String days,
    String year,
  );

  /// No description provided for @whyRealTitle.
  ///
  /// In en, this message translates to:
  /// **'Real return'**
  String get whyRealTitle;

  /// No description provided for @whyRealWhat.
  ///
  /// In en, this message translates to:
  /// **'(1 + return) ÷ (1 + inflation) − 1. For planning only; it never changes the zakat base.'**
  String get whyRealWhat;

  /// No description provided for @whyRealNumbers.
  ///
  /// In en, this message translates to:
  /// **'return {r}, inflation {i} → {real}'**
  String whyRealNumbers(String r, String i, String real);

  /// No description provided for @whyGapTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchasing-power gap'**
  String get whyGapTitle;

  /// No description provided for @whyGapWhat.
  ///
  /// In en, this message translates to:
  /// **'(End value − set-aside) compared with (start value + money in/out + inflation on the average money invested). Zero or more means purchasing power was kept.'**
  String get whyGapWhat;

  /// No description provided for @whyGapNumbers.
  ///
  /// In en, this message translates to:
  /// **'gap {gap}; needed end value {needed}'**
  String whyGapNumbers(String gap, String needed);

  /// No description provided for @whyShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat share'**
  String get whyShareTitle;

  /// No description provided for @whyInflationTitle.
  ///
  /// In en, this message translates to:
  /// **'Inflation'**
  String get whyInflationTitle;

  /// No description provided for @whyInflationWhat.
  ///
  /// In en, this message translates to:
  /// **'Yearly rates of the series, pro-rated by days for this period.'**
  String get whyInflationWhat;

  /// No description provided for @monthsYears.
  ///
  /// In en, this message translates to:
  /// **'By month and year'**
  String get monthsYears;

  /// No description provided for @updateAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Update all'**
  String get updateAllTitle;

  /// No description provided for @refreshRates.
  ///
  /// In en, this message translates to:
  /// **'Refresh rates online'**
  String get refreshRates;

  /// No description provided for @refreshHelp.
  ///
  /// In en, this message translates to:
  /// **'Downloads the same public price list for everyone. Nothing about you is sent.'**
  String get refreshHelp;

  /// No description provided for @lastRefresh.
  ///
  /// In en, this message translates to:
  /// **'Last refresh: rates as of {date} · {source}'**
  String lastRefresh(String date, String source);

  /// No description provided for @refreshRunning.
  ///
  /// In en, this message translates to:
  /// **'Refreshing…'**
  String get refreshRunning;

  /// No description provided for @refreshDone.
  ///
  /// In en, this message translates to:
  /// **'Rates as of {date} · {source} · {count} of your rates updated'**
  String refreshDone(String date, String source, String count);

  /// No description provided for @refreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh. Nothing changed. Your saved rates are still used — type a rate below if you have a newer one.'**
  String get refreshFailed;

  /// No description provided for @refreshSource.
  ///
  /// In en, this message translates to:
  /// **'currency-api (fawazahmed0)'**
  String get refreshSource;

  /// No description provided for @asOfLabel.
  ///
  /// In en, this message translates to:
  /// **'As of'**
  String get asOfLabel;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @ratesStillOld.
  ///
  /// In en, this message translates to:
  /// **'Rates still old'**
  String get ratesStillOld;

  /// No description provided for @valuesHeading.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get valuesHeading;

  /// No description provided for @same.
  ///
  /// In en, this message translates to:
  /// **'Same'**
  String get same;

  /// No description provided for @filledCount.
  ///
  /// In en, this message translates to:
  /// **'{filled} of {total} filled'**
  String filledCount(String filled, String total);

  /// No description provided for @updatedToast.
  ///
  /// In en, this message translates to:
  /// **'Updated {count} values. {left} still old.'**
  String updatedToast(String count, String left);

  /// No description provided for @ratesSavedValuesNot.
  ///
  /// In en, this message translates to:
  /// **'Rates saved, values not saved — try again'**
  String get ratesSavedValuesNot;

  /// No description provided for @allUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Everything is up to date for {month}'**
  String allUpToDate(String month);

  /// No description provided for @saveUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save {count} updates?'**
  String saveUpdatesTitle(String count);

  /// No description provided for @lastHint.
  ///
  /// In en, this message translates to:
  /// **'last {value} · {date}'**
  String lastHint(String value, String date);

  /// No description provided for @rateRowLabel.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = ____ {to}'**
  String rateRowLabel(String from, String to);

  /// No description provided for @periodTitle.
  ///
  /// In en, this message translates to:
  /// **'Period view'**
  String get periodTitle;

  /// No description provided for @allInvestments.
  ///
  /// In en, this message translates to:
  /// **'All investments'**
  String get allInvestments;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthLabel;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// No description provided for @rowInflation.
  ///
  /// In en, this message translates to:
  /// **'Inflation ({country})'**
  String rowInflation(String country);

  /// No description provided for @rowRealAfter.
  ///
  /// In en, this message translates to:
  /// **'Real return after set-aside'**
  String get rowRealAfter;

  /// No description provided for @rowRealBefore.
  ///
  /// In en, this message translates to:
  /// **'Real return before set-aside: {value}'**
  String rowRealBefore(String value);

  /// No description provided for @inflationForPeriod.
  ///
  /// In en, this message translates to:
  /// **'{value} for this period'**
  String inflationForPeriod(String value);

  /// No description provided for @verdictKeptTitle.
  ///
  /// In en, this message translates to:
  /// **'KEPT purchasing power, after set-aside'**
  String get verdictKeptTitle;

  /// No description provided for @verdictLostTitle.
  ///
  /// In en, this message translates to:
  /// **'LOST purchasing power, after set-aside'**
  String get verdictLostTitle;

  /// No description provided for @neededEnd.
  ///
  /// In en, this message translates to:
  /// **'Needed: end value {value} (return {pct})'**
  String neededEnd(String value, String pct);

  /// No description provided for @lostGrams.
  ///
  /// In en, this message translates to:
  /// **'Lost {value} after set-aside'**
  String lostGrams(String value);

  /// No description provided for @keptGrams.
  ///
  /// In en, this message translates to:
  /// **'Kept {value} after set-aside'**
  String keptGrams(String value);

  /// No description provided for @yardstick.
  ///
  /// In en, this message translates to:
  /// **'Gold is a yardstick, not a price index. In gold, the gram is the measure: there is no inflation step.'**
  String get yardstick;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @notAvailableWhy.
  ///
  /// In en, this message translates to:
  /// **'The average money invested in this period is zero or less.'**
  String get notAvailableWhy;

  /// No description provided for @markersStale.
  ///
  /// In en, this message translates to:
  /// **'{count} items not updated this period'**
  String markersStale(String count);

  /// No description provided for @markerStaleRate.
  ///
  /// In en, this message translates to:
  /// **'rate not updated in this period'**
  String get markerStaleRate;

  /// No description provided for @markerNotUpdated.
  ///
  /// In en, this message translates to:
  /// **'value not updated'**
  String get markerNotUpdated;

  /// No description provided for @itemsHeading.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsHeading;

  /// No description provided for @excludedHeading.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get excludedHeading;

  /// No description provided for @excludedLine.
  ///
  /// In en, this message translates to:
  /// **'{name} — {from}→{to} rate missing'**
  String excludedLine(String name, String from, String to);

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} of {total} items'**
  String basedOn(String count, String total);

  /// No description provided for @toPurifyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Interest to purify: {amount} — not in return, not netted against the set-aside'**
  String toPurifyPeriod(String amount);

  /// No description provided for @noZakatSwitch.
  ///
  /// In en, this message translates to:
  /// **'No zakat due for {year}'**
  String noZakatSwitch(String year);

  /// No description provided for @noZakatHelp.
  ///
  /// In en, this message translates to:
  /// **'Decide using all your zakatable wealth, not only this list.'**
  String get noZakatHelp;

  /// No description provided for @noZakatEffect.
  ///
  /// In en, this message translates to:
  /// **'0 — no zakat due this year'**
  String get noZakatEffect;

  /// No description provided for @nisabGold.
  ///
  /// In en, this message translates to:
  /// **'Nisab: 85 g gold = {amount}'**
  String nisabGold(String amount);

  /// No description provided for @nisabSilver.
  ///
  /// In en, this message translates to:
  /// **'Nisab: 595 g silver = {amount}'**
  String nisabSilver(String amount);

  /// No description provided for @nisabNoGold.
  ///
  /// In en, this message translates to:
  /// **'Add a gold rate to see the nisab'**
  String get nisabNoGold;

  /// No description provided for @nisabNoSilver.
  ///
  /// In en, this message translates to:
  /// **'Add a silver rate to see the nisab'**
  String get nisabNoSilver;

  /// No description provided for @zakatableTotal.
  ///
  /// In en, this message translates to:
  /// **'Zakatable total in this list: {amount}'**
  String zakatableTotal(String amount);

  /// No description provided for @otherPeriods.
  ///
  /// In en, this message translates to:
  /// **'Other periods'**
  String get otherPeriods;

  /// No description provided for @measureReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get measureReturn;

  /// No description provided for @measureAfter.
  ///
  /// In en, this message translates to:
  /// **'After set-aside'**
  String get measureAfter;

  /// No description provided for @measureReal.
  ///
  /// In en, this message translates to:
  /// **'Real after set-aside'**
  String get measureReal;

  /// No description provided for @assumptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assumptions'**
  String get assumptionsTitle;

  /// No description provided for @baseAndHome.
  ///
  /// In en, this message translates to:
  /// **'Base and home'**
  String get baseAndHome;

  /// No description provided for @baseLine.
  ///
  /// In en, this message translates to:
  /// **'Base currency: {currency}'**
  String baseLine(String currency);

  /// No description provided for @baseChangeWarning.
  ///
  /// In en, this message translates to:
  /// **'All totals and months recalculate.'**
  String get baseChangeWarning;

  /// No description provided for @ratesHeading.
  ///
  /// In en, this message translates to:
  /// **'Rates'**
  String get ratesHeading;

  /// No description provided for @rateLine.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = {rate} {to} · as of {date}'**
  String rateLine(String from, String rate, String to, String date);

  /// No description provided for @rateTagTyped.
  ///
  /// In en, this message translates to:
  /// **'Typed by you'**
  String get rateTagTyped;

  /// No description provided for @rateTagFetched.
  ///
  /// In en, this message translates to:
  /// **'{source}'**
  String rateTagFetched(String source);

  /// No description provided for @rateTypedUsed.
  ///
  /// In en, this message translates to:
  /// **'Your rate is used (source gave {rate})'**
  String rateTypedUsed(String rate);

  /// No description provided for @rateStaleMarker.
  ///
  /// In en, this message translates to:
  /// **'not updated this month'**
  String get rateStaleMarker;

  /// No description provided for @rateMissingMarker.
  ///
  /// In en, this message translates to:
  /// **'missing'**
  String get rateMissingMarker;

  /// No description provided for @noRatesYet.
  ///
  /// In en, this message translates to:
  /// **'Rates appear here when an investment needs one.'**
  String get noRatesYet;

  /// No description provided for @rateHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Rates {from}→{to}'**
  String rateHistoryTitle(String from, String to);

  /// No description provided for @addRate.
  ///
  /// In en, this message translates to:
  /// **'Add rate'**
  String get addRate;

  /// No description provided for @editRate.
  ///
  /// In en, this message translates to:
  /// **'Edit rate'**
  String get editRate;

  /// No description provided for @swapDirection.
  ///
  /// In en, this message translates to:
  /// **'Swap direction'**
  String get swapDirection;

  /// No description provided for @inverseLine.
  ///
  /// In en, this message translates to:
  /// **'1 {to} = {rate} {from}'**
  String inverseLine(String to, String rate, String from);

  /// No description provided for @rateFetchedNote.
  ///
  /// In en, this message translates to:
  /// **'Fetched rates are overridden by typing a rate for the same date.'**
  String get rateFetchedNote;

  /// No description provided for @inflationHeading.
  ///
  /// In en, this message translates to:
  /// **'Inflation'**
  String get inflationHeading;

  /// No description provided for @inflationRow.
  ///
  /// In en, this message translates to:
  /// **'{country}'**
  String inflationRow(String country);

  /// No description provided for @inflationYearLine.
  ///
  /// In en, this message translates to:
  /// **'{year}: {rate} · {tag}'**
  String inflationYearLine(String year, String rate, String tag);

  /// No description provided for @tagShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get tagShipped;

  /// No description provided for @tagYours.
  ///
  /// In en, this message translates to:
  /// **'Yours'**
  String get tagYours;

  /// No description provided for @tagAssumed.
  ///
  /// In en, this message translates to:
  /// **'Assumed from {year}'**
  String tagAssumed(String year);

  /// No description provided for @resetToShipped.
  ///
  /// In en, this message translates to:
  /// **'Reset to shipped'**
  String get resetToShipped;

  /// No description provided for @overrideTitle.
  ///
  /// In en, this message translates to:
  /// **'{country} {year}'**
  String overrideTitle(String country, String year);

  /// No description provided for @inflationPercentField.
  ///
  /// In en, this message translates to:
  /// **'Inflation (%)'**
  String get inflationPercentField;

  /// No description provided for @errInflation.
  ///
  /// In en, this message translates to:
  /// **'Enter a rate from -50 to 1000 %'**
  String get errInflation;

  /// No description provided for @emptySeries.
  ///
  /// In en, this message translates to:
  /// **'No data for {country}. Add a year to see real figures for items using it.'**
  String emptySeries(String country);

  /// No description provided for @zakatHeading.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get zakatHeading;

  /// No description provided for @jewelleryNotAsked.
  ///
  /// In en, this message translates to:
  /// **'Not asked yet'**
  String get jewelleryNotAsked;

  /// No description provided for @noZakatByYear.
  ///
  /// In en, this message translates to:
  /// **'No zakat due by year'**
  String get noZakatByYear;

  /// No description provided for @perItemRewritten.
  ///
  /// In en, this message translates to:
  /// **'Items that followed the old method keep it now.'**
  String get perItemRewritten;

  /// No description provided for @rateAddedToast.
  ///
  /// In en, this message translates to:
  /// **'Rate saved'**
  String get rateAddedToast;

  /// No description provided for @errRateFuture.
  ///
  /// In en, this message translates to:
  /// **'The rate date cannot be in the future'**
  String get errRateFuture;
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
