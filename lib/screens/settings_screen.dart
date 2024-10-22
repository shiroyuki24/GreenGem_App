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
                height: MediaQuery.of(context).size.height * 0.13,
                color: Colors.black,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.87,
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
                              ? 'While GreenGem offers information on the potential health benefits of herbal plants, it is not a substitute for professional medical advice. Please consult healthcare professionals before using herbal remedies, especially if you have existing medical conditions or are taking medications.'
                              : 'Habang nag-aalok ang GreenGem ng impormasyon sa mga potensyal na benepisyo sa kalusugan ng mga halamang herbal, hindi ito kapalit ng propesyonal na payong medikal. Mangyaring kumunsulta sa mga propesyonal sa pangangalagang pangkalusugan bago gumamit ng mga herbal na remedyo, lalo na kung mayroon kang mga kondisyong medikal o umiinom ng mga gamot.',
                          languageManager.isEnglish,
                        ),
                      ),
                      _buildSettingsButton(
                        context,
                        languageManager.isEnglish ? 'About' : 'Tungkol sa amin',
                        () => _showDialog(
                          context,
                          languageManager.isEnglish
                              ? 'About'
                              : 'Tungkol sa amin',
                          languageManager.isEnglish
                              ? 'GreenGem is the ultimate destination for herbal plant enthusiasts, offering valuable insights into the diverse world of botanical wonders. Our platform provides detailed information on various herbs, empowering users to explore their properties and applications with confidence. Join us on a journey to holistic wellness and reconnect with nature\'s healing power. Contact us for inquiries or feedback.'
                              : 'Ang GreenGem ay ang pinakahuling destinasyon para sa mga mahilig sa herbal na halaman, na nag-aalok ng mahahalagang insight sa magkakaibang mundo ng botanical wonders. Ang aming platform ay nagbibigay ng detalyadong impormasyon sa iba\'t ibang mga halamang gamot, na nagbibigay ng kapangyarihan sa mga user na galugarin ang kanilang mga ari-arian at mga aplikasyon nang may kumpiyansa. Samahan kami sa isang paglalakbay tungo sa holistic wellness at muling kumonekta sa nakapagpapagaling na kapangyarihan ng kalikasan. Makipag-ugnayan sa amin para sa mga katanungan o feedback.',
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

        1. Introduction: Welcome to GreenGem, your ultimate herbal companion app. These terms and conditions govern your use of the GreenGem mobile application. By accessing or using the app, you agree to comply with these terms.

        2. Content and Information: The content provided in the GreenGem app, including, articles, tutorials, images, and videos, is for informational purposes only.\n\nWe strive to ensure the accuracy and reliability of the information provided in the app. However, we do not guarantee the completeness or correctness of any content.\n\nPlant information and recommendations are based on research and expert knowledge. Users should exercise their judgment and consider local conditions when applying any advice provided in the app.\n\nThe GreenGem app does not constitute medical advice, and we disclaim any liability for any loss or damage arising from the use of the information provided in the app. Users are encouraged to exercise caution and seek professional medical guidance when making decisions about their health and wellness.\n\n'

        3. Usage Restrictions: You agree not to misuse the GreenGem app or use it for any unlawful purpose.\n\nYou may not modify, adapt, sublicense, translate, sell, or exploit any part of the app without our prior written consent.

        4. Privacy Policy: The GreenGem App does not collect, store, or use any personal information from its users. As our App does not require user accounts, we do not collect names, addresses, phone numbers, email addresses, or any other personally identifiable information.

        5. Termination: We reserve the right to suspend or terminate your access to the GreenGem app at any time, without prior notice or liability, for any reason.

        6. Changes to Terms: We may update or revise these terms and conditions from time to time. The revised version will be effective upon posting on the app. Your continued use of the GreenGem app after any changes constitutes acceptance of those changes.

        7. Contact Us: If you have any questions or concerns about these terms, please contact us at greengemapp@gmail.com.
        '''
        : '''
        Maligayang pagdating sa GreenGem! Sa pamamagitan ng pag-access at paggamit sa aming app, sumasang-ayon ka sa mga sumusunod na tuntunin at kundisyon:

        1. Panimula: Maligayang pagdating sa GreenGem, ang iyong pinakamahusay na kasamang herbal na app. Ang mga tuntunin at kundisyon na ito ay namamahala sa iyong paggamit ng GreenGem mobile application. Sa pamamagitan ng pag-access o paggamit sa app, sumasang-ayon kang sumunod sa mga tuntuning ito.

        2. Nilalaman at Impormasyon: Ang nilalamang ibinigay sa GreenGem app, kabilang ang, mga artikulo, tutorial, larawan, at video, ay para sa mga layuning pang-impormasyon lamang.\n\nSinisikap naming tiyakin ang katumpakan at pagiging maaasahan ng impormasyong ibinigay sa app. Gayunpaman, hindi namin ginagarantiya ang pagiging kumpleto o kawastuhan ng anumang nilalaman.\n\nAng impormasyon at rekomendasyon ng halaman ay batay sa pananaliksik at kaalaman ng eksperto. Dapat gamitin ng mga user ang kanilang paghuhusga at isaalang-alang ang mga lokal na kundisyon kapag nag-aaplay ng anumang payo na ibinigay sa app.\n\nAng GreenGem app ay hindi bumubuo ng medikal na payo, at itinatanggi namin ang anumang pananagutan para sa anumang pagkawala o pinsalang dulot ng paggamit ng impormasyong ibinigay sa app. Hinihikayat ang mga user na mag-ingat at humingi ng propesyonal na medikal na patnubay kapag gumagawa ng mga desisyon tungkol sa kanilang kalusugan at kagalingan.\n\n'

        3. Mga Paghihigpit sa Paggamit: Sumasang-ayon kang huwag gamitin sa maling paraan ang GreenGem app o gamitin ito para sa anumang labag sa batas na layunin.\n\nHindi mo maaaring baguhin, iakma, i-sublicense, isalin, ibenta, o pagsamantalahan ang anumang bahagi ng app nang wala ang aming paunang nakasulat na pahintulot.

        4. Patakaran sa Privacy: Ang GreenGem App ay hindi nangongolekta, nag-iimbak, o gumagamit ng anumang personal na impormasyon mula sa mga gumagamit nito. Dahil hindi nangangailangan ang aming App ng mga user account, hindi kami nangongolekta ng mga pangalan, address, numero ng telepono, email address, o anumang iba pang impormasyong nagbibigay ng personal na pagkakakilanlan.

        5. Pagwawakas: Inilalaan namin ang karapatang suspindihin o wakasan ang iyong pag-access sa GreenGem app anumang oras, nang walang paunang abiso o pananagutan, para sa anumang kadahilanan.

        6. Mga Pagbabago sa Mga Tuntunin: Maaari naming i-update o baguhin ang mga tuntunin at kundisyon na ito paminsan-minsan. Magiging epektibo ang binagong bersyon sa pag-post sa app. Ang iyong patuloy na paggamit ng GreenGem app pagkatapos ng anumang mga pagbabago ay bumubuo ng pagtanggap sa mga pagbabagong iyon.

        7. Makipag-ugnayan sa Amin: Kung mayroon kang anumang mga tanong o alalahanin tungkol sa mga tuntuning ito, mangyaring makipag-ugnayan sa amin sa greengemapp@gmail.com.
        ''';
  }
}
