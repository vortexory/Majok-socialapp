import 'package:audioplayers/audioplayers.dart';

// An enum to represent our sound effects with clear, semantic names.
enum Sound {
  // For all simple taps and selections.
  tap('Tap.mp3'),
  
  // For navigating between screens or major UI changes.
  transition('Tap.mp3'),
  
  // For general result/reveal screens (Stations 1, 2, 3).
  generalReveal('file.mp3'),

  // For the special, final soulmate reveal in Station 5.
  finalReveal('Soulmate reveal final.mp3');

  final String fileName;
  const Sound(this.fileName);
}

// A singleton service to manage our audio player instance.
class AudioService {
  // Private constructor
  AudioService._();

  // The single, static instance of the service
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();

  // Simple method to play a sound effect.
  void play(Sound sound) {
    _player.play(AssetSource('audio/${sound.fileName}'));
  }
}