import 'package:futu/l10n/app_localizations.dart';

class ChatMessagePool {
  // User message pools
  static List<String Function(AppLocalizations)> userMessages = [
    (l) => l.chatUserMsg1,
    (l) => l.chatUserMsg2,
    (l) => l.chatUserMsg3,
    (l) => l.chatUserMsg4,
    (l) => l.chatUserMsg5,
    (l) => l.chatUserMsg6,
    (l) => l.chatUserMsg7,
    (l) => l.chatUserMsg8,
    (l) => l.chatUserMsg9,
    (l) => l.chatUserMsg10,
    (l) => l.chatUserMsg11,
    (l) => l.chatUserMsg12,
    (l) => l.chatUserMsg13,
    (l) => l.chatUserMsg14,
    (l) => l.chatUserMsg15,
  ];

  // Soulmate response pools
  static List<String Function(AppLocalizations)> soulmateMessages = [
    (l) => l.chatSoulmateMsg1,
    (l) => l.chatSoulmateMsg2,
    (l) => l.chatSoulmateMsg3,
    (l) => l.chatSoulmateMsg4,
    (l) => l.chatSoulmateMsg5,
    (l) => l.chatSoulmateMsg6,
    (l) => l.chatSoulmateMsg7,
    (l) => l.chatSoulmateMsg8,
    (l) => l.chatSoulmateMsg9,
    (l) => l.chatSoulmateMsg10,
    (l) => l.chatSoulmateMsg11,
    (l) => l.chatSoulmateMsg12,
    (l) => l.chatSoulmateMsg13,
    (l) => l.chatSoulmateMsg14,
    (l) => l.chatSoulmateMsg15,
  ];

  // MODIFIED: Renamed to be specific
  static const List<String> femalePartnerNames = [
    "Aurora",
    "Fatima",
    "Layla",
    "Zara",
    "Maya",
    "Nour",
    "Amira",
    "Sofia",
    "Luna",
    "Aria",
    "Yasmin",
    "Rania",
    "Dina",
    "Hala",
    "Rana",
  ];

  // NEW: Add a list of male partner names
  static const List<String> malePartnerNames = [
    "Adam",
    "Karim",
    "Zayn",
    "Omar",
    "Yusuf",
    "Elias",
    "Sami",
    "Jamal",
    "Faris",
    "Rayan",
    "Idris",
    "Malik",
    "Tariq",
    "Hassan",
    "Amir",
  ];

  // Partner titles pool (these are gender-neutral)
  static List<String Function(AppLocalizations)> partnerTitles = [
    (l) => l.partnerTitleDreamWeaver,
    (l) => l.partnerTitleStarGazer,
    (l) => l.partnerTitleHeartWhisperer,
    (l) => l.partnerTitleSoulSeeker,
    (l) => l.partnerTitleLoveGuardian,
    (l) => l.partnerTitleMoonDancer,
    (l) => l.partnerTitleSunChaser,
    (l) => l.partnerTitleWiseSage,
    (l) => l.partnerTitleGentleSpirit,
    (l) => l.partnerTitleKindHeart,
    (l) => l.partnerTitleBraveExplorer,
    (l) => l.partnerTitleCreativeMind,
    (l) => l.partnerTitlePeaceMaker,
    (l) => l.partnerTitleJoyBringer,
    (l) => l.partnerTitleLightBearer,
  ];

  // Avatar Pools
  static const List<String> maleAvatars = [
    'assets/images/avatars/male_1.png',
    'assets/images/avatars/male_2.png',
    'assets/images/avatars/male_3.png',
    'assets/images/avatars/male_4.png',
    'assets/images/avatars/male_5.png',
  ];

  static const List<String> femaleAvatars = [
    'assets/images/avatars/female_1.png',
    'assets/images/avatars/female_2.png',
    'assets/images/avatars/female_3.png',
    'assets/images/avatars/female_4.png',
    'assets/images/avatars/female_5.png',
  ];
}
