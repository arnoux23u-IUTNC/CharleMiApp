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
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          print("saved");
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Adresse email",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 18,
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
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: passwordController,
        validator: (value) => AuthenticationService.validatePassword(value!, null),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        onSaved: (value) {
          print("saved");
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          focusColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Mot de passe",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 18,
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
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: passwordConfirmController,
        obscureText: true,
        validator: (value) => AuthenticationService.validatePassword(value!, passwordController.text),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        onSaved: (value) {
          print("saved");
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          focusColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Confirm password",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 18,
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
      padding: const EdgeInsets.only(top: 51),
      child: TextFormField(
        controller: lastNameController,
        validator: (value) => value!.isEmpty || value.length < 3 ? "Enter a valid last name" : null,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          print("saved");
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Nom",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 18,
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
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: firstNameController,
        validator: (value) => value!.isEmpty || value.length < 3 ? "Enter a valid first name" : null,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          print("saved");
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Prénom",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 18,
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
      padding: const EdgeInsets.only(top: 51),
      child: TextFormField(
        controller: numTelController,
        validator: AuthenticationService.validateNumTel,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.phone,
        onSaved: (value) {
          print("saved");
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Téléphone",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 18,
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
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: carteEtuController,
        validator: AuthenticationService.validateCarteEtu,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          print("saved");
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Numéro Etu",
          hintStyle: GoogleFonts.poppins(
            color: greyedFont,
            fontSize: 18,
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
      padding: const EdgeInsets.only(top: 60, bottom: 15),
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
            emailController.clear();
            passwordController.clear();
            passwordConfirmController.clear();
            lastNameController.clear();
            firstNameController.clear();
            numTelController.clear();
            carteEtuController.clear();
            if (user == null) {
              setState(() {
                Home.user = null;
                error = "Error while registering";
                passwordController.clear();
                passwordConfirmController.clear();
              });
            } else {
              setState(() {
                error = "";
                validate = "you are now registered, please login";
                MaterialPageRoute(builder: (context) => const Login());
              });
            }
          }
        },
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonBlueColor), padding: MaterialStateProperty.all(const EdgeInsets.all(20)), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Home.loading
        ? Loader()
        : Scaffold(
            appBar: const MyAppBarBack(),
            body: Container(
                color: darkColor,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(55),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Register",
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
                        _submitBtn()
                      ],
                    ),
                  ),
                ))),
          );
  }
}
