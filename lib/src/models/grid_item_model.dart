import 'package:futu/l10n/app_localizations.dart';

// A generic model for items in our selection grids
class GridItem {
  final String id;
  final String iconPath;
  final String Function(AppLocalizations) getLabel;

  GridItem({required this.id, required this.iconPath, required this.getLabel});
}