import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AcceuilPatient extends StatefulWidget {
  @override
  _AcceuilPatientState createState() => _AcceuilPatientState();
}

class _AcceuilPatientState extends State<AcceuilPatient> {
  final _formKey = GlobalKey<FormState>();
  String? _nom = '';
  String? _prenom = '';
  String? _type = 'patient';
  String? _email = '';
  String? _motDePasse = '';
  DateTime _dateDeNaissance = DateTime.now();
  String? _imageUrl;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire d\'inscription'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _imageUrl != null
                  ? Image.file(File(_imageUrl!))
                  : Container(), // Affiche une image vide si _imageUrl est null
              ElevatedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: Icon(Icons.image),
                label: Text('Importer depuis la galerie'),
              ),
              ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: Icon(Icons.camera_alt),
                label: Text('Prendre une photo'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nom = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _prenom = value;
                },
              ),
              DropdownButtonFormField(
              
                value: _type,
                items: ['patient', 'medecin'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse e-mail'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Veuillez entrer une adresse e-mail valide';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
                onSaved: (value) {
                  _motDePasse = value;
                },
              ),
              ListTile(
                title: Text('Date de naissance'),
                subtitle: Text(
                    '${_dateDeNaissance.day}/${_dateDeNaissance.month}/${_dateDeNaissance.year}'),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dateDeNaissance,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dateDeNaissance = selectedDate;
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    //ajout dans la base de données
                    CollectionReference userRef =
                        FirebaseFirestore.instance.collection("Users");
                    userRef.add({
                      'date_naiss': _dateDeNaissance.toString(),
                      'email': _email,
                      'nom': _nom,
                      'password': _motDePasse,
                      'prenom': _prenom,
                      'type': _type,
                      'imageUrl': _imageUrl, // Ajoute l'URL de l'image à la base de données
                    });
                  }
                },
                child: Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AcceuilPatient(),
  ));
}
