import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rendez_vous_hop/screens/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final int totalDots = 3;
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPageIndex < totalDots - 1) {
      setState(() {
        currentPageIndex++;
      });
      _pageController.animateToPage(currentPageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void previousPage() {
    if (currentPageIndex > 0) {
      setState(() {
        currentPageIndex--;
      });
      _pageController.animateToPage(currentPageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8, right: 8),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(Login());
                  },
                  child: Text(
                    "Sauter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                children: [
                  OnboardingPage(
                    image: "assets/images/onboarding_1.svg",
                    titre: "Découvrir des médecins expérimentés",
                    sousTitre:
                        "Trouvez les meilleurs médecins dans votre région",
                  ),
                  OnboardingPage(
                    image: "assets/images/onboarding_2.svg",
                    titre: "Prise de rendez-vous sans effort",
                    sousTitre:
                        "Programmez vos consultations médicales en un clin d'œil",
                  ),
                  OnboardingPage(
                    image: "assets/images/onboarding_3.svg",
                    titre: "Renseignez-vous sur vos médecins",
                    sousTitre:
                        "Découvrez le parcours de vos praticiens de confiance",
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  (currentPageIndex == 0)
                      ? SizedBox()
                      : GestureDetector(
                          onTap: previousPage,
                          child: buildFleche(false),
                        ),
                  Row(
                    children: List.generate(
                      totalDots,
                      (index) => buildDot(index == currentPageIndex),
                    ),
                  ),
                  (currentPageIndex == totalDots - 1)
                      ? ElevatedButton(
                          onPressed: () {
                            Get.to(Login());
                          },
                          child: Text("S'authentifier"))
                      : GestureDetector(
                          onTap: nextPage,
                          child: buildFleche(true),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ColoredBox(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFleche(bool droite) {
    return Container(
      height: 30,
      width: 30,
      child: Icon(
        (!droite) ? Icons.arrow_back_outlined : Icons.arrow_forward_outlined,
        color:  Colors.blue,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget buildDot(bool isActive) {
    return Container(
      height: 10,
      width: isActive ? 20 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String titre;
  final String sousTitre;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.titre,
    required this.sousTitre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildPage(
      image: image,
      titre: titre,
      sousTitre: sousTitre,
    );
  }

  Widget buildPage({
    required String image,
    required String titre,
    required String sousTitre,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      child: SvgPicture.asset(
                        image,
                        height: 380,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    titre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    sousTitre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
