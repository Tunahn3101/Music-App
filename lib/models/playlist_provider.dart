import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    //Song1
    Song(
        songName: 'Die For You',
        artistName: 'The Weekend',
        albumArtImagePath: 'assets/images/the-weeknd-half-1.jpg',
        audioPath: 'audio/DieForYou.mp3'),
    //Song2
    Song(
        songName: 'One Of The Girl',
        artistName: 'The Weekend',
        albumArtImagePath: 'assets/images/the-weeknd-half-3.jpg',
        audioPath: 'audio/OneOfTheGirl.mp3'),
    //Song3
    Song(
        songName: 'Hu Khong',
        artistName: 'Kha',
        albumArtImagePath: 'assets/images/hukhong.jpg',
        audioPath: 'audio/Hu Khong.mp3')
  ];
  //current song playing index
  int? _currentSongIndex;

  //audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  //durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  //contructor
  PlaylistProvider() {
    listenToDuration();
  }
  //initialliy not playing
  bool _isPlaying = false;

  //play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); //  stoop curent song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause current soong
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }
  // seek to a specific position in the current song

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next soong
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        //go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if it's the last song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //listen to duration
  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen(
      (newDuration) {
        _totalDuration = newDuration;
        notifyListeners();
      },
    );
    //listen for current duration
    _audioPlayer.onPositionChanged.listen(
      (newPosition) {
        _currentDuration = newPosition;
        notifyListeners();
      },
    );
    //listen for song completion
    _audioPlayer.onPlayerComplete.listen(
      (event) {
        playNextSong();
      },
    );
  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    // Update current song index
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play(); // Phát nhạc ngay cả khi newIndex là null
    }
    notifyListeners();
  }
}
