import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

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
    Locale('en'),
    Locale('ky'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Jolu Trip'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @travelWithGuide.
  ///
  /// In en, this message translates to:
  /// **'Travel with guide'**
  String get travelWithGuide;

  /// No description provided for @selfGuided.
  ///
  /// In en, this message translates to:
  /// **'Self-guided'**
  String get selfGuided;

  /// No description provided for @aboutPlace.
  ///
  /// In en, this message translates to:
  /// **'About place'**
  String get aboutPlace;

  /// No description provided for @whatToTake.
  ///
  /// In en, this message translates to:
  /// **'What to take'**
  String get whatToTake;

  /// No description provided for @availableGuides.
  ///
  /// In en, this message translates to:
  /// **'Available guides'**
  String get availableGuides;

  /// No description provided for @howToGet.
  ///
  /// In en, this message translates to:
  /// **'How to get there'**
  String get howToGet;

  /// No description provided for @roadFeatures.
  ///
  /// In en, this message translates to:
  /// **'Road features'**
  String get roadFeatures;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @myRoutes.
  ///
  /// In en, this message translates to:
  /// **'My routes'**
  String get myRoutes;

  /// No description provided for @createYourPath.
  ///
  /// In en, this message translates to:
  /// **'Create your own path'**
  String get createYourPath;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1'**
  String get version;

  /// No description provided for @savedLocations.
  ///
  /// In en, this message translates to:
  /// **'Saved locations'**
  String get savedLocations;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get loadingError;

  /// No description provided for @traveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get traveler;

  /// No description provided for @personalAccount.
  ///
  /// In en, this message translates to:
  /// **'Personal account'**
  String get personalAccount;

  /// No description provided for @loginToPlanning.
  ///
  /// In en, this message translates to:
  /// **'Log in to plan routes and save the best locations in Kyrgyzstan'**
  String get loginToPlanning;

  /// No description provided for @createNewProfile.
  ///
  /// In en, this message translates to:
  /// **'Create new profile'**
  String get createNewProfile;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authenticationRequired;

  /// No description provided for @loginToViewFavorites.
  ///
  /// In en, this message translates to:
  /// **'To view favorites, you need to sign in'**
  String get loginToViewFavorites;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noAccessFirestore.
  ///
  /// In en, this message translates to:
  /// **'No access to Firestore. Check access rules.'**
  String get noAccessFirestore;

  /// No description provided for @loadingErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Loading error:'**
  String get loadingErrorPrefix;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @travelTime.
  ///
  /// In en, this message translates to:
  /// **'Travel time'**
  String get travelTime;

  /// No description provided for @routeDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Route difficulty'**
  String get routeDifficulty;

  /// No description provided for @carType.
  ///
  /// In en, this message translates to:
  /// **'Car type'**
  String get carType;

  /// No description provided for @mobileSignal.
  ///
  /// In en, this message translates to:
  /// **'Mobile signal'**
  String get mobileSignal;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @failedToLoadVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load video'**
  String get failedToLoadVideo;

  /// No description provided for @uploadProgress.
  ///
  /// In en, this message translates to:
  /// **'Upload progress'**
  String get uploadProgress;

  /// No description provided for @chooseMap.
  ///
  /// In en, this message translates to:
  /// **'Choose map'**
  String get chooseMap;

  /// No description provided for @buildRoute.
  ///
  /// In en, this message translates to:
  /// **'Build route'**
  String get buildRoute;

  /// No description provided for @failedToLoadGuideVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load guide video'**
  String get failedToLoadGuideVideo;

  /// No description provided for @shareImpression.
  ///
  /// In en, this message translates to:
  /// **'Share an impression'**
  String get shareImpression;

  /// No description provided for @uploadBeforeAfter.
  ///
  /// In en, this message translates to:
  /// **'Upload before and after'**
  String get uploadBeforeAfter;

  /// No description provided for @share10Locations.
  ///
  /// In en, this message translates to:
  /// **'Share 10 locations'**
  String get share10Locations;

  /// No description provided for @friendClickedLink.
  ///
  /// In en, this message translates to:
  /// **'Friend clicked the link'**
  String get friendClickedLink;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection'**
  String get networkError;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Account has been disabled'**
  String get accountDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later'**
  String get tooManyRequests;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'You have no favorites yet'**
  String get noFavorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @tapHeartToSave.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon in videos to save them'**
  String get tapHeartToSave;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search places'**
  String get searchPlaces;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @withCompany.
  ///
  /// In en, this message translates to:
  /// **'With company'**
  String get withCompany;

  /// No description provided for @withGuide.
  ///
  /// In en, this message translates to:
  /// **'With guide'**
  String get withGuide;

  /// No description provided for @noGuidesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No guides available'**
  String get noGuidesAvailable;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get selectOption;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownError;

  /// No description provided for @noVideos.
  ///
  /// In en, this message translates to:
  /// **'No videos available'**
  String get noVideos;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get fileNotFound;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connectionTimeout;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @invalidData.
  ///
  /// In en, this message translates to:
  /// **'Invalid data format'**
  String get invalidData;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get savedSuccessfully;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deletedSuccessfully;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share location'**
  String get shareLocation;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @profileNav.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileNav;

  /// No description provided for @noAvailablePlaces.
  ///
  /// In en, this message translates to:
  /// **'No available places'**
  String get noAvailablePlaces;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get nothingFound;

  /// No description provided for @tryChangingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try changing search parameters'**
  String get tryChangingSearch;

  /// No description provided for @youSearched.
  ///
  /// In en, this message translates to:
  /// **'You searched:'**
  String get youSearched;

  /// No description provided for @videoNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Video for this place has not been added yet'**
  String get videoNotAdded;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// No description provided for @mountains.
  ///
  /// In en, this message translates to:
  /// **'Mountains'**
  String get mountains;

  /// No description provided for @lake.
  ///
  /// In en, this message translates to:
  /// **'Lake'**
  String get lake;

  /// No description provided for @historical.
  ///
  /// In en, this message translates to:
  /// **'Historical'**
  String get historical;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @failedToLoadInfo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load information'**
  String get failedToLoadInfo;

  /// No description provided for @howWillWeGo.
  ///
  /// In en, this message translates to:
  /// **'How will we go?'**
  String get howWillWeGo;

  /// No description provided for @temporarilyNoGuidesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Temporarily no guides available'**
  String get temporarilyNoGuidesAvailable;

  /// No description provided for @bookingTour.
  ///
  /// In en, this message translates to:
  /// **'Book a tour'**
  String get bookingTour;

  /// No description provided for @bookingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmation'**
  String get bookingConfirmation;

  /// No description provided for @tourDate.
  ///
  /// In en, this message translates to:
  /// **'Tour date'**
  String get tourDate;

  /// No description provided for @fullPrice.
  ///
  /// In en, this message translates to:
  /// **'Full price'**
  String get fullPrice;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @remainingBalanceAtVenue.
  ///
  /// In en, this message translates to:
  /// **'Remaining balance to be paid to guide at venue'**
  String get remainingBalanceAtVenue;

  /// No description provided for @payDeposit.
  ///
  /// In en, this message translates to:
  /// **'Pay deposit'**
  String get payDeposit;

  /// No description provided for @depositPaid.
  ///
  /// In en, this message translates to:
  /// **'Deposit paid!'**
  String get depositPaid;

  /// No description provided for @tourSuccessfullyBooked.
  ///
  /// In en, this message translates to:
  /// **'Your tour has been successfully booked'**
  String get tourSuccessfullyBooked;

  /// No description provided for @paymentOfDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit payment'**
  String get paymentOfDeposit;

  /// No description provided for @depositAmount.
  ///
  /// In en, this message translates to:
  /// **'Deposit amount'**
  String get depositAmount;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// No description provided for @paymentViaQR.
  ///
  /// In en, this message translates to:
  /// **'Payment via QR'**
  String get paymentViaQR;

  /// No description provided for @scanQRInMBank.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code in MBank app'**
  String get scanQRInMBank;

  /// No description provided for @paymentViaMBank.
  ///
  /// In en, this message translates to:
  /// **'Payment via MBank'**
  String get paymentViaMBank;

  /// No description provided for @switchToMBank.
  ///
  /// In en, this message translates to:
  /// **'Switch to MBank app'**
  String get switchToMBank;

  /// No description provided for @paymentViaCard.
  ///
  /// In en, this message translates to:
  /// **'Payment by card'**
  String get paymentViaCard;

  /// No description provided for @visaMastercardElkart.
  ///
  /// In en, this message translates to:
  /// **'Visa, MasterCard, ELKART'**
  String get visaMastercardElkart;

  /// No description provided for @qrCodeForPayment.
  ///
  /// In en, this message translates to:
  /// **'QR code for payment'**
  String get qrCodeForPayment;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to pay'**
  String get paymentAmount;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @mmyy.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get mmyy;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @processPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get processPayment;

  /// No description provided for @paymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmation'**
  String get paymentConfirmation;

  /// No description provided for @didYouPayDeposit.
  ///
  /// In en, this message translates to:
  /// **'Did you pay the deposit of'**
  String get didYouPayDeposit;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes, paid'**
  String get yes;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYet;

  /// No description provided for @guideContacts.
  ///
  /// In en, this message translates to:
  /// **'Guide contacts'**
  String get guideContacts;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @discussDetails.
  ///
  /// In en, this message translates to:
  /// **'Discuss food, transfer, and tour details with the guide'**
  String get discussDetails;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get great;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @bookDate.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get bookDate;

  /// No description provided for @dateAlreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'This date is already booked'**
  String get dateAlreadyBooked;

  /// No description provided for @failedToOpenPhone.
  ///
  /// In en, this message translates to:
  /// **'Failed to open phone'**
  String get failedToOpenPhone;

  /// No description provided for @failedToOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Failed to open WhatsApp'**
  String get failedToOpenWhatsApp;

  /// No description provided for @failedToOpenMBank.
  ///
  /// In en, this message translates to:
  /// **'Failed to open MBank'**
  String get failedToOpenMBank;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @badgesReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get badgesReceived;

  /// No description provided for @badgesInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get badgesInProgress;

  /// No description provided for @yourDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Your Discounts'**
  String get yourDiscounts;

  /// No description provided for @showQRToPartners.
  ///
  /// In en, this message translates to:
  /// **'Show QR code to partners'**
  String get showQRToPartners;

  /// No description provided for @yourTravels.
  ///
  /// In en, this message translates to:
  /// **'Your Travels'**
  String get yourTravels;

  /// No description provided for @gasStations.
  ///
  /// In en, this message translates to:
  /// **'Gas Stations'**
  String get gasStations;

  /// No description provided for @cafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get cafe;

  /// No description provided for @shops.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get shops;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kilometers;

  /// No description provided for @routes.
  ///
  /// In en, this message translates to:
  /// **'routes'**
  String get routes;

  /// No description provided for @lakes.
  ///
  /// In en, this message translates to:
  /// **'lakes'**
  String get lakes;

  /// No description provided for @nightsInYurts.
  ///
  /// In en, this message translates to:
  /// **'nights in yurts'**
  String get nightsInYurts;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// No description provided for @requirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
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
      <String>['en', 'ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
