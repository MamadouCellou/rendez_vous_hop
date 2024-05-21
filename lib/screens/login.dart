import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rendez_vous_hop/medecin/accueilM.dart';
import 'package:rendez_vous_hop/model/allUsers.dart';
import 'package:rendez_vous_hop/patient/accueilP.dart';
import 'package:rendez_vous_hop/screens/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "S'authentifier",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text("Hey bienvenue vous nous aviez manqué"),
                ),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: FormBuilderTextField(
                          name: "email",
                          controller: _emailController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Ce champ ne peut pas être vide"),
                            FormBuilderValidators.email(
                                errorText: "Entrer un email valide"),
                          ]),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
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
                          controller: _passwordController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: "Ce champ ne peut pas être vide"),
                            FormBuilderValidators.minLength(4,
                                errorText:
                                    "Le mot de passe doit contenir au moins 6 caractères"),
                          ]),
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              labelText: "Mot de passe",
                              labelStyle: TextStyle(fontSize: 20),
                              hintText: "Entrez votre mot de passe",
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: _togglePasswordVisibility,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10)),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10, right: 21, bottom: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Mot de passe oublié",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        child: GFButton(
                          onPressed: () async {
                            if (_formKey.currentState == null ||
                                !_formKey.currentState!.saveAndValidate()) {
                              return;
                            } else {
                              final formData = _formKey.currentState!.value;
                              await signInWithEmailAndPassword(
                                  formData['email'], formData['password']);
                            }
                          },
                          shape: GFButtonShape.pills,
                          fullWidthButton: true,
                          textColor: Colors.white,
                          size: GFSize.LARGE,
                          color: GFColors.PRIMARY,
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          text: "Connexion",
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
                            child: Text("Ou connectez-vous avec"),
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
                                        "assets/images/facebook.png"))
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Pas encore de compte ?"),
                      GestureDetector(
                        onTap: () {
                          Get.to(Signup());
                        },
                        child: Text(
                          "S'inscrire",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (userData != null) {
          if (userData['password'] == password) {
            if (userData['type'] == "patient") {
              // User user = 
              User user = User.fromFirestore(userData);
              Get.to(AccueilPatient(), arguments: user);
            } else {
              Get.to(AccueilMedecin());
              // Medecin medecin = Medecin.fromFirestore(userData);
            }
          } else {
            Get.snackbar("Erreur", "Mot de passe incorect",
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: Duration(seconds: 4));
          }
        } else {
          print('Les données de l\'utilisateur sont nulles');
          Get.snackbar("Erreur", "Données nulles",
              backgroundColor: Colors.grey,
              colorText: Colors.white,
              duration: Duration(seconds: 4));
        }
      } else {
        Get.snackbar("Non trouvé", "Aucun utilisateur trouvé avec cet e-mail",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 4));
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite. Veuillez réessayer.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
