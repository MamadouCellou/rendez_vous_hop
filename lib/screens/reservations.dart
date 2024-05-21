import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  bool estActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservations"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
        child: Column(
          children: [
            buildCardDocteur()
          ],
        ),
      ))),
    );
  }

  Widget buildCardDocteur() {
    return Card(
      elevation: 4, // Effet d'ombre
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Coins arrondis
      ),
      child: Container(
        color: Colors.white.withOpacity(0.5),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Jui 07, 2024 - 10:00",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text("Me rappeler"),
                    Switch(
                      value: estActive,
                      onChanged: (value) {
                        setState(() {
                          estActive = value;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage('assets/images/cellou.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Dr. Jane Cooper",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "Dentiste",
                        style: TextStyle(
                            fontSize: 15, color: Colors.black.withOpacity(0.6)),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          Text(
                            "New York",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.trending_up),
                          Text(
                            "20+",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GFButton(
                  onPressed: () {},
                  text: "Annuler",
                  shape: GFButtonShape.pills,
                  // fullWidthButton: true,
                  textColor: Colors.white,

                  size: GFSize.LARGE,
                  color: GFColors.DANGER,
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                GFButton(
                  onPressed: () {},
                  text: "Modifier",
                  shape: GFButtonShape.pills,
                  // fullWidthButton: true,
                  textColor: Colors.white,

                  size: GFSize.LARGE,
                  color: GFColors.PRIMARY,
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRendezVous(
      {required String imageDr,
      required String nom,
      required String specialite,
      required String date,
      required String heure}) {
    return Container(
        height: 175,
        decoration: BoxDecoration(
          // border: Border.all(),
          color: Colors.blue.withOpacity(0.5),

          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(imageDr),
              ),
              title: Text(nom),
              subtitle: Text(specialite),
              trailing: Icon(Icons.phone),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined),
                            Text(date)
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
                          children: [Icon(Icons.access_time), Text(heure)],
                        )
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GFButton(
                    onPressed: () {},
                    text: "Annuler",
                    shape: GFButtonShape.pills,
                    // fullWidthButton: true,
                    textColor: Colors.white,

                    size: GFSize.LARGE,
                    color: GFColors.DANGER,
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  GFButton(
                    onPressed: () {},
                    text: "Modifier",
                    shape: GFButtonShape.pills,
                    // fullWidthButton: true,
                    textColor: Colors.white,

                    size: GFSize.LARGE,
                    color: GFColors.PRIMARY,
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
