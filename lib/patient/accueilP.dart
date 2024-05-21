import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rendez_vous_hop/model/allUsers.dart';

class AccueilPatient extends StatefulWidget {
  const AccueilPatient({super.key});

  @override
  State<AccueilPatient> createState() => _AccueilPatientState();
}

class _AccueilPatientState extends State<AccueilPatient> {
  User selfUser = Get.arguments as User;

  late Future<List<Medecin>> _listMedecin;

bool userPret = false;
bool medecinPret = false;
bool totalPret = false;

@override
void initState() {
  super.initState();
  _listMedecin = _fetchAllMedecins();
}

Future<List<Medecin>> _fetchAllMedecins() async {
  List<Map<String, dynamic>> medecins = [];
  List<Map<String, dynamic>> users = [];

  try {
    // Fetch Medecins
    QuerySnapshot medecinSnapshot = await FirebaseFirestore.instance.collection('Medecins').get();
    if (medecinSnapshot.docs.isNotEmpty) {
      for (var doc in medecinSnapshot.docs) {
        medecins.add(doc.data() as Map<String, dynamic>);
      }
    }
    medecinPret = true;
  } catch (e) {
    print('Erreur lors de la récupération des médecins: $e');
  }

  try {
    // Fetch Users of type 'medecin'
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users')
        .where('type', isEqualTo: 'medecin')
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      for (var doc in userSnapshot.docs) {
        users.add(doc.data() as Map<String, dynamic>);
      }
    }
    userPret = true;
  } catch (e) {
    print('Erreur lors de la récupération des utilisateurs: $e');
  }

  if (userPret && medecinPret) {
    totalPret = true;
    return _combineMedecinUserData(users, medecins);
  }

  return [];
}

List<Medecin> _combineMedecinUserData(List<Map<String, dynamic>> users, List<Map<String, dynamic>> medecins) {
  List<Medecin> combinedList = [];

  for (var user in users) {
    String email = user['email'];
    var matchingMedecin = medecins.firstWhere((medecin) => medecin['email'] == email, orElse: () => {});
    if (matchingMedecin.isNotEmpty) {
      Medecin medecin = Medecin.fromFirestore(user, matchingMedecin);
      combinedList.add(medecin);
    }
  }

  return combinedList;
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Localisation",
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blue,
                            ),
                            Text("${selfUser.adresse}, Guinée"),
                            Icon(Icons.arrow_drop_down),
                          ],
                        )
                      ]),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Icon(Icons.notifications),
                            Positioned(
                                child: Container(
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            )),
                            Positioned(
                                child: Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: FormBuilderTextField(
                name: "recherche",
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.1),
                    hintText: "Rechercher...",
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: Icon(Icons.search, color: Colors.blue),
                    suffixIcon:
                        Icon(Icons.filter_list_outlined, color: Colors.blue),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Rendez-vous prochain",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      buildRond(
                          icon: Text("8"),
                          dim: 25,
                          couleur: Colors.blue,
                          opac: 0.5)
                    ],
                  ),
                  Text(
                    "Voir tout",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: Container(
                  height: 137,
                  decoration: BoxDecoration(
                    // border: Border.all(),
                    color: Colors.blue.withOpacity(0.5),

                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/apple.png"),
                        ),
                        title: Text("Dr. Ousmane Diakhaby"),
                        subtitle: Text("Consultation Dentiste"),
                        trailing: Icon(Icons.phone),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined),
                                      Text("Lundi, 26 Juillet")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 1,
                                    child: ColoredBox(
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time),
                                      Text("09:00 - 10:00")
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: buildSousTitre(phrase: "Specialités des medecins"),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildSpecialite(
                      icon: FaIcon(FontAwesomeIcons.tooth,
                          size: 30, color: Colors.blue),
                      dim: 40,
                      text: "Dentiste"),
                  buildSpecialite(
                      icon: Icon(Icons.accessibility_new,
                          size: 30, color: Colors.blue),
                      dim: 40,
                      text: "Neurologie"),
                  buildSpecialite(
                      icon: Icon(Icons.favorite, size: 30, color: Colors.blue),
                      dim: 40,
                      text: "Cardiologie"),
                  buildSpecialite(
                      icon: Icon(Icons.scatter_plot,
                          size: 30, color: Colors.blue),
                      dim: 40,
                      text: "Orthopédie"),
                  buildSpecialite(
                      icon: Icon(Icons.emergency_outlined,
                          size: 30, color: Colors.blue),
                      dim: 40,
                      text: "Urgences"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: buildSousTitre(phrase: "Hopitaux proches"),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return buildCardHopital();
                  }),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: buildSousTitre(phrase: "Top spécialistes"),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: FutureBuilder(
                  future: _listMedecin,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucun médecin trouvé.'));
                    } else {
                      List<Medecin> medecins = snapshot.data!;
                      return ListView.builder(
                        itemCount: medecins.length,
                        itemBuilder: (context, index) {
                          Medecin medecin = medecins[index];
                          return buildDoctor(medecin);
                        },
                      );
                    }
                  },
                )),
          ],
        ),
      )),
    ));
  }

  Future<dynamic> getUsersList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('type', isEqualTo: 'medecin')
          .get();

      if (querySnapshot.docs.isNotEmpty) {}
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite. Veuillez réessayer.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget buildSpecialite(
      {double dim = 40,
      double border = 30,
      required dynamic icon,
      required String text,
      Color couleur = Colors.black,
      double opac = 0.1}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: dim,
          width: dim,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(border),
            color: couleur.withOpacity(opac),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [icon],
          ),
        ),
        Text(text, style: TextStyle(fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget buildDoctor(Medecin medecin) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      // Add navigation
      onTap: () {
        // Get.to(DetailMedecin);
      },
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: colorScheme.background,
        backgroundImage: AssetImage("assets/images/cellou.jpg"),
      ),
      title: Text(
        "${medecin.nom} ${medecin.prenom}",
        style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.0),
          Text(
            medecin.specialite,
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.star,
                  color: const Color.fromRGBO(255, 204, 128, 1), size: 16),
              const SizedBox(width: 4.0),
              Text(
                medecin.note.toString(),
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.work, color: colorScheme.tertiary, size: 16),
              const SizedBox(width: 4),
              Text(
                medecin.anneeExp.toString(),
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onBackground.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: FilledButton(
        onPressed: () {
          // Get.to();
        },
        child: const Text('Reservez'),
      ),
    );
  }

  Widget buildRond(
      {double dim = 40,
      double border = 30,
      required dynamic icon,
      Color couleur = Colors.black,
      double opac = 0.1}) {
    return Container(
      height: dim,
      width: dim,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border),
        color: couleur.withOpacity(opac),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon],
      ),
    );
  }

  Widget buildSousTitre({required String phrase}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          phrase,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Voir tout",
          style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue),
        )
      ],
    );
  }

  Widget buildCardHopital() {
    return Card(
      elevation: 4.0, // Effet d'ombre
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Coins arrondis
      ),
      margin: EdgeInsets.all(8.0), // Marge autour de la carte
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // En-tête avec une image
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Positioned(
                child: Container(
                  height: 120,
                  width: 192,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/cellou.jpg'), // Chemin de l'image
                      fit: BoxFit.fill, // Ajustement de l'image
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    height: 30.0,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star),
                        Text("4.8"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Titre
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'CHU Donka',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          // Sous-titre
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                Icon(Icons.access_time_rounded),
                Text(
                  "15min",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Text(
                  "1.5Km",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
