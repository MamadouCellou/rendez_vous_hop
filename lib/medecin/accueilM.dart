import 'package:flutter/cupertino.dart';

class AccueilMedecin extends StatefulWidget {
  const AccueilMedecin({super.key});

  @override
  State<AccueilMedecin> createState() => _AccueilMedecinState();
}

class _AccueilMedecinState extends State<AccueilMedecin> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Accueil Medecin"),
    );
  }
}