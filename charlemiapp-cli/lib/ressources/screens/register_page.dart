import 'home.dart';
import 'login_page.dart';
import '../loader.dart';
import '../assets/colors.dart';
import '../navigation/appbar_back.dart';
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
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Adresse email",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          focusColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Mot de passe",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          focusColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Confirmation",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Nom",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Prénom",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Téléphone",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _studentCardField() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: carteEtuController,
        validator: AuthenticationService.validateCarteEtu,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          hintText: "Numéro Etudiant",
          //TODO AFFICHER BULLE CARTE
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
            //if(_auth.userExists(phone) || )
            //final String carteEtu = carteEtuController.text;
            var user = await _auth.register(email, password, lastName, firstName, numTel, carteEtu);
            setState(() {
              Home.loading = false;
            });
            //emailController.clear();
            passwordController.clear();
            passwordConfirmController.clear();
            /*lastNameController.clear();
            firstNameController.clear();
            numTelController.clear();*/
            //carteEtuController.clear();
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
                    MaterialPageRoute(
                        builder: (context) =>
                            const Login(message: "Inscription effectuée, vérifiez vos mails afin d'activer votre compte")),
                    (route) => false);
              });
            }
          }
        },
        child: const Text(
          'Valider',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonBlueColor),
            padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Home.loading
        ? const Loader()
        : Scaffold(
            appBar: const AppBarBack(),
            body: Container(
                height: MediaQuery.of(context).size.height,
                color: darkColor,
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
                            color: whiteColor,
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
                )))),
          );
  }
}
