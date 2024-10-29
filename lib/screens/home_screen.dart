import 'package:flutter/material.dart';
import 'package:gg_app/language_manager.dart';
import 'package:gg_app/models/plants.dart';
import 'package:gg_app/plant_data.dart';
import 'package:provider/provider.dart';
import 'plant_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'settings_screen.dart';
import 'plant_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Plant> displayedPlants = allPlants; // Default to all plants
  String selectedCategory = 'All plants'; // Default category
  TextEditingController searchController = TextEditingController();
  List<Plant> searchResults = [];

  void filterPlants(String category) {
    setState(() {
      selectedCategory = category;
      switch (category) {
        case 'All plants':
        case 'Lahat ng halaman':
          displayedPlants = allPlants;
          break;
        case 'Culinary Herbs':
        case 'Mga Pangluto na Halaman':
          displayedPlants = culinaryHerbs;
          break;
        case 'Herbal Teas':
        case 'Mga Tsaa ng Halamang-gamot':
          displayedPlants = herbalTeas;
          break;
        case 'Aromatic Oils':
        case 'Mga Aromatic na Langis':
          displayedPlants = aromaticOils;
          break;
      }
    });
  }

  void searchPlants(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults = allPlants.where((plant) {
          return plant.eng_name.toLowerCase().contains(query.toLowerCase()) ||
              plant.tag_name.toLowerCase().contains(query.toLowerCase()) ||
              plant.sci_name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void navigateToPlant(Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantScreen(
          plant: plant,
          isEnglish:
              Provider.of<LanguageManager>(context, listen: false).isEnglish,
        ),
      ),
    );
  }

  void navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  void navigateToPlantScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantScanner(
          isEnglish:
              Provider.of<LanguageManager>(context, listen: false).isEnglish,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight * 0.4,
                color: Colors.black,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 16.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${languageManager.welcomeText}\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      WidgetSpan(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Color(0xff205901), Color(0xff7bac31)],
                          ).createShader(bounds),
                          child: Text(
                            'GreenGem',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.1,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: searchPlants,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: languageManager.searchHint,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: screenWidth * 0.15,
                      width: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff205901), Color(0xff7bac31)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: navigateToSettings,
                        icon: SvgPicture.asset(
                          'assets/icons/settings-adjust-svgrepo-com.svg',
                          width: screenWidth * 0.07,
                          height: screenWidth * 0.07,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff205901), Color(0xff7bac31)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/scan-svgrepo-com.svg',
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                      ),
                      onPressed: navigateToPlantScanner,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: screenHeight * 0.06,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryButton(
                        label: languageManager.allPlants,
                        isSelected: selectedCategory == 'All plants' ||
                            selectedCategory == 'Lahat ng halaman',
                        onTap: filterPlants,
                      ),
                      CategoryButton(
                        label: languageManager.culinaryHerbs,
                        isSelected: selectedCategory == 'Culinary Herbs' ||
                            selectedCategory == 'Mga Pangluto na Halaman',
                        onTap: filterPlants,
                      ),
                      CategoryButton(
                        label: languageManager.herbalTeas,
                        isSelected: selectedCategory == 'Herbal Teas' ||
                            selectedCategory == 'Mga Tsaa ng Halamang-gamot',
                        onTap: filterPlants,
                      ),
                      CategoryButton(
                        label: languageManager.aromaticOils,
                        isSelected: selectedCategory == 'Aromatic Oils' ||
                            selectedCategory == 'Mga Aromatic na Langis',
                        onTap: filterPlants,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      return GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: displayedPlants.map((plant) {
                          return PlantCard(plant: plant);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (searchResults.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).padding.top + 200,
              left: 16,
              right: 16,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(searchResults[index].eng_name),
                        onTap: () {
                          navigateToPlant(searchResults[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(String) onTap;

  const CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected
              ? Colors.green
              : const Color.fromARGB(255, 224, 224, 224),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => onTap(label),
        child: Text(
          label,
          style: TextStyle(fontSize: screenWidth * 0.035),
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    bool isEnglish = languageManager.isEnglish;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantScreen(
              plant: plant,
              isEnglish: isEnglish,
            ),
          ),
        );
      },
      child: Card(
        color: Color(0xFFF5EFE6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.7),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: plant.image_path,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    plant.image_path,
                    fit: BoxFit.fitHeight,
                    width: double.infinity, // Full width for responsiveness
                    height: screenWidth * 0.3, // Adjust height proportionally
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02), // Dynamic padding
              child: Center(
                child: Text(
                  isEnglish ? plant.eng_name : plant.tag_name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // Responsive font size
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
