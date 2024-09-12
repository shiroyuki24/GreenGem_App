import 'package:flutter/material.dart';
import 'package:gg_app/models/plants.dart';
import 'package:gg_app/screens/video_screen.dart';

class PlantScreen extends StatefulWidget {
  final Plant plant;
  final bool isEnglish;

  // Corrected constructor definition
  PlantScreen({required this.plant, required this.isEnglish});

  @override
  _PlantScreenState createState() => _PlantScreenState();
}

enum ContentState {
  description,
  usesAndBenefits,
  process,
}

class _PlantScreenState extends State<PlantScreen> {
  ContentState _contentState = ContentState.description;
  ContentState _previousState = ContentState.description;
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _nextState() {
    setState(() {
      if (_contentState == ContentState.description) {
        _previousState = _contentState;
        _contentState = ContentState.usesAndBenefits;
      } else if (_contentState == ContentState.usesAndBenefits) {
        _previousState = _contentState;
        _contentState = ContentState.process;
      }
      _scrollToTop();
    });
  }

  void _processState() {
    setState(() {
      _previousState = _contentState;
      _contentState = ContentState.process;
      _scrollToTop();
    });
  }

  void _previousStateFunction() {
    setState(() {
      if (_contentState == ContentState.process) {
        _contentState = _previousState;
      } else if (_contentState == ContentState.usesAndBenefits) {
        _contentState = ContentState.description;
      } else {
        Navigator.pop(context);
      }
      _scrollToTop();
    });
  }

  String getTextContent() {
    switch (_contentState) {
      case ContentState.description:
        return widget.isEnglish
            ? widget.plant.description
            : widget.plant.tag_description;
      case ContentState.usesAndBenefits:
        return widget.isEnglish ? widget.plant.uses : widget.plant.tag_uses;
      case ContentState.process:
        return widget.isEnglish
            ? widget.plant.process
            : widget.plant.tag_process;
      default:
        return '';
    }
  }

  String getBenefits() {
    if (_contentState == ContentState.usesAndBenefits) {
      return widget.isEnglish
          ? widget.plant.benefits
          : widget.plant.tag_benefits;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Hero(
              tag: widget.plant.image_path,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.plant.image_path),
                    fit: BoxFit.scaleDown,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Color(0xFFF5EFE6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: _previousStateFunction,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.isEnglish
                              ? widget.plant.eng_name
                              : widget.plant.tag_name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              _contentState == ContentState.description
                                  ? (widget.isEnglish
                                      ? 'Description'
                                      : 'Paglalarawan')
                                  : _contentState ==
                                          ContentState.usesAndBenefits
                                      ? (widget.isEnglish
                                          ? 'Uses & Benefits'
                                          : 'Mga Paggamit at Benepisyo')
                                      : (widget.isEnglish
                                          ? 'Process'
                                          : 'Proseso'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            if (_contentState == ContentState.description)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    widget.isEnglish
                                        ? 'Tagalog name: ${widget.plant.tag_name}'
                                        : 'English name: ${widget.plant.eng_name}',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Scientific name: ${widget.plant.sci_name}',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    getTextContent(),
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontFamily: 'Karla',
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            if (_contentState == ContentState.usesAndBenefits)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    getTextContent(),
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontFamily: 'Karla',
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    widget.isEnglish
                                        ? 'Benefits'
                                        : 'Mga Benepisyo',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    getBenefits(),
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontFamily: 'Karla',
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            if (_contentState == ContentState.process)
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.50, // 50% of the screen width
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                            plant: widget.plant,
                                            isEnglish: widget.isEnglish,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 16),
                                      shadowColor:
                                          Colors.black.withOpacity(0.3),
                                      elevation: 5,
                                    ),
                                    child: Text(
                                      widget.isEnglish
                                          ? 'View Video'
                                          : 'Tignan ang Video',
                                      style: TextStyle(
                                        fontFamily: 'Karla',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign
                                          .center, // Center text within button
                                    ),
                                  ),
                                ),
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  getTextContent(),
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontFamily: 'Karla',
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            if (_contentState != ContentState.process)
                              Column(
                                children: [
                                  if (_contentState == ContentState.description)
                                    Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85, // 85% of the screen width
                                        child: ElevatedButton(
                                          onPressed: _nextState,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 32, vertical: 16),
                                            shadowColor:
                                                Colors.black.withOpacity(0.3),
                                            elevation: 5,
                                          ),
                                          child: Text(
                                            widget.isEnglish
                                                ? 'Uses & Benefits'
                                                : 'Mga Paggamit at Benepisyo',
                                            style: TextStyle(
                                              fontFamily: 'Karla',
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign
                                                .center, // Center text within button
                                          ),
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85, // 85% of the screen width
                                      child: ElevatedButton(
                                        onPressed: _processState,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 32, vertical: 16),
                                          shadowColor:
                                              Colors.black.withOpacity(0.3),
                                          elevation: 5,
                                        ),
                                        child: Text(
                                          widget.isEnglish
                                              ? 'Process'
                                              : 'Proseso',
                                          style: TextStyle(
                                            fontFamily: 'Karla',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign
                                              .center, // Center text within button
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                    ? 'Note: While GreenGem offers information on the potential health benefits of herbal plants, it is not a substitute for professional medical advice. Please consult healthcare professionals before using herbal remedies, especially if you have existing medical conditions or are taking medications.'
                                    : 'Tandaan: Habang nag-aalok ang GreenGem ng impormasyon tungkol sa mga potensyal na benepisyo sa kalusugan ng mga halamang halaman, hindi ito kapalit ng propesyonal na payong medikal. Mangyaring kumunsulta sa mga propesyonal sa pangangalagang pangkalusugan bago gumamit ng mga herbal na remedyo, lalo na kung mayroon kang mga kondisyong medikal o umiinom ng mga gamot.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
