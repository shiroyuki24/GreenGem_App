import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gg_app/models/plants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:volume_watcher/volume_watcher.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Plant plant;
  final bool isEnglish;

  const VideoPlayerScreen(
      {super.key, required this.plant, required this.isEnglish});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isConnected = false;
  double _volume = 100;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initializeVolumeWatcher();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
      if (_isConnected) {
        _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(widget.plant.video_url)!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            isLive: false,
          ),
        );

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    });
  }

  Future<void> _initializeVolumeWatcher() async {
    // Get the initial volume
    _volume = await VolumeWatcher.getCurrentVolume;

    VolumeWatcher.addListener((volume) {
      setState(() {
        _volume = volume;
        _controller
            .setVolume((_volume * 100).round()); // Sync to YouTube volume
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_controller.value.isFullScreen) {
      _controller.toggleFullScreenMode();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: _isConnected
                  ? YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressColors: ProgressBarColors(
                          playedColor: Colors.green,
                          handleColor: Colors.greenAccent,
                        ),
                        onReady: () {
                          _controller.addListener(() {});
                        },
                      ),
                      builder: (context, player) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            player,
                            SizedBox(height: 10),
                            _buildVolumeControl(),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No internet connection. Please connect to the internet to play the video.',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            Positioned(
              top: 15,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  if (await _onWillPop()) {
                    Navigator.pop(context, widget.plant);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(_volume == 0 ? Icons.volume_off : Icons.volume_up),
          onPressed: () {
            setState(() {
              _volume = _volume == 0 ? 1.0 : 0.0; // Toggle volume
              _controller.setVolume((_volume * 100).round());
            });
          },
        ),
        Expanded(
          child: Slider(
            value: _volume,
            min: 0,
            max: 1,
            divisions: 100,
            label: (_volume * 100).round().toString(),
            activeColor: Colors.green,
            inactiveColor: Colors.green.withOpacity(0.5),
            onChanged: (value) {
              setState(() {
                _volume = value;
                _controller.setVolume((_volume * 100).round());
                VolumeWatcher.setVolume(value); // Update system volume
              });
            },
          ),
        ),
      ],
    );
  }
}
