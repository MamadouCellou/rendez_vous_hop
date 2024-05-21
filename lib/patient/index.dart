import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rendez_vous_hop/patient/accueilP.dart';
import 'package:rendez_vous_hop/screens/profile.dart';
import 'package:rendez_vous_hop/screens/reservations.dart';


class Central extends StatefulWidget {
  const Central({super.key});


  @override
  State<Central> createState() => _CentralState();
}

class _CentralState extends State<Central> {
  int currentPage = 0;

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();

    widgets = [
      AccueilPatient(),
      Reservation(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: widgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: "Reservation"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")
          ]),
    ));
  }

  
}
