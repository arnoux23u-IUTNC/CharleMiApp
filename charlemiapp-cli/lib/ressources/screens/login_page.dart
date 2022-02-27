import 'home.dart';
import '../loader.dart';
import '../assets/colors.dart';
import '../navigation/appbar_back.dart';
import '../../services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final AuthenticationService _auth = AuthenticationService();

class Login extends StatefulWidget {
  const Login({Key? key, this.message}) : super(key: key);

  final String? message;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String error = "";
  late String? message = widget.message;

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
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "Email",
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
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        validator: (value) => value!.isEmpty ? "Veuillez saisir un mot de passse" : null,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          errorMaxLines: 2,
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

  Widget _submitBtn() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              Home.loading = true;
            });
            final String email = emailController.text;
            final String password = passwordController.text;
            var user = await _auth.signInWithEmailAndPassword(email, password);
            if (user == null || user == "disabled" || user == "notverified") {
              if (!mounted) return;
              setState(() {
                Home.loading = false;
                Home.user = null;
                message = null;
                error = (user == null)
                    ? "Email ou mot de passe incorrect"
                    : (user == "disabled")
                        ? "Compte désactivé. Contactez un administrateur"
                        : "Compte non valide. Consultez votre boite mail";
                passwordController.clear();
              });
            } else {
              setState(() {
                Home.loading = false;
                Home.user = user;
                error = "";
              });
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)), (route) => false);
            }
          }
        },
        child: const Text(
          'Valider',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonBlueColor),
            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      ),
    );
  }

  Widget _displayMessages() {
    return message != null
        ? Text(
            message!,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        : Text(
            error,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Home.loading
        ? const Loader()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: const AppBarBack(),
            body: Container(
                constraints: const BoxConstraints.expand(),
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
                            "Connexion",
                            style: GoogleFonts.poppins(
                              color: whiteColor,
                              fontSize: 29,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _emailField(),
                          _passwordField(),
                          _displayMessages(),
                          _submitBtn()
                        ],
                      ),
                    ),
                  ),
                )),
          );
  }
}
