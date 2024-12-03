import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gg_app/screens/plant_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gg_app/models/plants.dart';

class PlantScanner extends StatefulWidget {
  final bool isEnglish;

  const PlantScanner({super.key, required this.isEnglish});

  @override
  State<PlantScanner> createState() => _PlantScannerState();
}

class _PlantScannerState extends State<PlantScanner> {
  bool _loading = false;
  File? _image;
  List? _output = [];
  final picker = ImagePicker();
  bool _isModelRunning = false;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/model/model.tflite',
        labels: 'assets/model/labels.txt',
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> classifyImage(File image) async {
    if (_isModelRunning) return;

    setState(() {
      _isModelRunning = true;
      _loading = true;
    });

    try {
      // Show the scanning animation
      await Future.delayed(const Duration(seconds: 1));

      var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 5,
        threshold: 0.95, // Increased threshold for better accuracy
        asynch: true,
      );

      if (output != null && output.isNotEmpty) {
        bool isPlantDetected = output.any(
            (result) => result['confidence'] > 0.95); // Match the threshold

        if (isPlantDetected) {
          setState(() {
            _output = output;
            _showResultDialog(output);
          });
        } else {
          _showNotFoundDialog();
        }
      } else {
        _showNotFoundDialog();
      }
    } catch (e) {
      print('Error running model: $e');
    } finally {
      setState(() {
        _loading = false;
        _isModelRunning = false;
      });
    }
  }

  void _showResultDialog(List output) {
    String plantLabel = output.first['label'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.isEnglish ? 'Plant Found' : 'Halaman Natagpuan',
          ),
          content: Text(
            widget.isEnglish ? plantLabel : _getTagalogLabel(plantLabel),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                  widget.isEnglish ? 'View Details' : 'Tingnan ang Detalye'),
              onPressed: () {
                Plant? plant = _getPlantByEnglishName(plantLabel);
                if (plant != null) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlantScreen(
                        plant: plant,
                        isEnglish: widget.isEnglish,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text(widget.isEnglish ? 'Close' : 'Isara'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.isEnglish ? 'Not Found' : 'Hindi Natagpuan'),
          content: Text(
            widget.isEnglish
                ? 'The plant could not be identified.'
                : 'Hindi matukoy ang halaman.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text(widget.isEnglish ? 'Close' : 'Isara'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Plant? _getPlantByEnglishName(String name) {
    var plantsBox = Hive.box<Plant>('plant_box');
    return plantsBox.values.firstWhere(
      (plant) => plant.eng_name.toLowerCase() == name.toLowerCase(),
    );
  }

  String _getTagalogLabel(String englishLabel) {
    return englishLabel;
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
      _loading = true;
    });

    classifyImage(_image!);
  }

  Future<void> pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
      _loading = true;
    });

    classifyImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight * 0.10,
                color: Colors.black,
              ),
              Container(
                height: screenHeight * 0.90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16.0,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.isEnglish
                              ? 'Plant Scanner'
                              : 'Tagasuri ng Halaman',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Center(
                  child: !_loading && _image == null
                      ? Image.asset(
                          'assets/images/logo.png',
                          width: screenWidth * 0.6,
                        )
                      : _loading
                          ? Column(
                              children: [
                                const CircularProgressIndicator(),
                                SizedBox(height: screenHeight * 0.02),
                                Text(
                                  widget.isEnglish
                                      ? 'Scanning...'
                                      : 'Nagsusuri...',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  height: screenHeight * 0.3,
                                  child: _image != null
                                      ? Image.file(_image!)
                                      : Container(),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _output != null && _output!.isNotEmpty
                                    ? Column(
                                        children: _output!.map((result) {
                                          return Text(
                                            result['label'],
                                            style: TextStyle(
                                              color: Colors.green[800],
                                              fontSize: screenWidth * 0.05,
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : Container(),
                              ],
                            ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: screenWidth - 150,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff205901),
                              Color(0xff7bac31),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Text(
                          widget.isEnglish
                              ? 'Take a Photo'
                              : 'Kumuha ng Larawan',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontFamily: 'Karla'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: pickGalleryImage,
                      child: Container(
                        width: screenWidth - 150,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff205901),
                              Color(0xff7bac31),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Text(
                          widget.isEnglish
                              ? 'Choose from Gallery'
                              : 'Pumili mula sa Gallery',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontFamily: 'Karla'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5EFE6),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                widget.isEnglish
                    ? 'Note: The plant scanner is a helpful tool, but it\'s important to remember that it\'s not always 100% accurate. To achieve the best results, ensure that the plant is well-lit and the background is simple and contrasting to make the plant stand out. Keep the camera steady and focused on the plant, capturing clear views of its key features. If the first scan isn\'t accurate, try scanning the plant again from a different angle or with improved lighting. Always cross-check the results with reliable sources to confirm the plant\'s identification.'
                    : 'Tandaan: Habang nag-aalok ang GreenGem ng impormasyon tungkol sa mga potensyal na benepisyo sa kalusugan ng mga halamang halaman, hindi ito kapalit ng propesyonal na payong medikal. Mangyaring kumunsulta sa mga propesyonal sa pangangalagang pangkalusugan bago gumamit ng mga herbal na remedyo, lalo na kung mayroon kang mga kondisyong medikal o umiinom ng mga gamot.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
