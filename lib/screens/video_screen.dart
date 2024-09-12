import 'package:flutter/material.dart';
import 'package:gg_app/models/plants.dart';
import 'package:gg_app/screens/plant_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  double _previousVolume = 100;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
      if (_isConnected) {
        _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(widget.plant.video_url)!,
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            isLive: false,
          ),
        );
      }
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
      return Future.value(
          false); // Prevents popping the screen when exiting fullscreen
    } else {
      return Future.value(
          true); // Allows popping the screen when not in fullscreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.plant.eng_name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => PlantScreen(
                      plant: widget.plant,
                      isEnglish: widget.isEnglish,
                    ),
                  ),
                );
              }
            },
          ),
          backgroundColor: Colors.green,
        ),
        body: Center(
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
              if (_volume == 0) {
                _volume = _previousVolume;
                _controller.setVolume(_volume.round());
              } else {
                _previousVolume = _volume;
                _volume = 0;
                _controller.setVolume(_volume.round());
              }
            });
          },
        ),
        Expanded(
          child: Slider(
            value: _volume,
            min: 0,
            max: 100,
            divisions: 100,
            label: _volume.round().toString(),
            activeColor: Colors.green,
            inactiveColor: Colors.green.withOpacity(0.5),
            onChanged: (value) {
              setState(() {
                _volume = value;
                _controller.setVolume(_volume.round());
              });
            },
          ),
        ),
      ],
    );
  }
}
