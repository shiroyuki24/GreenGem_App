import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gg_app/language_manager.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                color: Colors.black,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.83,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
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
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            languageManager.isEnglish
                                ? 'Settings'
                                : 'Mga Setting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSettingsButton(context,
                          languageManager.isEnglish ? 'Language' : 'Wika', () {
                        _showLanguageDialog(context, languageManager.isEnglish);
                      }),
                      _buildSettingsButton(
                        context,
                        languageManager.isEnglish
                            ? 'Terms & Conditions'
                            : 'Mga Tuntunin at Kundisyon',
                        () => _showDialog(
                          context,
                          languageManager.isEnglish
                              ? 'Terms and Conditions'
                              : 'Mga Tuntunin at Kundisyon',
                          _termsContent(languageManager.isEnglish),
                          languageManager.isEnglish,
                        ),
                      ),
                      _buildSettingsButton(
                        context,
                        'Disclaimer',
                        () => _showDialog(
                          context,
                          'Disclaimer',
                          languageManager.isEnglish
                              ? 'The GreenGem Mobile app provides herbal plant information for informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Users are encouraged to consult a healthcare provider before using any herbal remedies, particularly if they have health conditions, allergies, or are taking medications, as herbal treatments may interact with medications.The app does not endorse specific remedies, and the use of its content is at the user\'s own risk. GreenGem disclaims any liability for loss or damage resulting from the use of its information. By using the app, users acknowledge that it is not medical advice and agree to seek professional guidance for any health concerns.	'
                              : 'Ang GreenGem Mobile app ay nagbibigay ng impormasyon tungkol sa mga halamang gamot para sa layuning pang-impormasyon lamang at hindi kapalit ng propesyonal na payo, diagnosis, o paggamot medikal. Hinihikayat ang mga gumagamit na kumonsulta sa isang healthcare provider bago gumamit ng anumang halamang gamot, lalo na kung may mga kondisyong medikal, allergy, o umiinom ng mga gamot, dahil maaaring magkaruon ng interaksyon ang mga halamang gamot sa mga gamot. Hindi nire-rekomenda ng app ang mga partikular na remedyo, at ang paggamit ng nilalaman nito ay nasa sariling panganib ng gumagamit. Ang GreenGem ay hindi mananagot para sa anumang pagkawala o pinsala na dulot ng paggamit ng mga impormasyon nito. Sa paggamit ng app, kinikilala ng mga gumagamit na hindi ito isang medikal na payo at pumapayag silang kumonsulta sa mga propesyonal para sa anumang alalahanin sa kalusugan.',
                          languageManager.isEnglish,
                        ),
                      ),
                      _buildSettingsButton(
                        context,
                        languageManager.isEnglish ? 'About' : 'Tungkol sa app',
                        () => _showDialog(
                          context,
                          languageManager.isEnglish
                              ? 'About'
                              : 'Tungkol sa app',
                          languageManager.isEnglish
                              ? 'GreenGem is the ultimate destination for herbal plant enthusiasts, offering valuable insights into the diverse world of botanical wonders. Our platform provides detailed information on various herbs, empowering users to explore their properties and applications with confidence.Join us on a journey to holistic wellness and reconnect with nature\'s healing power. Contact us for inquiries or feedback.'
                              : 'Ang GreenGem ay ang pangunahing destinasyon para sa mga mahilig sa halamang gamot, na nag-aalok ng mahalagang kaalaman tungkol sa iba\'t ibang uri ng mga halaman. Ang aming platform ay nagbibigay ng detalyadong impormasyon tungkol sa iba\'t ibang halamang gamot, na nagbibigay-kakayahan sa mga gumagamit na tuklasin ang kanilang mga katangian at gamit nang may kumpiyansa. Samahan kami sa isang paglalakbay patungo sa holistic na kalusugan at muling makipag-ugnayan sa nakapagpapagaling na lakas ng kalikasan. Makipag-ugnayan sa amin para sa mga katanungan o Feedback.',
                          languageManager.isEnglish,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, String label,
      [VoidCallback? onTap]) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff205901), Color(0xff7bac31)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, bool isEnglish) {
    bool selectedLanguage = isEnglish;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Text(
                  isEnglish ? 'Select Language' : 'Piliin ang Wika',
                  textAlign: TextAlign.center, // Move this out of TextStyle
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('English',
                          style: TextStyle(fontFamily: 'Karla', fontSize: 20)),
                      leading: Radio<bool>(
                        value: true,
                        groupValue: selectedLanguage,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Tagalog',
                          style: TextStyle(fontFamily: 'Karla', fontSize: 20)),
                      leading: Radio<bool>(
                        value: false,
                        groupValue: selectedLanguage,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        isEnglish ? 'Close' : 'Isara',
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10), // Optional spacing between buttons
                    TextButton(
                      child: Text(
                        isEnglish ? 'Apply' : 'Gamitin',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _confirmLanguageChange(
                            context, selectedLanguage, isEnglish);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmLanguageChange(
      BuildContext context, bool selectedLanguage, bool currentLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.all(10.0),
            child: Text(
              currentLanguage
                  ? 'Confirm Language Change'
                  : 'Kumpirmahin ang Pagbabago ng Wika',
              style: TextStyle(fontFamily: 'Karla'),
            ),
          ),
          content: Text(
            currentLanguage
                ? 'Are you sure you want to change the language?'
                : 'Sigurado ka bang gusto mong baguhin ang wika?',
            style: TextStyle(fontFamily: 'Karla'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                currentLanguage ? 'Cancel' : 'Ikansela',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
              ),
            ),
            TextButton(
              child: Text(
                currentLanguage ? 'Yes' : 'Oo',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<LanguageManager>().setLanguage(selectedLanguage);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(
    BuildContext context,
    String title,
    String content,
    bool isEnglish,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat', // Title font
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Karla', // Content font
                fontSize: 17,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                isEnglish ? 'Close' : 'Isara',
                style: TextStyle(
                  fontFamily: 'Montserrat', // Action button font
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  String _termsContent(bool isEnglish) {
    return isEnglish
        ? '''
        Welcome to GreenGem! By accessing and using our app, you agree to the following terms and conditions:

        1. Introduction
        By using the GreenGem app, users agree to comply with these terms and conditions.

        2. Content and Information
        GreenGem provides various modules for users to explore herbal plant information. The app offers a range of educational tools, including articles, tutorials, and videos. However, the app does not guarantee the accuracy or completeness of the content. It is intended for informational purposes only, and users should seek professional medical advice when necessary.

        3. Usage Restrictions
        Users agree not to misuse the app or use it for unlawful purposes. Modification, adaptation, sublicensing, or exploitation of any part of the app without prior written consent is prohibited.

        4. Privacy Policy
        GreenGem does not collect, store, or use any personal information.

        5. Termination
        GreenGem reserves the right to suspend or terminate access to the app at any time, without prior notice or liability.

        6. Changes to Terms
        GreenGem may update these terms. Continued use of the app after changes constitutes acceptance of the updated terms.
        
        7. Contact Us
        For questions or concerns, contact GreenGem at greengem.0000@gmail.com
        '''
        : '''
        Maligayang pagdating sa GreenGem! Sa pamamagitan ng pag-access at paggamit sa aming app, sumasang-ayon ka sa mga sumusunod na tuntunin at kundisyon:

        1. Panimula
        Sa paggamit ng GreenGem app, ang mga gumagamit ay sumasang-ayon na sumunod sa mga termino at kundisyon na ito.

        2. Nilalaman at Impormasyon
        Ang GreenGem ay nag-aalok ng iba't ibang mga module para sa mga gumagamit upang matutunan ang impormasyon tungkol sa mga halamang-gamot. Kasama sa app ang mga tool pang-edukasyon tulad ng mga artikulo, tutorial, at mga video. Gayunpaman, hindi ginagarantiyahan ng app ang katumpakan o kumpletong impormasyon ng nilalaman. Ang mga ito ay layunin lamang para sa impormasyon, at ang mga gumagamit ay dapat maghanap ng propesyonal na medikal na payo kung kinakailangan.

        3. Mga Pagbabawal sa Paggamit
        ng mga gumagamit ay sumasang-ayon na huwag gawing mali ang paggamit ng app o gamitin ito para sa mga labag sa batas na layunin. Ipinagbabawal ang pagbabago, adaptasyon, sublicensing, o pagpapakinabangan ng anumang bahagi ng app nang walang paunang nakasulat na pahintulot.

        4. Patakaran sa Privacy
        Ang GreenGem ay hindi nangongolekta, nag-iimbak, o gumagamit ng anumang personal na impormasyon.

        5. Pagwawakas
        May karapatan ang GreenGem na suspendihin o wakasan ang access sa app anumang oras, nang walang abiso o pananagutan.

        6. Mga Pagbabago sa mga Termino
        Maaaring baguhin ng GreenGem ang mga termino. Ang patuloy na paggamit ng app matapos ang mga pagbabago ay itinuturing na pagtanggap sa mga na-update na termino.

        7. Makipag-ugnayan sa Amin
        Para sa mga katanungan o alalahanin, maaaring makipag-ugnayan sa GreenGem sa greengem.0000@gmail.com
        ''';
  }
}
