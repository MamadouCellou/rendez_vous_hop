import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rendez_vous_hop/screens/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

String? dropdownValue = "patient";
bool? checked = false;

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormBuilderState>();

  TimeOfDay selectedTimeDebut = TimeOfDay.now();
  TimeOfDay selectedTimeFin = TimeOfDay.now();

  List jours = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche"
  ];
  List<TimeOfDay> selectedEndTimes =
      List.generate(7, (index) => TimeOfDay(hour: 17, minute: 0));
  List<TimeOfDay> selectedStartTimes =
      List.generate(7, (index) => TimeOfDay(hour: 9, minute: 0));

  // List heureDebut = ["10:30", "13:30", "14:00", "19:30", "15:30", "08:30", "11:30"];
  // List heureFin = ["10:30", "13:30", "14:00", "19:30", "15:30", "08:30", "11:30"];

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _typeController = TextEditingController();

  String? _imageUrl;

  String defaultImageForDoctor = "./assets/images/cellou.jpg";
  String defaultImageForPatient = "./assets/images/fleur.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Renseignez vos informations en dessous ou inscrivez-vous avec votre compte social",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: DropdownButtonFormField<String>(
                      value: dropdownValue,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                        labelText: "S'inscrire en tant que",
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: ['medecin', 'patient']
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(value),
                                ),
                              ))
                          .toList(),
                      validator: FormBuilderValidators.required(),
                    ),
                  ),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: FormBuilderTextField(
                            name: "nom",
                            enableSuggestions: true,
                            validator: FormBuilderValidators.required(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              labelText: "Nom",
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: "Entrez votre nom",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: FormBuilderTextField(
                            name: "prenom",
                            enableSuggestions: true,
                            validator: FormBuilderValidators.required(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              labelText: "Prenom",
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: "Entrez votre prenom",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: FormBuilderTextField(
                            name: "adresse",
                            enableSuggestions: true,
                            validator: FormBuilderValidators.required(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              labelText: "Adresse",
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: "Entrez votre adresse",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: FormBuilderDateTimePicker(
                            name: "dateNaissance",
                            validator: FormBuilderValidators.required(),
                            inputType: InputType.date,
                            format: DateFormat("dd/MM/yyyy"),
                            initialDate: DateTime.now(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              labelText: "Date de naissance",
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: "Sélectionnez votre date de naissance",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                        dropdownValue?.toLowerCase() == "medecin"
                            ? Visibility(
                                child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    child: FormBuilderTextField(
                                      name: "specialite",
                                      enableSuggestions: true,
                                      validator:
                                          FormBuilderValidators.required(),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        filled: true,
                                        fillColor:
                                            Colors.black.withOpacity(0.1),
                                        labelText: "Specialté",
                                        labelStyle: TextStyle(fontSize: 20),
                                        hintText: "Votre specialité",
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    child: FormBuilderTextField(
                                      name: "experience",
                                      keyboardType: TextInputType.number,
                                      validator:
                                          FormBuilderValidators.required(),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        filled: true,
                                        fillColor:
                                            Colors.black.withOpacity(0.1),
                                        labelText: "Experience",
                                        labelStyle: TextStyle(fontSize: 20),
                                        hintText:
                                            "Nombre d'années d'experience",
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: heureDeTravail(),
                                  )
                                ],
                              ))
                            : SizedBox(),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: FormBuilderTextField(
                            name: "email",
                            enableSuggestions: true,
                            validator: FormBuilderValidators.email(),
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              labelText: "Email",
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: "Entrez votre email",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: FormBuilderTextField(
                            name: "password",
                            enableSuggestions: true,
                            controller: _passwordController,
                            validator: FormBuilderValidators.required(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              labelText: "Mot de passe",
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: "Entrez votre mot de passe",
                              suffixIcon: Icon(Icons.visibility_off),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Center(
                            child: Text(
                              "Votre image",
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              _imageUrl != null
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Image.file(
                                        File(_imageUrl!),
                                        height: 250,
                                        width: 250,
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: _pickImageFromGallery,
                                            icon: Icon(Icons.image),
                                            label: Text(
                                                'Importer depuis la galerie'),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: _takePhoto,
                                            icon: Icon(Icons.camera_alt),
                                            label: Text('Prendre une photo'),
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            "J'accepte les termes et conditions",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              color: Colors.blue,
                            ),
                          ),
                          value: checked,
                          onChanged: (value) {
                            setState(() {
                              checked = value;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 20),
                          child: GFButton(
                            onPressed: () {
                              if (_imageUrl == null) {
                                Get.dialog(AlertDialog(
                                  title: Text('Inscription incomplète !'),
                                  content: Text(
                                    'Une image est requise.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // Fermer la boîte de dialogue
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ));
                              } else {
                                _submitForm();
                              }
                            },
                            shape: GFButtonShape.pills,
                            fullWidthButton: true,
                            textColor: Colors.white,
                            size: GFSize.LARGE,
                            color: GFColors.PRIMARY,
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            text: "S'inscrire",
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 0.5,
                              width: 60,
                              child: ColoredBox(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Text("Ou inscrivez-vous avec"),
                            ),
                            SizedBox(
                              height: 0.5,
                              width: 60,
                              child: ColoredBox(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildSocial(
                                    image:
                                        Image.asset("assets/images/apple.png")),
                                buildSocial(
                                    image: Image.asset(
                                        "assets/images/google.png")),
                                buildSocial(
                                    image: Image.asset(
                                        "assets/images/facebook.png")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Vous avez un compte ?"),
                        GestureDetector(
                          onTap: () {
                            Get.to(Login());
                          },
                          child: Text(
                            " Se connecter",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget heureDeTravail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heure de travaille',
        ),
        const SizedBox(height: 8.0),
        ListView.separated(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          separatorBuilder: (context, index) => const SizedBox(height: 8.0),
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: Text("${jours[index]}"),
                ),
                const SizedBox(width: 16.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: selectedStartTimes[index],
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          selectedStartTimes[index] = timeOfDay;
                        });
                      }
                    },
                    child: Text(
                      DateFormat('HH:mm').format(DateTime(
                          2022,
                          1,
                          1,
                          selectedStartTimes[index].hour,
                          selectedStartTimes[index].minute)),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                const Text("-"),
                const SizedBox(width: 16.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: selectedEndTimes[index],
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          selectedEndTimes[index] = timeOfDay;
                        });
                      }
                    },
                    child: Text(
                      DateFormat('HH:mm').format(DateTime(
                          2022,
                          1,
                          1,
                          selectedEndTimes[index].hour,
                          selectedEndTimes[index].minute)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageUrl = pickedImage.path;
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imageUrl = pickedImage.path;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState == null ||
        !_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final formData = _formKey.currentState!.value;

    final File imageFile = File(_imageUrl!);

    final CollectionReference userRef =
        FirebaseFirestore.instance.collection("Users");

    await userRef.add({
      'adresse': formData['adresse'],
      'date_naiss': formData['dateNaissance'].toString(),
      'email': formData['email'],
      'nom': formData['nom'],
      'password': formData['password'],
      'prenom': formData['prenom'],
      'type': dropdownValue,
    });

    if (dropdownValue == 'medecin') {
      final CollectionReference medecinRef =
          FirebaseFirestore.instance.collection("Medecins");

      Map horairesAsString = {
        'debut': convertList(liste: selectedStartTimes),
        'fin': convertList(liste: selectedEndTimes),
      };

      await medecinRef.add({
        'annee_exp': formData['experience'],
        'heures_travail': horairesAsString,
        'email': formData['email'],
        'nbre_commentaires': 150,
        'note': 5,
        'specialite': formData['specialite'],
      });
    }

    await _uploadImageToFirebase(imageFile, formData['email']);

    Get.dialog(
      AlertDialog(
        title: Text('Inscription réussie'),
        content: Text(
          'Votre inscription a été effectuée avec succès. Veuillez vous connecter.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Fermer la boîte de dialogue

              // Retarder la redirection vers la page de connexion
              Future.delayed(Duration(milliseconds: 500), () {
                Get.off(Login()); // Rediriger vers la page de connexion
              });
            },
            child: Text("D'accord"),
          ),
        ],
      ),
    );
  }

  List<String> convertList({required List<TimeOfDay> liste}) {
    List<String> newListe = [];

    liste.forEach((element) {
      // Utilisez la méthode format pour obtenir une chaîne HH:mm
      newListe.add(DateFormat('HH:mm')
          .format(DateTime(2022, 1, 1, element.hour, element.minute))
          .toString());
    });

    return newListe;
  }

  Future<void> _uploadImageToFirebase(
      File _imageFile, String nomCompletImage) async {
    if (_imageFile == null) {
      // Gérer le cas où aucune image n'est sélectionnée
      return;
    }

    // Référence à Firebase Storage
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('images_users/${nomCompletImage}');

    // Téléchargement de l'image
    await storageRef.putFile(_imageFile);

    // Récupérer l'URL de téléchargement
    String downloadURL = await storageRef.getDownloadURL();

    // Utilisez downloadURL pour stocker l'URL de l'image dans Firestore ou tout autre traitement nécessaire
  }

  Future<void> insertUser() async {}

  Widget buildSocial({required Image image}) {
    return Container(
      height: 70,
      width: 70,
      padding: EdgeInsets.all(20),
      child: image,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
