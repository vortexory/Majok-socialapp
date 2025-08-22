import 'package:futu/l10n/app_localizations.dart';

// This class will hold the generated story paragraphs for Station 2.
class RomanceStory {
  final String howYouMet;
  final String theProposal;
  final String theWedding;

  RomanceStory({
    required this.howYouMet,
    required this.theProposal,
    required this.theWedding,
  });

  // A factory to generate a placeholder story.
  // This is where the logic would go to combine user inputs (zodiac, animal, etc.)
  // into a coherent and fun narrative.
  
  // MODIFICATION: The generate method now requires the 'localizations' object.
  factory RomanceStory.generate(AppLocalizations localizations) {
    return RomanceStory(
      // MODIFICATION: Using localization keys instead of hardcoded strings.
      howYouMet: localizations.storyMetParagraph,
      theProposal: localizations.storyProposalParagraph,
      theWedding: localizations.storyWeddingParagraph,
    );
  }
}