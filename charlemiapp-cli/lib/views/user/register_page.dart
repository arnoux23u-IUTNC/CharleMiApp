import 'package:charlemiapp_cli/views/widgets/appbar_back.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);
const greyedFont = Color(0xFF6F6F6F);

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _email;
  late String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmailField() {
    return Container(
      padding: const EdgeInsets.only(top: 29),
      child: TextFormField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          // TODO Guillaume
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: midDarkColor,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: "email",
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

  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        onSaved: (value) {
          // TODO Guillaume
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

  Widget _buildConfirmPassword() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        onSaved: (value) {
          // TODO Guillaume
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

  Widget _buildName() {
    return Container(
      padding: const EdgeInsets.only(top: 51),
      child: TextFormField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          // TODO Guillaume
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

  Widget _buildSurname() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          // TODO Guillaume
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

  Widget _buildPhone() {
    return Container(
      padding: const EdgeInsets.only(top: 51),
      child: TextFormField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.phone,
        onSaved: (value) {
          // TODO Guillaume
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

  Widget _buildEtuNumber() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        autofocus: false,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          // TODO Guillaume
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

  Widget _buildSubmit() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO register Guillaume
        },
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonBlueColor),
            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _buildEmailField(),
                  _buildPasswordField(),
                  _buildConfirmPassword(),
                  _buildName(),
                  _buildSurname(),
                  _buildPhone(),
                  _buildEtuNumber(),
                  _buildSubmit()
                ],
              ),
            ),
          ))),
    );
  }
}
