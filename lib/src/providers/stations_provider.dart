import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/src/models/station_model.dart';

// This provider will hold the list of our stations.
// For now, it's hardcoded. Later, this could load from device storage.
final stationsProvider = Provider<List<Station>>((ref) {
  // This is where you define the initial state of all stations.
  return [
    Station(
      id: 1,
      getTitle: (l) => l.station1Title,
      imagePath: 'assets/images/traits.jpg',
      status: StationStatus.completed, // As per the design
    ),
    Station(
      id: 2,
      getTitle: (l) => l.station2Title,
      imagePath: 'assets/images/wedding.jpg',
      status: StationStatus.unlocked, // As per the design
    ),
    Station(
      id: 3,
      getTitle: (l) => l.station3Title,
      imagePath: 'assets/images/station_3_thumb.png',
      status: StationStatus.locked, // As per the design
    ),
    Station(
      id: 4,
      getTitle: (l) => l.station4Title,
      imagePath: 'assets/images/chatting.jpg',
      status: StationStatus.locked, // As per the design
    ),
    Station(
      id: 5,
      getTitle: (l) => l.station5Title,
      imagePath: 'assets/images/reveal.jpg',
      status: StationStatus.locked, // As per the design
    ),

    Station(
      id: 6,
      getTitle: (l) => l.station6Title,
      imagePath: 'assets/images/station_cards/station_6.png', // This path is a placeholder
      status: StationStatus.unlocked,
    ),
  ];
});
