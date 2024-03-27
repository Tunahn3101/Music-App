import 'package:flutter/material.dart';
import 'package:musicapp/components/my_drawer.dart';
import 'package:musicapp/models/playlist_provider.dart';
import 'package:musicapp/models/song.dart';
import 'package:musicapp/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get the playlist provider
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    // get the playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    //upgrade current song index
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'P L A Y L I S T',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(builder: (context, value, child) {
        final List<Song> playlist = value.playlist;
        return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              // get the playlist
              final Song song = playlist[index];
              // return list tile UI
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(
                  song.albumArtImagePath,
                  width: 50,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                onTap: () => goToSong(index),
              );
            });
      }),
    );
  }
}
