import 'home.dart';
import '../loader.dart';
import 'login_page.dart';
import '../navigation/appbar_back.dart';
import '../../ressources/assets/const.dart';
import '../../services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final AuthenticationService _auth = AuthenticationService();

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numTelController = TextEditingController();
  TextEditingController carteEtuController = TextEditingController();
  String error = "", validate = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _emailField() {
    return Container(
      padding: const EdgeInsets.only(top: 29),
      child: TextFormField(
        controller: emailController,
        validator: AuthenticationService.validateEmail,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Adresse email",
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: passwordController,
        validator: (value) => AuthenticationService.validatePassword(value!, null),
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Mot de passe",
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: passwordConfirmController,
        obscureText: true,
        validator: (value) => AuthenticationService.validatePassword(value!, passwordController.text),
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Confirmation",
        ),
      ),
    );
  }

  Widget _lastnameField() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: lastNameController,
        validator: (value) => value!.isEmpty || value.length < 3 ? "Entrez une valeur" : null,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Nom",
        ),
      ),
    );
  }

  Widget _firstnameField() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: firstNameController,
        validator: (value) => value!.isEmpty || value.length < 3 ? "Entrez une valeur" : null,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Prénom",
        ),
      ),
    );
  }

  Widget _phoneField() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: numTelController,
        validator: AuthenticationService.validateNumTel,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Téléphone",
        ),
      ),
    );
  }

  Widget _studentCardField() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: TextFormField(
              controller: carteEtuController,
              validator: AuthenticationService.validateCarteEtu,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              autofocus: false,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                hintText: "Numéro Etudiant",
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: const Icon(
                Icons.info_outline,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Numéro Etudiant", style: GoogleFonts.poppins(fontSize: 20, color: Colors.black)),
                      backgroundColor: Colors.white,
                      content: Image.asset("assets/carteetu.png"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitBtn() {
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              Home.loading = true;
            });
            final String email = emailController.text;
            final String password = passwordController.text;
            final String lastName = lastNameController.text;
            final String firstName = firstNameController.text;
            final String numTel = numTelController.text;
            final String carteEtu = carteEtuController.text;
            var user = await _auth.register(email, password, lastName, firstName, numTel, carteEtu);
            setState(() {
              Home.loading = false;
            });
            passwordController.clear();
            passwordConfirmController.clear();
            if (user == null) {
              setState(() {
                Home.user = null;
                error = "Erreur lors de l'enregistrement";
                passwordController.clear();
                passwordConfirmController.clear();
              });
            } else {
              setState(() {
                error = "";
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login(message: "Inscription effectuée, vérifiez vos mails afin d'activer votre compte")),
                    (route) => false);
              });
            }
          }
        },
        child: const Text(
          'Valider',
          style: TextStyle(fontSize: 18),
        ),
        style: btnDefaultStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Home.loading
        ? const Loader()
        : Scaffold(
            appBar: const AppBarBack(null),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Inscription",
                            style: GoogleFonts.poppins(
                              fontSize: 29,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _emailField(),
                          _passwordField(),
                          _confirmPasswordField(),
                          _lastnameField(),
                          _firstnameField(),
                          _phoneField(),
                          _studentCardField(),
                          _submitBtn(),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              error,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
