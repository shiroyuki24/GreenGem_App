import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gg_app/language_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'dart:io';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _checkTermsAccepted();
  }

  Future<void> _checkTermsAccepted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool accepted = prefs.getBool('termsAccepted') ?? false;

    if (accepted) {
      setState(() {
        _termsAccepted = true;
      });
    } else {
      _showTermsDialog();
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TermsDialog(onAccept: _onTermsAccepted);
      },
    );
  }

  void _onTermsAccepted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('termsAccepted', true);
    setState(() {
      _termsAccepted = true;
    });
    Navigator.of(context).pop();
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Stack(
            children: [
              // Background image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Logo image
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.0005),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: screenWidth * 0.60,
                    height: screenHeight * 0.60,
                  ),
                ),
              ),
              // Center text
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    languageManager.isEnglish
                        ? 'Your Gateway to Herbal Wellness'
                        : 'Ang Iyong Gabay sa Herbal Wellness',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.04,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
              // Get Started button
              Column(
                children: [
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.10),
                      child: OutlinedButton(
                        onPressed: _termsAccepted ? _navigateToHomePage : null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.6),
                          side:
                              const BorderSide(color: Colors.white, width: 2.0),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.15,
                            vertical: screenHeight * 0.012,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          languageManager.isEnglish
                              ? 'Get Started'
                              : 'Magsimula',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class TermsDialog extends StatefulWidget {
  final VoidCallback onAccept;

  const TermsDialog({required this.onAccept});

  @override
  _TermsDialogState createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);

    return AlertDialog(
      title: Text(
        languageManager.isEnglish
            ? 'Terms & Conditions'
            : 'Mga Tuntunin at Kundisyon',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontFamily: 'Karla', color: Colors.black),
                children: [
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'Please read the Terms & Conditions thoroughly.\n\nScroll down to accept\n\n'
                        : 'Mangyaring basahin nang maigi ang Mga Tuntunin at Kundisyon.\n\nMag-scroll pababa upang tanggapin\n\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? '1. Introduction\n'
                        : '1. Panimula\n',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'Welcome to GreenGem, your ultimate herbal companion app. These terms and conditions govern your use of the GreenGem mobile application. By accessing or using the app, you agree to comply with these terms.\n\n'
                        : 'Maligayang pagdating sa GreenGem, ang iyong pangunahing herbal na kasama app. Ang mga tuntunin at kundisyong ito ay namamahala sa iyong paggamit ng GreenGem mobile application. Sa pamamagitan ng pag-access o paggamit ng app, sumasang-ayon kang sumunod sa mga tuntuning ito.\n\n',
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? '2. Content and Information\n'
                        : '2. Nilalaman at Impormasyon\n',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'The content provided in the GreenGem app, including, articles, tutorials, images, and videos, is for informational purposes only.\n\nWe strive to ensure the accuracy and reliability of the information provided in the app. However, we do not guarantee the completeness or correctness of any content.\n\nPlant information and recommendations are based on research and expert knowledge. Users should exercise their judgment and consider local conditions when applying any advice provided in the app.\n\nThe GreenGem app does not constitute medical advice, and we disclaim any liability for any loss or damage arising from the use of the information provided in the app. Users are encouraged to exercise caution and seek professional medical guidance when making decisions about their health and wellness.\n\n'
                        : 'Ang nilalaman na ibinigay sa GreenGem app, kabilang ang mga artikulo, tutorial, larawan, at video, ay para sa mga layuning pang-impormasyon lamang.\n\nNagsusumikap kaming tiyakin ang kawastuhan at pagiging maaasahan ng impormasyong ibinigay sa app. Gayunpaman, hindi namin ginagarantiyahan ang pagkakumpleto o pagkakabisa ng anumang nilalaman.\n\nAng impormasyon at rekomendasyon ng halaman ay batay sa pananaliksik at kaalamang eksperto. Dapat gamitin ng mga user ang kanilang paghatol at isaalang-alang ang mga lokal na kundisyon kapag inilalapat ang anumang payo na ibinigay sa app.\n\nAng GreenGem app ay hindi bumubuo ng medikal na payo, at itinanggi namin ang anumang pananagutan para sa anumang pagkawala o pinsala na nagmumula sa paggamit ng impormasyong ibinigay sa app. Ang mga user ay hinihikayat na mag-ingat at humingi ng gabay medikal na propesyonal kapag gumagawa ng mga desisyon tungkol sa kanilang kalusugan at kagalingan.\n\n',
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? '3. Usage Restrictions\n'
                        : '3. Mga Paghihigpit sa Paggamit\n',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'You agree not to misuse the GreenGem app or use it for any unlawful purpose.\n\nYou may not modify, adapt, sublicense, translate, sell, or exploit any part of the app without our prior written consent.\n\n'
                        : 'Sumasang-ayon kang hindi i-misuse ang GreenGem app o gamitin ito para sa anumang labag sa batas na layunin.\n\nHindi mo maaaring baguhin, iangkop, i-sublicense, isalin, ibenta, o samantalahin ang anumang bahagi ng app nang walang aming paunang nakasulat na pahintulot.\n\n',
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? '4. Privacy Policy\n'
                        : '4. Patakaran sa Privacy\n',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'The GreenGem App does not collect, store, or use any personal information from its users. As our App does not require user accounts, we do not collect names, addresses, phone numbers, email addresses, or any other personally identifiable information.\n\n'
                        : 'Ang GreenGem App ay hindi nangongolekta, nag-iimbak, o gumagamit ng anumang personal na impormasyon mula sa mga gumagamit nito. Dahil hindi nangangailangan ang aming App ng mga user account, hindi kami nangongolekta ng mga pangalan, address, numero ng telepono, email address, o anumang iba pang impormasyong nagbibigay ng personal na pagkakakilanlan.\n\n',
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? '5. Termination\n'
                        : '5. Termination\n',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'We reserve the right to suspend or terminate your access to the GreenGem app at any time, without prior notice or liability, for any reason.\n\n'
                        : 'Inilalaan namin ang karapatang suspindihin o wakasan ang iyong pag-access sa GreenGem app anumang oras, nang walang paunang abiso o pananagutan, para sa anumang kadahilanan.\n\n',
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? '6. Changes to Terms\n'
                        : '6. Mga Pagbabago sa Mga Tuntunin\n',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'We may update or revise these terms and conditions from time to time. The revised version will be effective upon posting on the app. Your continued use of the GreenGem app after any changes constitutes acceptance of those changes.\n\n'
                        : 'Maaari naming i-update o baguhin ang mga tuntunin at kundisyon na ito paminsan-minsan. Magiging epektibo ang binagong bersyon sa pag-post sa app. Ang iyong patuloy na paggamit ng GreenGem app pagkatapos ng anumang mga pagbabago ay bumubuo ng pagtanggap sa mga pagbabagong iyon.\n\n',
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? '7. Contact Us\n'
                        : '7. Makipag-ugnay sa amin\n',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: languageManager.isEnglish
                        ? 'If you have any questions or concerns about these terms, please contact us at greengemapp@gmail.com.\n\n'
                        : 'Kung mayroon kang anumang mga katanungan o alalahanin tungkol sa mga tuntuning ito, mangyaring makipag-ugnay sa amin sa greengemapp@gmail.com.\n\n',
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text(languageManager.isEnglish
                  ? 'I accept the Terms & Conditions'
                  : 'Tinatanggap ko ang Mga Tuntunin at Kundisyon'),
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Decline'),
          onPressed: () {
            Navigator.of(context).pop();
            _closeApp();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
            textStyle: const TextStyle(fontFamily: 'Montserrat'),
          ),
        ),
        ElevatedButton(
          onPressed: _isChecked ? widget.onAccept : null,
          child: Text(languageManager.isEnglish ? 'Accept' : 'Tanggapin'),
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontFamily: 'Montserrat'),
            disabledForegroundColor: Colors.white.withOpacity(0.50),
            disabledBackgroundColor: Colors.grey.withOpacity(0.50),
            foregroundColor: Colors.white,
            backgroundColor: _isChecked ? Colors.green : null,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0, // Remove shadow
          ),
        ),
      ],
    );
  }

  void _closeApp() {
    SystemNavigator.pop();
  }
}
