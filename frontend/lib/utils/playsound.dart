import 'package:just_audio/just_audio.dart';

AudioPlayer player = AudioPlayer();


Future audioPlayer() async {
  await player.setVolume(100);
  await player.setSpeed(1);
  await player.setAsset("assets/audio/bird.mp3");
  player.play();
}