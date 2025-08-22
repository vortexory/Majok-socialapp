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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @welcomeTopTitle.
  ///
  /// In en, this message translates to:
  /// **'Future Spouse Finder'**
  String get welcomeTopTitle;

  /// No description provided for @welcomeMainTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Majok Spouse Generator!'**
  String get welcomeMainTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to start your fun journey to discover your ideal partner!'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeStartButton.
  ///
  /// In en, this message translates to:
  /// **'Tap to Start'**
  String get welcomeStartButton;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @onboardingAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you!'**
  String get onboardingAppBarTitle;

  /// No description provided for @nameQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get nameQuestion;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get nameHint;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @adPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get adPlaceholder;

  /// No description provided for @ageQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your age?'**
  String get ageQuestion;

  /// No description provided for @heightQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter your height. We\'ll find your perfect match based on all your unique traits!'**
  String get heightQuestion;

  /// No description provided for @heightCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Height'**
  String get heightCardTitle;

  /// No description provided for @heightUnitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get heightUnitCm;

  /// No description provided for @heightUnitInches.
  ///
  /// In en, this message translates to:
  /// **'inches'**
  String get heightUnitInches;

  /// No description provided for @adPlaceholderWithText.
  ///
  /// In en, this message translates to:
  /// **'Advertisement: Discover Your Next Favorite App!'**
  String get adPlaceholderWithText;

  /// No description provided for @weightQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'How much do you weigh?'**
  String get weightQuestionTitle;

  /// No description provided for @weightQuestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be honest, it helps us find your perfect match!'**
  String get weightQuestionSubtitle;

  /// No description provided for @weightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weightUnitKg;

  /// No description provided for @weightUnitLbs.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get weightUnitLbs;

  /// No description provided for @hobbiesQuestion.
  ///
  /// In en, this message translates to:
  /// **'What makes your heart sing? Pick your favorite hobbies!'**
  String get hobbiesQuestion;

  /// No description provided for @hobbyMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get hobbyMusic;

  /// No description provided for @hobbyReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get hobbyReading;

  /// No description provided for @hobbyGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get hobbyGaming;

  /// No description provided for @hobbyFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get hobbyFitness;

  /// No description provided for @hobbyArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get hobbyArt;

  /// No description provided for @hobbyCooking.
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get hobbyCooking;

  /// No description provided for @hobbyPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get hobbyPhotography;

  /// No description provided for @hobbyTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get hobbyTravel;

  /// No description provided for @hobbyCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get hobbyCoffee;

  /// No description provided for @hobbyVolunteering.
  ///
  /// In en, this message translates to:
  /// **'Volunteering'**
  String get hobbyVolunteering;

  /// No description provided for @hobbyWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get hobbyWriting;

  /// No description provided for @hobbyCrafts.
  ///
  /// In en, this message translates to:
  /// **'Crafts'**
  String get hobbyCrafts;

  /// No description provided for @admobBannerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'AdMob Banner Ad Placeholder'**
  String get admobBannerPlaceholder;

  /// No description provided for @pathQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s Your Path?'**
  String get pathQuestionTitle;

  /// No description provided for @pathQuestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share a bit about your education or current job.'**
  String get pathQuestionSubtitle;

  /// No description provided for @pathCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Education & Job'**
  String get pathCardTitle;

  /// No description provided for @pathHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Software Engineer, Aspiring Chef, Student'**
  String get pathHint;

  /// No description provided for @pathCharacterCounter.
  ///
  /// In en, this message translates to:
  /// **'{count}/200 characters'**
  String pathCharacterCounter(Object count);

  /// No description provided for @genderQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Your Gender'**
  String get genderQuestionTitle;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get genderNonBinary;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer Not to Say'**
  String get genderPreferNotToSay;

  /// No description provided for @resultAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Match!'**
  String get resultAppBarTitle;

  /// No description provided for @resultLoves.
  ///
  /// In en, this message translates to:
  /// **'Loves'**
  String get resultLoves;

  /// No description provided for @resultHates.
  ///
  /// In en, this message translates to:
  /// **'Hates'**
  String get resultHates;

  /// No description provided for @resultMatchChip.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Match!'**
  String resultMatchChip(Object percent);

  /// No description provided for @resultTryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get resultTryAgainButton;

  /// No description provided for @resultShareButton.
  ///
  /// In en, this message translates to:
  /// **'Share Your Match!'**
  String get resultShareButton;

  /// No description provided for @adResultPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Advertisement: Discover Premium Match Insights!'**
  String get adResultPlaceholder;

  /// No description provided for @hubTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Future Life'**
  String get hubTitle;

  /// No description provided for @hubProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} of 5 Stations Complete.'**
  String hubProgress(Object count);

  /// No description provided for @station1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover Partner\'s Traits'**
  String get station1Title;

  /// No description provided for @station2Title.
  ///
  /// In en, this message translates to:
  /// **'First Meeting & Wedding'**
  String get station2Title;

  /// No description provided for @station3Title.
  ///
  /// In en, this message translates to:
  /// **'First Child Reveal'**
  String get station3Title;

  /// No description provided for @station4Title.
  ///
  /// In en, this message translates to:
  /// **'Chat with Soulmate'**
  String get station4Title;

  /// No description provided for @station5Title.
  ///
  /// In en, this message translates to:
  /// **'Soulmate Reveal'**
  String get station5Title;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Restart Journey'**
  String get retryButton;

  /// No description provided for @profileAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileAge;

  /// No description provided for @profileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileHeight;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileHobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get profileHobbies;

  /// No description provided for @profileYears.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get profileYears;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @station1ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Destiny Seeker'**
  String get station1ScreenTitle;

  /// No description provided for @chooseYourDestiny.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Destiny'**
  String get chooseYourDestiny;

  /// No description provided for @destinyCard1Title.
  ///
  /// In en, this message translates to:
  /// **'Mystic Sage'**
  String get destinyCard1Title;

  /// No description provided for @destinyCard1Desc.
  ///
  /// In en, this message translates to:
  /// **'Grants profound wisdom'**
  String get destinyCard1Desc;

  /// No description provided for @destinyCard2Title.
  ///
  /// In en, this message translates to:
  /// **'Swift Voyager'**
  String get destinyCard2Title;

  /// No description provided for @destinyCard2Desc.
  ///
  /// In en, this message translates to:
  /// **'Bestows unparalleled speed'**
  String get destinyCard2Desc;

  /// No description provided for @destinyCard3Title.
  ///
  /// In en, this message translates to:
  /// **'Iron Guardian'**
  String get destinyCard3Title;

  /// No description provided for @destinyCard3Desc.
  ///
  /// In en, this message translates to:
  /// **'Confers unyielding strength'**
  String get destinyCard3Desc;

  /// No description provided for @learnMoreButton.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMoreButton;

  /// No description provided for @puzzleTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick! Catch the Hearts!'**
  String get puzzleTitle;

  /// No description provided for @secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'SECONDS'**
  String get secondsLabel;

  /// No description provided for @station1ResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Partner\'s Traits'**
  String get station1ResultTitle;

  /// No description provided for @traitHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get traitHeight;

  /// No description provided for @traitWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get traitWeight;

  /// No description provided for @traitEyeColor.
  ///
  /// In en, this message translates to:
  /// **'Eye Color'**
  String get traitEyeColor;

  /// No description provided for @traitHobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get traitHobbies;

  /// No description provided for @traitFunnyQuirks.
  ///
  /// In en, this message translates to:
  /// **'Funny Quirks'**
  String get traitFunnyQuirks;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share Result'**
  String get shareButton;

  /// No description provided for @station2AppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Preferences'**
  String get station2AppBarTitle;

  /// No description provided for @zodiacQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your Zodiac Sign?'**
  String get zodiacQuestion;

  /// No description provided for @zodiacAries.
  ///
  /// In en, this message translates to:
  /// **'Aries'**
  String get zodiacAries;

  /// No description provided for @zodiacTaurus.
  ///
  /// In en, this message translates to:
  /// **'Taurus'**
  String get zodiacTaurus;

  /// No description provided for @zodiacGemini.
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get zodiacGemini;

  /// No description provided for @zodiacCancer.
  ///
  /// In en, this message translates to:
  /// **'Cancer'**
  String get zodiacCancer;

  /// No description provided for @zodiacLeo.
  ///
  /// In en, this message translates to:
  /// **'Leo'**
  String get zodiacLeo;

  /// No description provided for @zodiacVirgo.
  ///
  /// In en, this message translates to:
  /// **'Virgo'**
  String get zodiacVirgo;

  /// No description provided for @zodiacLibra.
  ///
  /// In en, this message translates to:
  /// **'Libra'**
  String get zodiacLibra;

  /// No description provided for @zodiacScorpio.
  ///
  /// In en, this message translates to:
  /// **'Scorpio'**
  String get zodiacScorpio;

  /// No description provided for @zodiacSagittarius.
  ///
  /// In en, this message translates to:
  /// **'Sagittarius'**
  String get zodiacSagittarius;

  /// No description provided for @zodiacCapricorn.
  ///
  /// In en, this message translates to:
  /// **'Capricorn'**
  String get zodiacCapricorn;

  /// No description provided for @zodiacAquarius.
  ///
  /// In en, this message translates to:
  /// **'Aquarius'**
  String get zodiacAquarius;

  /// No description provided for @zodiacPisces.
  ///
  /// In en, this message translates to:
  /// **'Pisces'**
  String get zodiacPisces;

  /// No description provided for @nextStepButton.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStepButton;

  /// No description provided for @skipForNowButton.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNowButton;

  /// No description provided for @station2HeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s personalize your journey!'**
  String get station2HeroTitle;

  /// No description provided for @station2HeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about your favorite things to explore and dream about.'**
  String get station2HeroSubtitle;

  /// No description provided for @destinationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where\'s your dream destination?'**
  String get destinationQuestion;

  /// No description provided for @destinationHint.
  ///
  /// In en, this message translates to:
  /// **'Paris'**
  String get destinationHint;

  /// No description provided for @spiritAnimalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Choose your spirit animal'**
  String get spiritAnimalQuestion;

  /// No description provided for @dreamRideQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your dream ride?'**
  String get dreamRideQuestion;

  /// No description provided for @animalBrain.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get animalBrain;

  /// No description provided for @animalCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get animalCat;

  /// No description provided for @animalDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get animalDog;

  /// No description provided for @animalGlobe.
  ///
  /// In en, this message translates to:
  /// **'Globe'**
  String get animalGlobe;

  /// No description provided for @animalXMark.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get animalXMark;

  /// No description provided for @animalRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get animalRabbit;

  /// No description provided for @rideAirBalloon.
  ///
  /// In en, this message translates to:
  /// **'Air Balloon'**
  String get rideAirBalloon;

  /// No description provided for @rideRaceCar.
  ///
  /// In en, this message translates to:
  /// **'Race Car'**
  String get rideRaceCar;

  /// No description provided for @rideMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get rideMotorcycle;

  /// No description provided for @rideBicycle.
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get rideBicycle;

  /// No description provided for @rideBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get rideBus;

  /// No description provided for @rideTruckVan.
  ///
  /// In en, this message translates to:
  /// **'Truck Van'**
  String get rideTruckVan;

  /// No description provided for @station2ResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Grand Romance'**
  String get station2ResultTitle;

  /// No description provided for @storyHeadingMet.
  ///
  /// In en, this message translates to:
  /// **'How You Met'**
  String get storyHeadingMet;

  /// No description provided for @storyHeadingProposal.
  ///
  /// In en, this message translates to:
  /// **'The Proposal'**
  String get storyHeadingProposal;

  /// No description provided for @storyHeadingWedding.
  ///
  /// In en, this message translates to:
  /// **'The Wedding'**
  String get storyHeadingWedding;

  /// No description provided for @shareAsImageButton.
  ///
  /// In en, this message translates to:
  /// **'Share Story'**
  String get shareAsImageButton;

  /// No description provided for @station3AppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Little Steps of Joy'**
  String get station3AppBarTitle;

  /// No description provided for @station3ChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to Fill Baby\'s Bottle!'**
  String get station3ChallengeTitle;

  /// No description provided for @station3ChallengeButton.
  ///
  /// In en, this message translates to:
  /// **'Tap here'**
  String get station3ChallengeButton;

  /// No description provided for @station3ProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Filled'**
  String station3ProgressLabel(Object percent);

  /// No description provided for @station3ResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Little Blessing'**
  String get station3ResultTitle;

  /// No description provided for @babyLoves.
  ///
  /// In en, this message translates to:
  /// **'Loves:'**
  String get babyLoves;

  /// No description provided for @babyHates.
  ///
  /// In en, this message translates to:
  /// **'Hates:'**
  String get babyHates;

  /// No description provided for @babyLove1.
  ///
  /// In en, this message translates to:
  /// **'Warm cuddles from Mama and Papa'**
  String get babyLove1;

  /// No description provided for @babyLove2.
  ///
  /// In en, this message translates to:
  /// **'Chasing the family dog, \"Sparky\"'**
  String get babyLove2;

  /// No description provided for @babyLove3.
  ///
  /// In en, this message translates to:
  /// **'The sound of jingly toys'**
  String get babyLove3;

  /// No description provided for @babyLove4.
  ///
  /// In en, this message translates to:
  /// **'Morning sunshine on her face'**
  String get babyLove4;

  /// No description provided for @babyHate1.
  ///
  /// In en, this message translates to:
  /// **'Cold wet wipes in the middle of the night'**
  String get babyHate1;

  /// No description provided for @babyHate2.
  ///
  /// In en, this message translates to:
  /// **'When her pacifier falls out'**
  String get babyHate2;

  /// No description provided for @babyHate3.
  ///
  /// In en, this message translates to:
  /// **'That little piece of broccoli Mama tries to sneak in'**
  String get babyHate3;

  /// No description provided for @babyHate4.
  ///
  /// In en, this message translates to:
  /// **'Being told to nap when she wants to play'**
  String get babyHate4;

  /// No description provided for @shareAnnouncementButton.
  ///
  /// In en, this message translates to:
  /// **'Share Announcement'**
  String get shareAnnouncementButton;

  /// No description provided for @station4AppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell Us About You!'**
  String get station4AppBarTitle;

  /// No description provided for @celebScoopTitle.
  ///
  /// In en, this message translates to:
  /// **'Celebrity Scoop!'**
  String get celebScoopTitle;

  /// No description provided for @celebScoopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who lights up your world with their talent?'**
  String get celebScoopSubtitle;

  /// No description provided for @celebScoopHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Zendaya, Ryan Gosling'**
  String get celebScoopHint;

  /// No description provided for @colorVibesTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Vibes!'**
  String get colorVibesTitle;

  /// No description provided for @colorVibesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your happiest hue. Tap to select!'**
  String get colorVibesSubtitle;

  /// No description provided for @fruityFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fruity Favorites!'**
  String get fruityFavoritesTitle;

  /// No description provided for @fruityFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which one makes you smile the most?'**
  String get fruityFavoritesSubtitle;

  /// No description provided for @fruitApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get fruitApple;

  /// No description provided for @fruitBanana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get fruitBanana;

  /// No description provided for @fruitCitrus.
  ///
  /// In en, this message translates to:
  /// **'Citrus'**
  String get fruitCitrus;

  /// No description provided for @fruitGrape.
  ///
  /// In en, this message translates to:
  /// **'Grape'**
  String get fruitGrape;

  /// No description provided for @fruitCherry.
  ///
  /// In en, this message translates to:
  /// **'Cherry'**
  String get fruitCherry;

  /// No description provided for @fruitSunMoon.
  ///
  /// In en, this message translates to:
  /// **'SunMoon'**
  String get fruitSunMoon;

  /// No description provided for @fruitPear.
  ///
  /// In en, this message translates to:
  /// **'Pear'**
  String get fruitPear;

  /// No description provided for @movieMagicTitle.
  ///
  /// In en, this message translates to:
  /// **'Movie Magic!'**
  String get movieMagicTitle;

  /// No description provided for @movieMagicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What film always makes your day better?'**
  String get movieMagicSubtitle;

  /// No description provided for @movieMagicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Everything Everywhere All at Once'**
  String get movieMagicHint;

  /// No description provided for @savePreferencesButton.
  ///
  /// In en, this message translates to:
  /// **'Save My Preferences'**
  String get savePreferencesButton;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}, The {title}'**
  String chatTitle(Object name, Object title);

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Say something sweet...'**
  String get chatPlaceholder;

  /// No description provided for @typingIndicator.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typingIndicator;

  /// No description provided for @finalLovesCoffee.
  ///
  /// In en, this message translates to:
  /// **'Morning coffee rituals'**
  String get finalLovesCoffee;

  /// No description provided for @finalLovesReading.
  ///
  /// In en, this message translates to:
  /// **'Getting lost in good books'**
  String get finalLovesReading;

  /// No description provided for @finalLovesExploring.
  ///
  /// In en, this message translates to:
  /// **'Exploring hidden cafés'**
  String get finalLovesExploring;

  /// No description provided for @finalHatesFootball.
  ///
  /// In en, this message translates to:
  /// **'Loud football matches'**
  String get finalHatesFootball;

  /// No description provided for @finalHatesMornings.
  ///
  /// In en, this message translates to:
  /// **'Being rushed in mornings'**
  String get finalHatesMornings;

  /// No description provided for @finalHatesNoises.
  ///
  /// In en, this message translates to:
  /// **'Unnecessary loud noises'**
  String get finalHatesNoises;

  /// No description provided for @saveToGalleryButton.
  ///
  /// In en, this message translates to:
  /// **'Save to Gallery'**
  String get saveToGalleryButton;

  /// No description provided for @progressScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Story So Far'**
  String get progressScreenTitle;

  /// No description provided for @chapterLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'A new chapter awaits...'**
  String get chapterLockedTitle;

  /// No description provided for @chapterLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the previous station to unlock this memory.'**
  String get chapterLockedSubtitle;

  /// No description provided for @chapterNextTitle.
  ///
  /// In en, this message translates to:
  /// **'Next Chapter: {title}'**
  String chapterNextTitle(Object title);

  /// No description provided for @chapterNextButton.
  ///
  /// In en, this message translates to:
  /// **'Continue Your Story'**
  String get chapterNextButton;

  /// No description provided for @chapter1Title.
  ///
  /// In en, this message translates to:
  /// **'The Spark: First Traits'**
  String get chapter1Title;

  /// No description provided for @chapter2Title.
  ///
  /// In en, this message translates to:
  /// **'The Romance: How You Met'**
  String get chapter2Title;

  /// No description provided for @chapter3Title.
  ///
  /// In en, this message translates to:
  /// **'A Little Blessing Arrives'**
  String get chapter3Title;

  /// No description provided for @chapter4Title.
  ///
  /// In en, this message translates to:
  /// **'The First Conversation'**
  String get chapter4Title;

  /// No description provided for @chapter5Title.
  ///
  /// In en, this message translates to:
  /// **'The Soulmate Reveal'**
  String get chapter5Title;

  /// No description provided for @finalRevealTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Perfect Match! 💕'**
  String get finalRevealTitle;

  /// No description provided for @chatMsgUser1.
  ///
  /// In en, this message translates to:
  /// **'Wow, that was quite the journey! Did my soulmate really turn out to be a mischievous garden gnome? 😂'**
  String get chatMsgUser1;

  /// No description provided for @chatMsgSoulmate1.
  ///
  /// In en, this message translates to:
  /// **'Haha, it seems so! But don\'t worry, your garden will be safe with me. 😉'**
  String get chatMsgSoulmate1;

  /// No description provided for @chatMsgUser2.
  ///
  /// In en, this message translates to:
  /// **'Do you actually like gardening, or are you just here for the mischief?'**
  String get chatMsgUser2;

  /// No description provided for @chatMsgSoulmate2.
  ///
  /// In en, this message translates to:
  /// **'Oh, I love gardening! Mischief is just my way of keeping things interesting.'**
  String get chatMsgSoulmate2;

  /// No description provided for @chatMsgUser3.
  ///
  /// In en, this message translates to:
  /// **'What\'s your favorite plant then?'**
  String get chatMsgUser3;

  /// No description provided for @chatMsgSoulmate3.
  ///
  /// In en, this message translates to:
  /// **'Sunflowers! They\'re always looking on the bright side. 🌻 What about you?'**
  String get chatMsgSoulmate3;

  /// No description provided for @chatMsgUser4.
  ///
  /// In en, this message translates to:
  /// **'I\'m more of a cactus person... low maintenance, but full of surprises.'**
  String get chatMsgUser4;

  /// No description provided for @chatMsgSoulmate4.
  ///
  /// In en, this message translates to:
  /// **'Haha, a cactus! Sharp, mysterious, and always resilient. I like that.'**
  String get chatMsgSoulmate4;

  /// No description provided for @storyMetParagraph.
  ///
  /// In en, this message translates to:
  /// **'In the gentle hush of the old university library, amidst towering shelves of forgotten tales, your eyes first met. It was a sun-drenched afternoon, the dust motes dancing in the golden light, and as you both reached for the same worn copy of \'Wuthering Heights,\' a spark, as ancient as the stories around you, ignited. A shared smile, a whispered apology, and an hour later, you were lost not in the pages, but in each other\'s laughter over coffee, feeling as though fate had penned your introduction long ago.'**
  String get storyMetParagraph;

  /// No description provided for @storyProposalParagraph.
  ///
  /// In en, this message translates to:
  /// **'Years later, under a sky painted with twilight hues, beneath the very oak tree where you\'d carved your initials on your first date, the air shimmered with anticipation. He knelt, not with grand gestures, but with quiet conviction, a velvet box held delicately in his trembling hand. His voice, soft as a lover\'s murmur, spoke of forever, of shared dreams and enduring love. As you whispered \'Yes,\' the world seemed to hold its breath, sealing your promise under a canopy of nascent stars, a moment etched forever in the annals of your shared story.'**
  String get storyProposalParagraph;

  /// No description provided for @storyWeddingParagraph.
  ///
  /// In en, this message translates to:
  /// **'The day dawned, clear and bright, a tapestry woven with joy and anticipation. Amidst blooming roses and the joyful chorus of loved ones, you walked towards each other, vows exchanged like sacred verses. Every glance, every touch, spoke volumes of a love refined by time and deepened by affection. The celebration that followed was a joyous symphony of laughter, dancing, and heartfelt toasts, marking the beginning of your grandest chapter. As you shared your first dance, wrapped in an embrace that felt like coming home, you knew this was just the prologue to your beautiful, unending story.'**
  String get storyWeddingParagraph;

  /// No description provided for @station5PuzzleTitle.
  ///
  /// In en, this message translates to:
  /// **'Trace Your Destiny'**
  String get station5PuzzleTitle;

  /// No description provided for @homeButton.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get homeButton;

  /// No description provided for @station5PuzzleHint.
  ///
  /// In en, this message translates to:
  /// **'Touch the bright star and drag to the glowing one'**
  String get station5PuzzleHint;

  /// No description provided for @eyeColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get eyeColorBrown;

  /// No description provided for @eyeColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get eyeColorBlue;

  /// No description provided for @eyeColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get eyeColorGreen;

  /// No description provided for @eyeColorHazel.
  ///
  /// In en, this message translates to:
  /// **'Hazel'**
  String get eyeColorHazel;

  /// No description provided for @eyeColorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get eyeColorGray;

  /// No description provided for @eyeColorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get eyeColorAmber;

  /// No description provided for @eyeColorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get eyeColorBlack;

  /// No description provided for @eyeColorDarkBrown.
  ///
  /// In en, this message translates to:
  /// **'Dark Brown'**
  String get eyeColorDarkBrown;

  /// No description provided for @eyeColorLightBlue.
  ///
  /// In en, this message translates to:
  /// **'Light Blue'**
  String get eyeColorLightBlue;

  /// No description provided for @eyeColorDeepGreen.
  ///
  /// In en, this message translates to:
  /// **'Deep Green'**
  String get eyeColorDeepGreen;

  /// No description provided for @eyeColorGolden.
  ///
  /// In en, this message translates to:
  /// **'Golden'**
  String get eyeColorGolden;

  /// No description provided for @eyeColorViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get eyeColorViolet;

  /// No description provided for @eyeColorTurquoise.
  ///
  /// In en, this message translates to:
  /// **'Turquoise'**
  String get eyeColorTurquoise;

  /// No description provided for @eyeColorEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get eyeColorEmerald;

  /// No description provided for @eyeColorChestnut.
  ///
  /// In en, this message translates to:
  /// **'Chestnut'**
  String get eyeColorChestnut;

  /// No description provided for @hobbiesGamingArt.
  ///
  /// In en, this message translates to:
  /// **'Gaming & Art'**
  String get hobbiesGamingArt;

  /// No description provided for @hobbiesReadingMusic.
  ///
  /// In en, this message translates to:
  /// **'Reading & Music'**
  String get hobbiesReadingMusic;

  /// No description provided for @hobbiesCookingTravel.
  ///
  /// In en, this message translates to:
  /// **'Cooking & Travel'**
  String get hobbiesCookingTravel;

  /// No description provided for @hobbiesFitnessPhotography.
  ///
  /// In en, this message translates to:
  /// **'Fitness & Photography'**
  String get hobbiesFitnessPhotography;

  /// No description provided for @hobbiesWritingCoffee.
  ///
  /// In en, this message translates to:
  /// **'Writing & Coffee'**
  String get hobbiesWritingCoffee;

  /// No description provided for @hobbiesDancingMovies.
  ///
  /// In en, this message translates to:
  /// **'Dancing & Movies'**
  String get hobbiesDancingMovies;

  /// No description provided for @hobbiesGardeningBooks.
  ///
  /// In en, this message translates to:
  /// **'Gardening & Books'**
  String get hobbiesGardeningBooks;

  /// No description provided for @hobbiesPaintingHiking.
  ///
  /// In en, this message translates to:
  /// **'Painting & Hiking'**
  String get hobbiesPaintingHiking;

  /// No description provided for @hobbiesYogaMeditation.
  ///
  /// In en, this message translates to:
  /// **'Yoga & Meditation'**
  String get hobbiesYogaMeditation;

  /// No description provided for @hobbiesSingingGuitar.
  ///
  /// In en, this message translates to:
  /// **'Singing & Guitar'**
  String get hobbiesSingingGuitar;

  /// No description provided for @hobbiesRunningSwimming.
  ///
  /// In en, this message translates to:
  /// **'Running & Swimming'**
  String get hobbiesRunningSwimming;

  /// No description provided for @hobbiesBakingCrafts.
  ///
  /// In en, this message translates to:
  /// **'Baking & Crafts'**
  String get hobbiesBakingCrafts;

  /// No description provided for @hobbiesVolunteeringPets.
  ///
  /// In en, this message translates to:
  /// **'Volunteering & Pets'**
  String get hobbiesVolunteeringPets;

  /// No description provided for @hobbiesLanguagesTravel.
  ///
  /// In en, this message translates to:
  /// **'Languages & Travel'**
  String get hobbiesLanguagesTravel;

  /// No description provided for @hobbiesTechInnovation.
  ///
  /// In en, this message translates to:
  /// **'Tech & Innovation'**
  String get hobbiesTechInnovation;

  /// No description provided for @quirkHatesKetchup.
  ///
  /// In en, this message translates to:
  /// **'Hates putting ketchup on burgers'**
  String get quirkHatesKetchup;

  /// No description provided for @quirkKnowsPokemon.
  ///
  /// In en, this message translates to:
  /// **'Can name every single Pokémon'**
  String get quirkKnowsPokemon;

  /// No description provided for @quirkSingsInCar.
  ///
  /// In en, this message translates to:
  /// **'Sings loudly, but only in the car'**
  String get quirkSingsInCar;

  /// No description provided for @quirkCollectsRocks.
  ///
  /// In en, this message translates to:
  /// **'Collects interesting rocks from every trip'**
  String get quirkCollectsRocks;

  /// No description provided for @quirkTalksToPlants.
  ///
  /// In en, this message translates to:
  /// **'Talks to plants to help them grow'**
  String get quirkTalksToPlants;

  /// No description provided for @quirkDancesWhileCooking.
  ///
  /// In en, this message translates to:
  /// **'Always dances while cooking'**
  String get quirkDancesWhileCooking;

  /// No description provided for @quirkCountsSteps.
  ///
  /// In en, this message translates to:
  /// **'Counts steps when walking upstairs'**
  String get quirkCountsSteps;

  /// No description provided for @quirkNamesDevices.
  ///
  /// In en, this message translates to:
  /// **'Names all electronic devices'**
  String get quirkNamesDevices;

  /// No description provided for @quirkMemorizesLyrics.
  ///
  /// In en, this message translates to:
  /// **'Memorizes song lyrics after hearing once'**
  String get quirkMemorizesLyrics;

  /// No description provided for @quirkOrganizesByColor.
  ///
  /// In en, this message translates to:
  /// **'Organizes everything by color'**
  String get quirkOrganizesByColor;

  /// No description provided for @quirkMakesWeirdFaces.
  ///
  /// In en, this message translates to:
  /// **'Makes weird faces when concentrating'**
  String get quirkMakesWeirdFaces;

  /// No description provided for @quirkHumsUnconsciously.
  ///
  /// In en, this message translates to:
  /// **'Hums unconsciously when happy'**
  String get quirkHumsUnconsciously;

  /// No description provided for @quirkPerfectionist.
  ///
  /// In en, this message translates to:
  /// **'Perfectionist with morning coffee routine'**
  String get quirkPerfectionist;

  /// No description provided for @quirkNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night owl who\'s most creative at 2 AM'**
  String get quirkNightOwl;

  /// No description provided for @quirkLaughsAtOwnJokes.
  ///
  /// In en, this message translates to:
  /// **'Laughs at own jokes before telling them'**
  String get quirkLaughsAtOwnJokes;

  /// Section header for the 'How We Met' stories
  ///
  /// In en, this message translates to:
  /// **'How We Met'**
  String get howWeMet;

  /// Section header for the proposal stories
  ///
  /// In en, this message translates to:
  /// **'The Proposal'**
  String get theProposal;

  /// Section header for the wedding stories
  ///
  /// In en, this message translates to:
  /// **'The Wedding'**
  String get theWedding;

  /// No description provided for @storyMetCoffeeShop.
  ///
  /// In en, this message translates to:
  /// **'The scent of roasted coffee beans and freshly baked pastries hung thick in the air of the bustling coffee shop. You had both been eyeing the last, plump blueberry muffin, a perfect golden dome studded with juicy berries. As you both reached for it, your hands brushed, sending a small spark through the air. Instead of an awkward retreat or a polite concession, a shared smile bloomed between you. A silent agreement was made, and you decided to split the muffin. That simple act of sharing led to a conversation that flowed as smoothly as the lattes you both ordered. You talked about everything and nothing, from favorite books to dreams for the future, the noisy chatter of the café fading into a soft hum. The hours melted away, and it was only when the barista regretfully announced closing time that you realized you had been talking for the better part of the day, the two halves of a muffin having led to the discovery of your other half.'**
  String get storyMetCoffeeShop;

  /// No description provided for @storyMetBookstore.
  ///
  /// In en, this message translates to:
  /// **'In the quiet, hallowed aisles of a cozy, independent bookstore, surrounded by the comforting scent of old paper and ink, your eyes met over the philosophy section. It was a haven for dreamers and thinkers, and you were both reaching for the same worn, rare edition of a book about love and destiny, its title seeming to hold a special significance in that moment. It felt like a scene from a movie, a serendipitous alignment of hands and hearts. You both chuckled, a little embarrassed but undeniably intrigued. A conversation sparked, whispered at first so as not to disturb the other patrons, but soon you were lost in a world of your own, discussing the book\'s profound ideas about connection and fate. You moved from the philosophy aisle to the poetry section, sharing your favorite verses, and then to the cozy armchairs by the window, dissecting the very meaning of the words you had both so eagerly sought, realizing that the story you were most interested in was the one that was just beginning to unfold between you.'**
  String get storyMetBookstore;

  /// No description provided for @storyMetPark.
  ///
  /// In en, this message translates to:
  /// **'The early morning air was crisp and cool, the rising sun casting a golden glow over the dew-kissed grass of the park. You were in the zone, lost in the rhythm of your morning jog, when you saw them struggling, a frustrated tangle of headphone wires creating a comical yet relatable ordeal. You slowed your pace and offered to help, your fingers brushing as you carefully worked to unscramble the mess. The simple act of kindness led to a shared laugh, and the jog was momentarily forgotten. You found yourselves on a park bench, the newly untangled headphones now silent as you talked. The conversation flowed effortlessly, moving from your favorite running paths to your deepest aspirations as the sun climbed higher in the sky, its warmth mirroring the growing connection between you. What started as a tangled mess had unraveled into a beautiful and unexpected beginning.'**
  String get storyMetPark;

  /// No description provided for @storyMetLibrary.
  ///
  /// In en, this message translates to:
  /// **'The hushed quiet of the library had become a familiar comfort, a shared space where you both sought refuge and knowledge. For weeks, you had noticed each other, seated at the same large oak table, a silent understanding passing between you in the form of shy, fleeting glances. You knew their favorite reading spot, the way they would unconsciously chew on their pen when deep in thought, and the titles of the books that piled up beside them. The unspoken connection grew stronger with each passing day, a silent story being written in the margins of your study sessions. Finally, mustering all your courage, you decided to break the silence not with words, but with a note. You carefully tucked it into the pages of their favorite book, a classic novel you had seen them reread multiple times. The note was simple, just a few words, but it held the promise of a new chapter, one that would hopefully be read together.'**
  String get storyMetLibrary;

  /// No description provided for @storyMetGym.
  ///
  /// In en, this message translates to:
  /// **'The clanking of weights and the rhythmic hum of treadmills was the soundtrack to your budding connection. You were unofficial gym buddies, your workout schedules aligning so perfectly it seemed almost intentional. You would exchange nods of encouragement, share a knowing smile after a particularly grueling set, and even save machines for each other. The easy camaraderie was there, a comfortable foundation built on shared dedication and mutual respect. But beneath the surface of friendly competition and synchronized sweat sessions, a different kind of energy was building. One day, after a particularly intense workout, fueled by a surge of adrenaline and a \'now or never\' feeling, you finally broke the routine. Instead of the usual fist bump and parting ways, you asked them on a smoothie date. The surprised but happy \'yes\' was more rewarding than any personal best you had ever achieved.'**
  String get storyMetGym;

  /// No description provided for @storyMetAirport.
  ///
  /// In en, this message translates to:
  /// **'The sterile, impersonal atmosphere of the airport terminal was transformed by an unexpected twist of fate: a significantly delayed flight. What began as a shared sigh of frustration over the lack of charging ports quickly blossomed into something more. You offered to share your power bank, a small gesture of kindness in a sea of weary travelers. That simple act opened the door to a conversation that spanned continents and life experiences. With nothing but time on your hands, you shared stories of your travels, your families, your dreams, and your fears. The eight-hour delay, which could have been a tedious ordeal, became an intimate and unforgettable journey into each other\'s worlds. By the time the final boarding call was announced, you knew you had found a travel companion for life, someone with whom you wouldn\'t mind being stranded anywhere.'**
  String get storyMetAirport;

  /// No description provided for @storyMetConcert.
  ///
  /// In en, this message translates to:
  /// **'The energy in the concert hall was electric, a palpable buzz of anticipation for your favorite artist to take the stage. You found yourselves standing next to each other in the crowd, both singing along with an infectious enthusiasm. But it was when the artist launched into a deep cut, a rare and beloved B-side track that only the most dedicated fans would know, that something truly special happened. You both turned to each other, eyes wide with surprise and delight, as you sang every single word in perfect harmony. In that moment, amidst the roar of the crowd and the flashing lights, you felt an instant and profound connection. It was more than just shared musical taste; it was a shared passion, a shared understanding, a feeling of being truly seen and understood. The rest of the concert was a blur of dancing, singing, and stolen glances, the music providing the perfect soundtrack to the beginning of your love story.'**
  String get storyMetConcert;

  /// No description provided for @storyMetBeach.
  ///
  /// In en, this message translates to:
  /// **'The sun was high and the sand was warm, the perfect day for a spirited game of beach volleyball. You were on opposite teams, the net a playful barrier between you. The competitive spirit was fierce, with every spike and dive met with good-natured taunts and triumphant cheers. But as the game progressed, the competitive fire slowly transformed into a playful flirtation. A well-aimed shot would be followed by a wink, a missed serve met with a charmingly apologetic smile. By the time the sun began to dip below the horizon, painting the sky in fiery hues of orange and pink, the game was long forgotten. You sat together on the cooling sand, the volleyball resting between you, and talked until the first stars appeared, the playful rivalry having given way to a sweet and undeniable attraction.'**
  String get storyMetBeach;

  /// No description provided for @storyMetMuseum.
  ///
  /// In en, this message translates to:
  /// **'The art exhibition was a showcase of avant-garde and abstract pieces, and as you wandered through the quiet, white-walled galleries, you couldn\'t help but notice that you were both the only people under the age of thirty in attendance. A shared, amused glance across a particularly bewildering sculpture was all it took to break the ice. You started whispering to each other, your initial, serious critiques quickly devolving into making up wild and hilarious backstories for the portraits and paintings. The stern-faced nobleman in the oil painting became a time-traveling rock star, and the abstract splash of colors was a depiction of a chaotic toddler\'s birthday party. You spent the entire afternoon lost in your own world of creativity and laughter, finding more art in your shared humor than in any of the pieces on display.'**
  String get storyMetMuseum;

  /// No description provided for @storyMetSupermarket.
  ///
  /// In en, this message translates to:
  /// **'The fluorescent lights of the supermarket aisle cast a mundane glow on your evening grocery run. You saw them staring up at the top shelf, a look of mild frustration on their face as they tried to reach a jar of artisanal honey. Being a little taller, you offered to help, your hand brushing theirs as you passed them the jar. A simple act of kindness in a commonplace setting. But what started as a brief exchange about the merits of different types of honey turned into a full-blown conversation that wound its way through the produce section, the bakery, and the international foods aisle. You discovered a shared love for cooking and experimenting with new recipes. By the time you reached the checkout, the impromptu grocery run had turned into a spontaneous plan for a cooking date that very same evening, proving that romance can be found in the most unexpected of places.'**
  String get storyMetSupermarket;

  /// No description provided for @storyMetRain.
  ///
  /// In en, this message translates to:
  /// **'An unexpected downpour had sent people scurrying for cover, but you were prepared, your trusty umbrella held high. You saw them huddled under a small awning, looking out at the rain with a resigned sigh. Without a second thought, you walked over and offered to share your umbrella. They accepted with a grateful smile, and you both set off, walking side-by-side under the protective canopy. You walked slowly, deliberately, not wanting the shared moment to end. The sound of the rain drumming on the umbrella created an intimate cocoon, shutting out the rest of the world. By the time the rain had softened to a drizzle and then stopped altogether, you were miles from where you had started. But you didn\'t mind. You kept walking, the now-unnecessary umbrella still held between you, a silent testament to the storm that had brought you together.'**
  String get storyMetRain;

  /// No description provided for @storyMetElevator.
  ///
  /// In en, this message translates to:
  /// **'The gentle hum of the elevator came to an abrupt halt, followed by a sudden jolt and then an unnerving silence. You were stuck. Trapped between floors with a complete stranger. The first few minutes were filled with an awkward silence, punctuated only by the occasional nervous cough. But as the minutes stretched into an hour, and then two, the initial awkwardness melted away. With nothing else to do, you started talking. You shared stories, dreams, and vulnerabilities that you had never confessed to anyone before. In the close confines of that metal box, you found a surprising and profound connection. What started as a frightening and inconvenient situation became the most meaningful and transformative conversation of your lives. When the elevator doors finally creaked open, you stepped out not as strangers, but as two people whose lives had been irrevocably changed by a chance encounter.'**
  String get storyMetElevator;

  /// No description provided for @storyMetDogPark.
  ///
  /// In en, this message translates to:
  /// **'Your dogs were the ones who made the first move. A boisterous Golden Retriever and a playful French Bulldog, they became inseparable from the moment they met at the dog park, their joyful antics a daily source of amusement. You, their respective owners, were initially just casual acquaintances, making small talk while your furry companions wrestled and chased each other. But as the daily play dates continued, you found yourselves looking forward to your conversations as much as your dogs looked forward to their playtime. You graduated from discussing dog breeds and training tips to sharing stories about your lives, your work, and your dreams. You had no choice but to follow your dogs\' lead and become best friends, and eventually, something more.'**
  String get storyMetDogPark;

  /// No description provided for @storyMetWorkshop.
  ///
  /// In en, this message translates to:
  /// **'The pottery class was meant to be a fun, creative outlet, a chance to get your hands dirty and make something beautiful. You were paired up as partners, your initial attempts at the pottery wheel resulting in a lopsided, wobbly mess that had you both laughing until your sides hurt. But as you worked together, your hands guiding the clay, you found a rhythm, a synergy that went beyond the pottery wheel. Your first creation together was a wonky, imperfect vase, but you cherished it more than any masterpiece. It became a symbol of your burgeoning relationship, a tangible reminder of the day you molded something beautiful together, both out of clay and out of a chance encounter.'**
  String get storyMetWorkshop;

  /// No description provided for @storyMetVolunteering.
  ///
  /// In en, this message translates to:
  /// **'You both felt a calling to give back to your community, a shared desire to make a difference. You met while volunteering at a local animal shelter, your days filled with the rewarding work of caring for abandoned and neglected animals. Working side-by-side, cleaning cages, walking dogs, and comforting scared kittens, you saw the best in each other. You saw their kindness, their patience, their compassion, and their unwavering dedication. It was in those quiet moments of shared purpose, of working together to help those in need, that you realized you had found someone whose heart was as big as your own. Your shared love for animals was just the beginning of a much deeper and more meaningful connection.'**
  String get storyMetVolunteering;

  /// No description provided for @storyProposalSunset.
  ///
  /// In en, this message translates to:
  /// **'The air grew cooler as you made your way up your favorite hill, the one that overlooked the entire city. It was a place you had come to so many times before, a place of quiet reflection and shared dreams. As the sun began its descent, painting the sky in fiery strokes of orange, pink, and gold, the city lights below began to twinkle to life, like a thousand tiny diamonds scattered across a velvet cloth. In that magical moment, suspended between the fading day and the emerging night, you turned to them, your heart pounding in your chest. With the last ray of sunlight kissing the horizon, you got down on one knee, the world seeming to hold its breath as you asked them to be yours forever.'**
  String get storyProposalSunset;

  /// No description provided for @storyProposalMountain.
  ///
  /// In en, this message translates to:
  /// **'The air was thin and crisp at the summit of the mountain, the culmination of a challenging but rewarding climb that mirrored your journey together. It was the same mountain you had conquered on your first adventure, a place that held a special significance in your hearts. As you stood there, hand in hand, catching your breath and taking in the breathtaking panoramic view, you knew this was the moment. You reached into your backpack, past the water bottles and extra layers, and pulled out the trail mix. With a playful smile, you offered them a handful. Hidden amongst the nuts and dried fruit was a small, sparkling ring, a treasure that had been secretly accompanying you on your entire ascent.'**
  String get storyProposalMountain;

  /// No description provided for @storyProposalHome.
  ///
  /// In en, this message translates to:
  /// **'The soft glow of the lamp cast a warm and inviting light across your cozy living room, a space filled with the comfortable clutter of a life lived together. Photos on the mantelpiece chronicled your adventures, and a well-loved blanket was draped over the arm of the sofa where you had spent countless evenings. There were no grand gestures, no dramatic backdrops, just the quiet intimacy of the home you had built together. Surrounded by all the memories you had created, the laughter that had echoed through the rooms, and the love that had filled every corner, you knew that the most profound and meaningful moments often happen in the most familiar of places. It was in that simple, perfect setting that you asked them to share the rest of their lives with you.'**
  String get storyProposalHome;

  /// No description provided for @storyProposalRestaurant.
  ///
  /// In en, this message translates to:
  /// **'The soft clinking of silverware and the low hum of conversation filled the air at the charming little restaurant where you had your very first date. It was a place steeped in nostalgia, a place where your love story had first begun to blossom. You had conspired with the waiter, a mischievous twinkle in his eye as he played his part in your romantic scheme. As the meal came to an end, he approached your table not with the dessert menu, but with a silver platter. Resting on a bed of rose petals was a small, elegant box. Just like in the movies, a perfect and timeless romantic gesture, you opened the box to reveal the ring, asking them to be your co-star in a love story for the ages.'**
  String get storyProposalRestaurant;

  /// No description provided for @storyProposalBeach.
  ///
  /// In en, this message translates to:
  /// **'The rhythmic sound of the waves crashing against the shore was a familiar and comforting melody on the beach where you had first uttered the words \'I love you.\' The sun was beginning to set, casting a warm, golden glow across the sand. Earlier in the day, you had come to this very spot and carefully written your proposal in the wet sand, a secret message hidden just below the surface. As the tide began to recede, the water slowly revealed your heartfelt words, the question appearing as if by magic. As they read the words etched in the sand, you were already down on one knee, the sound of the ocean a witness to your love.'**
  String get storyProposalBeach;

  /// No description provided for @storyProposalGarden.
  ///
  /// In en, this message translates to:
  /// **'The air in the botanical garden was sweet with the fragrance of cherry blossoms, the delicate pink and white petals creating a breathtaking canopy overhead. It was the peak of the season, a fleeting and beautiful moment that you wanted to capture forever. As you walked hand in hand through the serene and picturesque garden, a gentle breeze rustled the branches, causing the petals to fall like confetti, a natural celebration of the moment that was about to unfold. Surrounded by the ethereal beauty of the cherry blossoms, you stopped, turned to them, and asked the most important question of your life, the falling petals a soft and romantic blessing on your love.'**
  String get storyProposalGarden;

  /// No description provided for @storyProposalRooftop.
  ///
  /// In en, this message translates to:
  /// **'The city sprawled below you, a glittering tapestry of lights under a vast, star-dusted sky. From your vantage point on the secluded rooftop, the hustle and bustle of the world below seemed a distant murmur. It was a space that felt like your own private universe. For weeks, you had been studying star charts, and tonight, you pointed out constellations, tracing their shapes with your finger. But you had a secret map to share. You had carefully chosen a moment when a specific alignment of stars, with a little help from your imagination, seemed to spell out the words \'Marry Me.\' As you revealed your celestial message, you brought out a ring that sparkled as brightly as the stars above.'**
  String get storyProposalRooftop;

  /// No description provided for @storyProposalPicnic.
  ///
  /// In en, this message translates to:
  /// **'You led them to your secret meadow, a secluded spot you had discovered together, filled with wildflowers and bathed in the warm afternoon sun. A beautiful picnic was already laid out on a checkered blanket, a surprise to delight them. You feasted on their favorite foods and shared a bottle of champagne, reminiscing about your time together. At the very bottom of the picnic basket, nestled beneath the last of the treats, was a small, carefully wrapped package. It was your first photo together, a candid snapshot from the early days of your relationship. Taped to the back of the photo was a beautiful, delicate ring.'**
  String get storyProposalPicnic;

  /// No description provided for @storyProposalWalk.
  ///
  /// In en, this message translates to:
  /// **'The evening was calm and peaceful as you set out on your daily walk through the familiar streets of your neighborhood. It was a cherished routine, a time to decompress, to talk about your day, and to simply enjoy each other\'s company. The setting sun cast long shadows as you walked past familiar houses and waved to neighbors. There was nothing out of the ordinary about this particular walk, which was exactly the point. You wanted to show that your love wasn\'t just about the grand adventures and momentous occasions, but also about the quiet, everyday moments. As you paused under your favorite old oak tree, you realized that sometimes the most extraordinary and life-changing moments happen during the most ordinary and unassuming of activities.'**
  String get storyProposalWalk;

  /// No description provided for @storyProposalStars.
  ///
  /// In en, this message translates to:
  /// **'The crackling campfire cast a warm glow on your faces as you sat huddled together under a thick, cozy blanket. Far from the city lights, the sky above was a breathtaking blanket of stars, a celestial spectacle that made you feel both incredibly small and infinitely connected. You pointed out constellations, made wishes on satellites, and talked about the vastness of the universe. As a brilliant shooting star streaked across the inky black sky, you squeezed their hand and whispered that you had just made your wish. Then, you reached into your pocket and pulled out a ring, asking them to make your most heartfelt wish come true.'**
  String get storyProposalStars;

  /// No description provided for @storyProposalRain.
  ///
  /// In en, this message translates to:
  /// **'The sky opened up unexpectedly, a sudden downpour that mirrored the day you first met. Instead of seeking shelter, you embraced the rain, laughing as you got soaked to the skin. It felt symbolic, a cleansing and joyful moment. You told them that you wanted every significant moment of your lives to be blessed by what you playfully called \'heaven\'s tears of joy.\' With raindrops plastering your hair to your face and your clothes clinging to you, you got down on one knee in a puddle, the rain washing over you both as you asked them to be your partner in weathering all of life\'s storms together.'**
  String get storyProposalRain;

  /// No description provided for @storyProposalCafe.
  ///
  /// In en, this message translates to:
  /// **'The cozy aroma of coffee and pastries enveloped you as you sat at your usual table in the small café where you had spent countless lazy Sunday mornings. It was a place filled with the comfortable routine of your shared life. You had let the barista in on your secret, and as she brought over your lattes, she gave you a subtle, encouraging nod. At first, they didn\'t notice, but then they saw it, carefully written in the delicate foam of their latte: \'Will you marry me?\' As they looked up from their cup, their eyes wide with surprise and delight, you were already holding out the ring.'**
  String get storyProposalCafe;

  /// No description provided for @storyProposalPark.
  ///
  /// In en, this message translates to:
  /// **'You took them on a nostalgic journey, recreating your very first walk hand in hand through the park. You reminisced about your initial nervousness, the funny stories you told, and the exact moment your fingers first intertwined. You led them along the familiar path, past the duck pond and the old-fashioned bandstand, every step a retracing of your love story\'s beginning. You finally stopped at the very spot, under the shade of a large willow tree, where you had first known, with absolute certainty, that you were in love. It was there, in that place of profound personal significance, that you asked them to walk with you for the rest of your lives.'**
  String get storyProposalPark;

  /// No description provided for @storyProposalTrip.
  ///
  /// In en, this message translates to:
  /// **'You had been planning this dream vacation for years, a trip to the most beautiful and exotic place you had ever seen together. The scenery was breathtaking, with turquoise waters, lush green mountains, and vibrant, colorful flowers at every turn. You had been carrying the ring with you the entire time, tucked away safely in your luggage, waiting for the perfect, unforgettable moment. On your last day, at a scenic overlook with a view that seemed to stretch on forever, you knew this was it. With the stunning landscape as your witness, you told them that as beautiful as this place was, the most beautiful view you could ever imagine was spending the rest of your life with them.'**
  String get storyProposalTrip;

  /// No description provided for @storyProposalSurprise.
  ///
  /// In en, this message translates to:
  /// **'It was a completely ordinary Tuesday evening. You were in your pajamas, debating what to watch on TV and what to have for dinner. There was no special occasion, no romantic getaway, no elaborate plan. But as you looked at them, laughing at one of your silly jokes, you were overcome with a powerful wave of love and certainty. You realized that you didn\'t want to wait for a \'perfect\' moment, because every moment with them was perfect. You knew, with every fiber of your being, that you wanted to spend the rest of your life with this person. And so, in the middle of a perfectly normal, wonderfully mundane evening, you asked them to marry you, proving that when you know, you just know.'**
  String get storyProposalSurprise;

  /// No description provided for @storyWeddingGarden.
  ///
  /// In en, this message translates to:
  /// **'Your garden wedding was an enchanting and intimate affair, a magical celebration of your love held under the open sky. As the sun set, hundreds of twinkling fairy lights strung between the branches of ancient oak trees created a celestial canopy above you. The air was filled with the sweet, intoxicating scent of roses blooming in every corner, their vibrant colors a testament to the beauty of your love. The atmosphere was one of relaxed elegance and natural beauty, a perfect reflection of your relationship.'**
  String get storyWeddingGarden;

  /// No description provided for @storyWeddingBeach.
  ///
  /// In en, this message translates to:
  /// **'With the warm sand between your toes and the gentle ocean breeze carrying your whispered promises across the waves, you exchanged your vows in a breathtaking beach ceremony. The sound of the ocean was your wedding march, and the endless expanse of the sea was a symbol of the infinite possibilities that lay before you. The setting was simple yet profound, a reminder of the raw and natural beauty of your love. As the sun dipped below the horizon, casting a golden glow on the water, you sealed your union with a kiss, the waves applauding your love.'**
  String get storyWeddingBeach;

  /// No description provided for @storyWeddingCastle.
  ///
  /// In en, this message translates to:
  /// **'It was a fairytale come to life, a magnificent castle wedding complete with grand, sweeping staircases, glittering crystal chandeliers, and opulent tapestries adorning the walls. You felt like royalty on your special day, your love story given the grand and majestic setting it deserved. The historic and romantic atmosphere of the castle added a timeless quality to your celebration, making it a day that you and your guests would never forget.'**
  String get storyWeddingCastle;

  /// No description provided for @storyWeddingIntimate.
  ///
  /// In en, this message translates to:
  /// **'You chose to celebrate your love with a small, intimate ceremony, surrounded by only your closest family and friends. The focus of the day was not on elaborate decorations or grand gestures, but on what truly mattered: the love that you shared. The atmosphere was one of warmth, sincerity, and heartfelt emotion, a true reflection of the deep and personal connection you had with each other and with your cherished guests.'**
  String get storyWeddingIntimate;

  /// No description provided for @storyWeddingVineyard.
  ///
  /// In en, this message translates to:
  /// **'Nestled amongst rolling hills and rows of lush grapevines, your vineyard wedding was a celebration of love, life, and the finer things. You celebrated your union with wine that was as rich, complex, and full-bodied as your relationship. The rustic yet elegant setting provided a stunning backdrop for your special day, the natural beauty of the vineyard a perfect complement to the love that was blossoming between you.'**
  String get storyWeddingVineyard;

  /// No description provided for @storyWeddingMountain.
  ///
  /// In en, this message translates to:
  /// **'High in the mountains, with majestic peaks surrounding you and an endless expanse of sky above, your love felt as boundless and awe-inspiring as the breathtaking view. You exchanged your vows in a ceremony that was both intimate and grand, the raw and untamed beauty of the mountains a powerful symbol of the strength and resilience of your love. The crisp mountain air and the sense of peace and tranquility made for a truly unforgettable and spiritual celebration.'**
  String get storyWeddingMountain;

  /// No description provided for @storyWeddingCity.
  ///
  /// In en, this message translates to:
  /// **'Your chic city wedding was a sophisticated and stylish affair, with breathtaking skyline views and a cool, urban elegance that perfectly reflected your modern love story. The sleek and contemporary venue, with its clean lines and minimalist décor, provided a stunning backdrop for your celebration. The energy of the city, with its vibrant pulse and endless possibilities, was a fitting tribute to your dynamic and forward-thinking relationship.'**
  String get storyWeddingCity;

  /// No description provided for @storyWeddingRustic.
  ///
  /// In en, this message translates to:
  /// **'Your rustic barn wedding was a charming and romantic celebration, with the warm glow of string lights illuminating the weathered wood of the barn. Mason jar centerpieces filled with wildflowers adorned the tables, and the sweet, soulful melodies of a string quartet echoed through the countryside. The atmosphere was one of relaxed and unpretentious elegance, a perfect blend of country charm and timeless romance.'**
  String get storyWeddingRustic;

  /// No description provided for @storyWeddingTropical.
  ///
  /// In en, this message translates to:
  /// **'You escaped to a tropical paradise for your wedding, a celebration of love held under the shade of swaying palm trees with the gentle sound of waves providing your soundtrack. The vibrant colors of the tropical flowers, the warm, balmy air, and the laid-back, joyful atmosphere created a truly unforgettable and exotic experience for you and your guests. It was a wedding and a vacation all in one, a perfect start to your new life together.'**
  String get storyWeddingTropical;

  /// No description provided for @storyWeddingWinter.
  ///
  /// In en, this message translates to:
  /// **'Your winter wedding was a magical and enchanting affair, with a soft blanket of snow covering the ground and everything sparkling like diamonds in the moonlight. The cozy and intimate atmosphere was enhanced by the warm glow of candlelight and the crackling of a roaring fire. It was a truly romantic and fairytale-like celebration, the crisp winter air and the serene beauty of the snow-covered landscape creating a picture-perfect setting for your special day.'**
  String get storyWeddingWinter;

  /// No description provided for @storyWeddingModern.
  ///
  /// In en, this message translates to:
  /// **'Your sleek, modern wedding was a reflection of your contemporary and forward-thinking love. The venue, with its clean lines, minimalist décor, and striking contemporary art, provided a sophisticated and stylish backdrop for your celebration. The focus was on clean design, innovative details, and a chic, understated elegance that perfectly captured your unique and modern approach to love and life.'**
  String get storyWeddingModern;

  /// No description provided for @storyWeddingClassic.
  ///
  /// In en, this message translates to:
  /// **'Your timeless, classic wedding was a beautiful and elegant affair, with traditional elements that honored both of your families\' heritage. The ceremony was filled with meaningful rituals and customs, and the reception was a grand celebration of your union. It was a day that was both deeply personal and universally understood, a testament to the enduring power of love and tradition.'**
  String get storyWeddingClassic;

  /// No description provided for @storyWeddingBoho.
  ///
  /// In en, this message translates to:
  /// **'Your bohemian celebration was a free-spirited and joyful affair, with flowing fabrics, an abundance of wildflowers, and a laid-back, relaxed atmosphere. You danced the night away under the stars, your hearts filled with the carefree and adventurous spirit that defined your relationship. It was a wedding that was as unique and unconventional as your love story, a true reflection of your creative and untamed hearts.'**
  String get storyWeddingBoho;

  /// No description provided for @storyWeddingDestination.
  ///
  /// In en, this message translates to:
  /// **'You whisked your guests away to an exotic and breathtaking destination for your wedding, turning your special day into an unforgettable adventure for everyone involved. The unique culture, stunning scenery, and shared experience of travel created a bond between you and your guests that would last a lifetime. It was a wedding that was more than just a single day; it was a journey, a story, and an experience that you would all cherish forever.'**
  String get storyWeddingDestination;

  /// No description provided for @storyWeddingBackyard.
  ///
  /// In en, this message translates to:
  /// **'You transformed your own backyard into a magical wonderland for your wedding, proving that home truly is where the heart is. With personal touches and DIY details, you created a celebration that was both intimate and deeply meaningful. Surrounded by the familiar comforts of home and the love of your family and friends, you celebrated your union in a way that was uniquely and beautifully you.'**
  String get storyWeddingBackyard;

  /// No description provided for @babyLovesMusic.
  ///
  /// In en, this message translates to:
  /// **'Gentle lullabies and classical melodies'**
  String get babyLovesMusic;

  /// No description provided for @babyLovesColors.
  ///
  /// In en, this message translates to:
  /// **'Bright colors and rainbow toys'**
  String get babyLovesColors;

  /// No description provided for @babyLovesAnimals.
  ///
  /// In en, this message translates to:
  /// **'Cute animals and stuffed friends'**
  String get babyLovesAnimals;

  /// No description provided for @babyLovesBooks.
  ///
  /// In en, this message translates to:
  /// **'Story time and picture books'**
  String get babyLovesBooks;

  /// No description provided for @babyLovesNature.
  ///
  /// In en, this message translates to:
  /// **'Flowers, trees, and outdoor adventures'**
  String get babyLovesNature;

  /// No description provided for @babyLovesDancing.
  ///
  /// In en, this message translates to:
  /// **'Wiggling and dancing to music'**
  String get babyLovesDancing;

  /// No description provided for @babyLovesWater.
  ///
  /// In en, this message translates to:
  /// **'Bath time splashing and swimming'**
  String get babyLovesWater;

  /// No description provided for @babyLovesCuddles.
  ///
  /// In en, this message translates to:
  /// **'Warm hugs and snuggle time'**
  String get babyLovesCuddles;

  /// No description provided for @babyLovesStars.
  ///
  /// In en, this message translates to:
  /// **'Twinkling stars and night lights'**
  String get babyLovesStars;

  /// No description provided for @babyLovesLaughter.
  ///
  /// In en, this message translates to:
  /// **'Giggles and funny faces'**
  String get babyLovesLaughter;

  /// No description provided for @babyLovesArt.
  ///
  /// In en, this message translates to:
  /// **'Finger painting and creative mess'**
  String get babyLovesArt;

  /// No description provided for @babyLovesFlowers.
  ///
  /// In en, this message translates to:
  /// **'Pretty flowers and garden walks'**
  String get babyLovesFlowers;

  /// No description provided for @babyLovesSinging.
  ///
  /// In en, this message translates to:
  /// **'Nursery rhymes and silly songs'**
  String get babyLovesSinging;

  /// No description provided for @babyLovesAdventure.
  ///
  /// In en, this message translates to:
  /// **'New places and exciting discoveries'**
  String get babyLovesAdventure;

  /// No description provided for @babyLovesSweets.
  ///
  /// In en, this message translates to:
  /// **'Gentle treats and fruity snacks'**
  String get babyLovesSweets;

  /// No description provided for @babyHatesLoudNoises.
  ///
  /// In en, this message translates to:
  /// **'Sudden loud sounds and sirens'**
  String get babyHatesLoudNoises;

  /// No description provided for @babyHatesDarkness.
  ///
  /// In en, this message translates to:
  /// **'Dark rooms without night lights'**
  String get babyHatesDarkness;

  /// No description provided for @babyHatesBroccoli.
  ///
  /// In en, this message translates to:
  /// **'Green vegetables at dinner time'**
  String get babyHatesBroccoli;

  /// No description provided for @babyHatesWaiting.
  ///
  /// In en, this message translates to:
  /// **'Having to wait for anything fun'**
  String get babyHatesWaiting;

  /// No description provided for @babyHatesCrowds.
  ///
  /// In en, this message translates to:
  /// **'Too many people at once'**
  String get babyHatesCrowds;

  /// No description provided for @babyHatesBedtime.
  ///
  /// In en, this message translates to:
  /// **'Going to sleep when it\'s play time'**
  String get babyHatesBedtime;

  /// No description provided for @babyHatesRain.
  ///
  /// In en, this message translates to:
  /// **'Gloomy, wet days indoors'**
  String get babyHatesRain;

  /// No description provided for @babyHatesSpicy.
  ///
  /// In en, this message translates to:
  /// **'Any food that\'s too spicy'**
  String get babyHatesSpicy;

  /// No description provided for @babyHatesMess.
  ///
  /// In en, this message translates to:
  /// **'Sticky hands and dirty clothes'**
  String get babyHatesMess;

  /// No description provided for @babyHatesGoodbye.
  ///
  /// In en, this message translates to:
  /// **'When loved ones have to leave'**
  String get babyHatesGoodbye;

  /// No description provided for @babyHatesCold.
  ///
  /// In en, this message translates to:
  /// **'Chilly weather and cold food'**
  String get babyHatesCold;

  /// No description provided for @babyHatesRush.
  ///
  /// In en, this message translates to:
  /// **'Being hurried or rushed around'**
  String get babyHatesRush;

  /// No description provided for @babyHatesAngry.
  ///
  /// In en, this message translates to:
  /// **'When people raise their voices'**
  String get babyHatesAngry;

  /// No description provided for @babyHatesBoring.
  ///
  /// In en, this message translates to:
  /// **'Sitting still for too long'**
  String get babyHatesBoring;

  /// No description provided for @babyHatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty plates and finished bottles'**
  String get babyHatesEmpty;

  /// No description provided for @chatUserMsg1.
  ///
  /// In en, this message translates to:
  /// **'Hey! How was your day? 😊'**
  String get chatUserMsg1;

  /// No description provided for @chatUserMsg2.
  ///
  /// In en, this message translates to:
  /// **'I just saw the most beautiful sunset!'**
  String get chatUserMsg2;

  /// No description provided for @chatUserMsg3.
  ///
  /// In en, this message translates to:
  /// **'What\'s your favorite type of music?'**
  String get chatUserMsg3;

  /// No description provided for @chatUserMsg4.
  ///
  /// In en, this message translates to:
  /// **'Do you believe in destiny?'**
  String get chatUserMsg4;

  /// No description provided for @chatUserMsg5.
  ///
  /// In en, this message translates to:
  /// **'I love how you always make me smile'**
  String get chatUserMsg5;

  /// No description provided for @chatUserMsg6.
  ///
  /// In en, this message translates to:
  /// **'What\'s your dream vacation spot?'**
  String get chatUserMsg6;

  /// No description provided for @chatUserMsg7.
  ///
  /// In en, this message translates to:
  /// **'You have such beautiful eyes'**
  String get chatUserMsg7;

  /// No description provided for @chatUserMsg8.
  ///
  /// In en, this message translates to:
  /// **'I feel like I\'ve known you forever'**
  String get chatUserMsg8;

  /// No description provided for @chatUserMsg9.
  ///
  /// In en, this message translates to:
  /// **'What makes you happiest in life?'**
  String get chatUserMsg9;

  /// No description provided for @chatUserMsg10.
  ///
  /// In en, this message translates to:
  /// **'I love our deep conversations'**
  String get chatUserMsg10;

  /// No description provided for @chatUserMsg11.
  ///
  /// In en, this message translates to:
  /// **'You\'re so easy to talk to'**
  String get chatUserMsg11;

  /// No description provided for @chatUserMsg12.
  ///
  /// In en, this message translates to:
  /// **'What\'s your biggest dream?'**
  String get chatUserMsg12;

  /// No description provided for @chatUserMsg13.
  ///
  /// In en, this message translates to:
  /// **'I love how passionate you are'**
  String get chatUserMsg13;

  /// No description provided for @chatUserMsg14.
  ///
  /// In en, this message translates to:
  /// **'You make everything better'**
  String get chatUserMsg14;

  /// No description provided for @chatUserMsg15.
  ///
  /// In en, this message translates to:
  /// **'I can\'t stop thinking about you'**
  String get chatUserMsg15;

  /// No description provided for @chatSoulmateMsg1.
  ///
  /// In en, this message translates to:
  /// **'It was wonderful, especially now that I\'m talking to you! ✨'**
  String get chatSoulmateMsg1;

  /// No description provided for @chatSoulmateMsg2.
  ///
  /// In en, this message translates to:
  /// **'I bet it was nothing compared to your radiant smile 😍'**
  String get chatSoulmateMsg2;

  /// No description provided for @chatSoulmateMsg3.
  ///
  /// In en, this message translates to:
  /// **'I love anything that speaks to the soul... like you do 💕'**
  String get chatSoulmateMsg3;

  /// No description provided for @chatSoulmateMsg4.
  ///
  /// In en, this message translates to:
  /// **'Absolutely! That\'s how I found you 🌟'**
  String get chatSoulmateMsg4;

  /// No description provided for @chatSoulmateMsg5.
  ///
  /// In en, this message translates to:
  /// **'Your happiness is my favorite sight in the world'**
  String get chatSoulmateMsg5;

  /// No description provided for @chatSoulmateMsg6.
  ///
  /// In en, this message translates to:
  /// **'Anywhere with you would be paradise 🏝️'**
  String get chatSoulmateMsg6;

  /// No description provided for @chatSoulmateMsg7.
  ///
  /// In en, this message translates to:
  /// **'They\'re nothing compared to the beauty of your heart'**
  String get chatSoulmateMsg7;

  /// No description provided for @chatSoulmateMsg8.
  ///
  /// In en, this message translates to:
  /// **'That\'s because we\'re meant to be together 💫'**
  String get chatSoulmateMsg8;

  /// No description provided for @chatSoulmateMsg9.
  ///
  /// In en, this message translates to:
  /// **'You. You make me happiest 💖'**
  String get chatSoulmateMsg9;

  /// No description provided for @chatSoulmateMsg10.
  ///
  /// In en, this message translates to:
  /// **'Your mind is as beautiful as your soul'**
  String get chatSoulmateMsg10;

  /// No description provided for @chatSoulmateMsg11.
  ///
  /// In en, this message translates to:
  /// **'Because you understand me completely'**
  String get chatSoulmateMsg11;

  /// No description provided for @chatSoulmateMsg12.
  ///
  /// In en, this message translates to:
  /// **'To spend every moment making you happy'**
  String get chatSoulmateMsg12;

  /// No description provided for @chatSoulmateMsg13.
  ///
  /// In en, this message translates to:
  /// **'Your passion ignites my soul 🔥'**
  String get chatSoulmateMsg13;

  /// No description provided for @chatSoulmateMsg14.
  ///
  /// In en, this message translates to:
  /// **'You ARE everything to me'**
  String get chatSoulmateMsg14;

  /// No description provided for @chatSoulmateMsg15.
  ///
  /// In en, this message translates to:
  /// **'I think about you with every heartbeat 💓'**
  String get chatSoulmateMsg15;

  /// No description provided for @partnerTitleDreamWeaver.
  ///
  /// In en, this message translates to:
  /// **'The Dream Weaver'**
  String get partnerTitleDreamWeaver;

  /// No description provided for @partnerTitleStarGazer.
  ///
  /// In en, this message translates to:
  /// **'The Star Gazer'**
  String get partnerTitleStarGazer;

  /// No description provided for @partnerTitleHeartWhisperer.
  ///
  /// In en, this message translates to:
  /// **'The Heart Whisperer'**
  String get partnerTitleHeartWhisperer;

  /// No description provided for @partnerTitleSoulSeeker.
  ///
  /// In en, this message translates to:
  /// **'The Soul Seeker'**
  String get partnerTitleSoulSeeker;

  /// No description provided for @partnerTitleLoveGuardian.
  ///
  /// In en, this message translates to:
  /// **'The Love Guardian'**
  String get partnerTitleLoveGuardian;

  /// No description provided for @partnerTitleMoonDancer.
  ///
  /// In en, this message translates to:
  /// **'The Moon Dancer'**
  String get partnerTitleMoonDancer;

  /// No description provided for @partnerTitleSunChaser.
  ///
  /// In en, this message translates to:
  /// **'The Sun Chaser'**
  String get partnerTitleSunChaser;

  /// No description provided for @partnerTitleWiseSage.
  ///
  /// In en, this message translates to:
  /// **'The Wise Sage'**
  String get partnerTitleWiseSage;

  /// No description provided for @partnerTitleGentleSpirit.
  ///
  /// In en, this message translates to:
  /// **'The Gentle Spirit'**
  String get partnerTitleGentleSpirit;

  /// No description provided for @partnerTitleKindHeart.
  ///
  /// In en, this message translates to:
  /// **'The Kind Heart'**
  String get partnerTitleKindHeart;

  /// No description provided for @partnerTitleBraveExplorer.
  ///
  /// In en, this message translates to:
  /// **'The Brave Explorer'**
  String get partnerTitleBraveExplorer;

  /// No description provided for @partnerTitleCreativeMind.
  ///
  /// In en, this message translates to:
  /// **'The Creative Mind'**
  String get partnerTitleCreativeMind;

  /// No description provided for @partnerTitlePeaceMaker.
  ///
  /// In en, this message translates to:
  /// **'The Peace Maker'**
  String get partnerTitlePeaceMaker;

  /// No description provided for @partnerTitleJoyBringer.
  ///
  /// In en, this message translates to:
  /// **'The Joy Bringer'**
  String get partnerTitleJoyBringer;

  /// No description provided for @partnerTitleLightBearer.
  ///
  /// In en, this message translates to:
  /// **'The Light Bearer'**
  String get partnerTitleLightBearer;

  /// No description provided for @shareSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Shared successfully! 💕'**
  String get shareSuccessMessage;

  /// No description provided for @shareErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to share. Please try again.'**
  String get shareErrorMessage;

  /// No description provided for @shareImageButton.
  ///
  /// In en, this message translates to:
  /// **'Share as Image'**
  String get shareImageButton;

  /// No description provided for @shareTextButton.
  ///
  /// In en, this message translates to:
  /// **'Share Text'**
  String get shareTextButton;

  /// No description provided for @profileInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Your Information'**
  String get profileInfoSection;

  /// No description provided for @chapter1CompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'ve discovered your soulmate\'s traits!'**
  String get chapter1CompletedSummary;

  /// No description provided for @chapter2CompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'Your love story has been written!'**
  String get chapter2CompletedSummary;

  /// No description provided for @chapter3CompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'ve met your future baby!'**
  String get chapter3CompletedSummary;

  /// No description provided for @chapter4CompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'ve chatted with your soulmate!'**
  String get chapter4CompletedSummary;

  /// No description provided for @chapter5CompletedSummary.
  ///
  /// In en, this message translates to:
  /// **'You\'ve found your perfect match!'**
  String get chapter5CompletedSummary;

  /// No description provided for @chapterCompletedDefault.
  ///
  /// In en, this message translates to:
  /// **'You\'ve unlocked this memory!'**
  String get chapterCompletedDefault;

  /// No description provided for @chapter1UnlockedSummary.
  ///
  /// In en, this message translates to:
  /// **'Discover your soulmate\'s traits'**
  String get chapter1UnlockedSummary;

  /// No description provided for @chapter2UnlockedSummary.
  ///
  /// In en, this message translates to:
  /// **'Create your unique love story'**
  String get chapter2UnlockedSummary;

  /// No description provided for @chapter3UnlockedSummary.
  ///
  /// In en, this message translates to:
  /// **'Meet your future baby'**
  String get chapter3UnlockedSummary;

  /// No description provided for @chapter4UnlockedSummary.
  ///
  /// In en, this message translates to:
  /// **'Chat with your soulmate'**
  String get chapter4UnlockedSummary;

  /// No description provided for @chapter5UnlockedSummary.
  ///
  /// In en, this message translates to:
  /// **'Find your perfect match'**
  String get chapter5UnlockedSummary;

  /// No description provided for @chapterUnlockedDefault.
  ///
  /// In en, this message translates to:
  /// **'Ready to begin this chapter'**
  String get chapterUnlockedDefault;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'{timeOfDay}, {firstName}! 👋'**
  String dashboardGreeting(Object firstName, Object timeOfDay);

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to discover your perfect match?'**
  String get dashboardSubtitle;

  /// No description provided for @timeOfDayMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get timeOfDayMorning;

  /// No description provided for @timeOfDayAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get timeOfDayAfternoon;

  /// No description provided for @timeOfDayEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get timeOfDayEvening;

  /// No description provided for @stationLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete previous stations to unlock this one!'**
  String get stationLockedMessage;

  /// No description provided for @stationStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get stationStatusLocked;

  /// No description provided for @stationStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stationStatusCompleted;

  /// No description provided for @generatingResultMessage.
  ///
  /// In en, this message translates to:
  /// **'Generating your soulmate\'s traits...'**
  String get generatingResultMessage;

  /// No description provided for @soulmateTraitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Soulmate\'s Traits'**
  String get soulmateTraitsTitle;

  /// No description provided for @funnyQuirksTitle.
  ///
  /// In en, this message translates to:
  /// **'Funny Quirks'**
  String get funnyQuirksTitle;

  /// No description provided for @seeYourStoryButton.
  ///
  /// In en, this message translates to:
  /// **'See Your Story!'**
  String get seeYourStoryButton;

  /// No description provided for @generatingStoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Writing your love story...'**
  String get generatingStoryMessage;

  /// No description provided for @generatingBabyMessage.
  ///
  /// In en, this message translates to:
  /// **'Generating your baby profile...'**
  String get generatingBabyMessage;

  /// Privacy Policy link text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of Service link text
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Privacy Policy screen title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy (Majok)'**
  String get privacyPolicyTitle;

  /// Privacy Policy last updated text
  ///
  /// In en, this message translates to:
  /// **'Last Updated: 01/08/2025'**
  String get privacyPolicyLastUpdated;

  /// Privacy Policy introduction text
  ///
  /// In en, this message translates to:
  /// **'Majok is a fun and satirical app designed for entertainment purposes only. We respect your privacy and aim to clarify the following:'**
  String get privacyPolicyIntro;

  /// Privacy Policy - We do not collect section title
  ///
  /// In en, this message translates to:
  /// **'We do NOT collect:'**
  String get privacyPolicyWeDoNotCollect;

  /// Privacy Policy - We do not collect description
  ///
  /// In en, this message translates to:
  /// **'your real name, email, or any sensitive data.'**
  String get privacyPolicyWeDoNotCollectDesc;

  /// Privacy Policy - Usage Data section title
  ///
  /// In en, this message translates to:
  /// **'Usage Data:'**
  String get privacyPolicyUsageData;

  /// Privacy Policy - Usage Data description
  ///
  /// In en, this message translates to:
  /// **'Anonymous statistics may be collected via analytics tools.'**
  String get privacyPolicyUsageDataDesc;

  /// Privacy Policy - Ads section title
  ///
  /// In en, this message translates to:
  /// **'Ads:'**
  String get privacyPolicyAds;

  /// Privacy Policy - Ads description
  ///
  /// In en, this message translates to:
  /// **'The app may show ads that use cookies for personalization.'**
  String get privacyPolicyAdsDesc;

  /// Privacy Policy - Content section title
  ///
  /// In en, this message translates to:
  /// **'Content:'**
  String get privacyPolicyContent;

  /// Privacy Policy - Content description
  ///
  /// In en, this message translates to:
  /// **'All results are fictional and meant for humor only.'**
  String get privacyPolicyContentDesc;

  /// Privacy Policy - Data Storage section title
  ///
  /// In en, this message translates to:
  /// **'Data Storage:'**
  String get privacyPolicyDataStorage;

  /// Privacy Policy - Data Storage description
  ///
  /// In en, this message translates to:
  /// **'No personal data is stored on servers.'**
  String get privacyPolicyDataStorageDesc;

  /// Privacy Policy - Policy Changes section title
  ///
  /// In en, this message translates to:
  /// **'Policy Changes:'**
  String get privacyPolicyChanges;

  /// Privacy Policy - Policy Changes description
  ///
  /// In en, this message translates to:
  /// **'Updates may occur with prior notice.'**
  String get privacyPolicyChangesDesc;

  /// Privacy Policy - Contact information text
  ///
  /// In en, this message translates to:
  /// **'For inquiries, contact us at:'**
  String get privacyPolicyContact;

  /// Terms of Service screen title
  ///
  /// In en, this message translates to:
  /// **'Terms of Use (Majok)'**
  String get termsOfServiceTitle;

  /// Terms of Service introduction text
  ///
  /// In en, this message translates to:
  /// **'By using Majok, you agree to the following:'**
  String get termsOfServiceIntro;

  /// Terms of Service - Entertainment clause
  ///
  /// In en, this message translates to:
  /// **'The app is for entertainment only. Results are fictional.'**
  String get termsOfServiceEntertainment;

  /// Terms of Service - Age requirement clause
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old to use this app.'**
  String get termsOfServiceAgeRequirement;

  /// Terms of Service - Fictional content clause
  ///
  /// In en, this message translates to:
  /// **'All names and traits are generated for humorous purposes only.'**
  String get termsOfServiceFictionalContent;

  /// Terms of Service - Sharing clause
  ///
  /// In en, this message translates to:
  /// **'You may share your results but not modify them to harm others.'**
  String get termsOfServiceSharing;

  /// Terms of Service - Ads clause
  ///
  /// In en, this message translates to:
  /// **'The app may include ads to support free access.'**
  String get termsOfServiceAds;

  /// Terms of Service - Copyright clause
  ///
  /// In en, this message translates to:
  /// **'All app content and design is copyrighted.'**
  String get termsOfServiceCopyright;

  /// Terms of Service - Disclaimer clause
  ///
  /// In en, this message translates to:
  /// **'We are not responsible for actions taken based on fictional content.'**
  String get termsOfServiceDisclaimer;

  /// Terms of Service - Important notice at bottom
  ///
  /// In en, this message translates to:
  /// **'Remember: All content in this app is purely fictional and created for entertainment. Please use responsibly and treat all results as jokes only.'**
  String get termsOfServiceImportantNotice;

  /// No description provided for @soulmate.
  ///
  /// In en, this message translates to:
  /// **'Soulmate'**
  String get soulmate;

  /// No description provided for @station6Title.
  ///
  /// In en, this message translates to:
  /// **'Restart Journey'**
  String get station6Title;

  /// No description provided for @restartJourneyConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart Journey?'**
  String get restartJourneyConfirmationTitle;
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
