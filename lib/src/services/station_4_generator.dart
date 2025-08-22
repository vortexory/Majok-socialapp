// lib/src/services/station_4_generator.dart
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/data/chat_message_pools.dart';
import 'package:futu/src/services/deterministic_generator.dart';
import 'package:futu/src/services/storage_service.dart';

class Station4Generator {
  static final Station4Generator _instance = Station4Generator._internal();
  factory Station4Generator() => _instance;
  Station4Generator._internal();

  static Station4Generator get instance => _instance;

  // This is the only method needed now. It generates the soulmate's identity.
  Map<String, String> generatePartnerInfo({required AppLocalizations localizations, Map<String, dynamic>? userInputs}) {
    final userProfile = StorageService.instance.getUserProfile();
    final userGender = userProfile['gender']?.toString().toLowerCase();

    final seedInputs = <String, dynamic>{
      'user_name': userProfile['name'] ?? 'user',
      'user_gender': userGender ?? 'not_specified',
      'station': 4,
      'partner_generation': true,
      'color_influence': userInputs?['color_index'] ?? 0,
      'fruit_influence': userInputs?['fruit']?.hashCode ?? 0,
      ...?userInputs,
    };

    final seed = DeterministicGenerator.instance.createSeed(seedInputs);

    // ===== NEW: Dynamic Name Selection Logic =====
    // Determine which pool of names to use. Default to female partner.
    final List<String> namePool;
    if (userGender == 'female') {
      namePool = ChatMessagePool.malePartnerNames;
    } else {
      // This covers 'male', 'not specified', null, or any other value
      namePool = ChatMessagePool.femalePartnerNames;
    }

    // Deterministically select one name from the chosen pool
    final partnerName = DeterministicGenerator.instance.selectFromPool(
      pool: namePool,
      seed: seed,
      offset: 1, // Offset can remain the same as its now from a different pool
    );
    // =============================================

    final partnerTitleFunction = DeterministicGenerator.instance.selectFromPool(
      pool: ChatMessagePool.partnerTitles,
      seed: seed + ((userInputs?['color_index'] as int? ?? 0) * 100),
      offset: 2,
    );

    final partnerInfo = {'name': partnerName, 'title': partnerTitleFunction(localizations)};

    // Save partner info for consistency
    _savePartnerInfo(partnerInfo);

    return partnerInfo;
  }

  // Saves the generated partner info to be retrieved by other services
  Future<void> _savePartnerInfo(Map<String, String> partnerInfo) async {
    final resultData = {
      'partner_name': partnerInfo['name'],
      'partner_title': partnerInfo['title'],
      'generated_at': DateTime.now().toIso8601String(),
    };
    await StorageService.instance.saveStationResult(4, resultData);
  }
}
