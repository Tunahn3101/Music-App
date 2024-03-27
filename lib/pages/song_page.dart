import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/new_box.dart';
import '../models/playlist_provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  // convert duratin into min:sec
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  bool isFavorite = false; // Trạng thái cục bộ cho nút yêu thích

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist
        final playlist = value.playlist;
        // get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        //return scaffold UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text('P L A Y L I S T'),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  NewBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            currentSong.albumArtImagePath,
                            width: 400,
                            height: 300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  isFavorite = !isFavorite;
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //start time
                            Text(formatTime(value.currentDuration)),
                            // shuffle icon
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.shuffle)),
                            // repeat icon

                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.repeat)),
                            // endd time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 1)),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (double double) {
                            // during when the user is sliding around
                          },
                          onChangeEnd: (double double) {
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: const NewBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NewBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NewBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
