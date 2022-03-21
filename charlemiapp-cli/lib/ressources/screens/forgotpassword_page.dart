import '../loader.dart';
import '../../ressources/screens/home.dart';
import '../../services/authentication.dart';
import '../../ressources/navigation/appbar_back.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final AuthenticationService _auth = AuthenticationService();

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
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
          hintText: "Adresse email",
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
            var data = await _auth.resetPassword(email);
            setState(() {
              Home.loading = false;
            });
            if (data == true) {
              setState(() {
                validate = "Un email vous a été envoyé";
                error = "";
              });
            } else if (data == null) {
              setState(() {
                error = "Impossible de réinitialiser le mot de passe";
                validate = "";
                emailController.clear();
              });
            } else {
              setState(() {
                error = data == 'email'
                    ? "Adresse email invalide"
                    : data == "notfound"
                        ? "Utilisateur introuvable"
                        : "Erreur";
                validate = "";
                emailController.clear();
              });
            }
          }
        },
        child: const Text(
          'Réinitialiser',
          style: TextStyle(fontSize: 18),
        ),
        style: ButtonStyle(
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
                            "Récupération",
                            style: GoogleFonts.poppins(
                              fontSize: 29,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _emailField(),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              validate,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.green,
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
