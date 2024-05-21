class User {
  String nom;
  String prenom;
  String adresse;
  String dateNaiss;
  String email;
  String password;
  String type;

  User({
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.dateNaiss,
    required this.email,
    required this.password,
    required this.type,
  });

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      adresse: data['adresse'] ?? '',
      dateNaiss: data['date_naiss'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      type: data['type'] ?? '',
    );
  }
}

class Medecin extends User {
  String specialite;
  int note;
  int nbreCommentaires;
  Map<String, dynamic> heuresTravail;
  int anneeExp;

  Medecin({
    required String nom,
    required String prenom,
    required String adresse,
    required String dateNaiss,
    required String email,
    required String password,
    required String type,
    required this.specialite,
    required this.note,
    required this.nbreCommentaires,
    required this.heuresTravail,
    required this.anneeExp,
  }) : super(
          nom: nom,
          prenom: prenom,
          adresse: adresse,
          dateNaiss: dateNaiss,
          email: email,
          password: password,
          type: type,
        );

  factory Medecin.fromFirestore(
      Map<String, dynamic> userData, Map<String, dynamic> medecinData) {
    return Medecin(
      nom: userData['nom'] ?? '',
      prenom: userData['prenom'] ?? '',
      adresse: userData['adresse'] ?? '',
      dateNaiss: userData['date_naiss'] ?? '',
      email: userData['email'] ?? '',
      password: userData['password'] ?? '',
      type: userData['type'] ?? '',
      specialite: medecinData['specialite'] ?? '',
      note: medecinData['note'] ?? 0,
      nbreCommentaires: medecinData['nbre_commentaires'] ?? 0,
      heuresTravail: medecinData['heures_travail'] ?? {},
      anneeExp: medecinData['annee_exp'] ?? 0,
    );
  }
}
