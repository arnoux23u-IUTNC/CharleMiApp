import 'package:charlemiapp_cli/ressources/loader.dart';
import 'package:charlemiapp_cli/services/authentication.dart';
import 'package:flutter/material.dart';

import '../nav.dart';

final AuthenticationService _auth = AuthenticationService();

/*Home*/
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Home'),
        ),
      );
}

/*Explore*/
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Explore'),
        ),
      );
}

/*AuthScreen*/
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreen createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  int _authMode = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numTelController = TextEditingController();
  TextEditingController carteEtuController = TextEditingController();
  String error = "";
  String validate = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Home.loading
        ? Loader()
        : _authMode == 0
            ? Scaffold(
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: AuthenticationService.validateEmail,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? "Enter a valid password" : null,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              Home.loading = true;
                            });
                            final String email = emailController.text;
                            final String password = passwordController.text;
                            print("$email $password");
                            var user = await _auth.signInWithEmailAndPassword(email, password);
                            print("user is $user");
                            if (user == null) {
                              if(!mounted) return;
                              setState(() {
                                Home.loading = false;
                                Home.user = null;
                                validate = "";
                                error = "Invalid username or password";
                                //TODO passwordController.clear();
                              });
                            } else {
                              setState(() {
                                Home.loading = false;
                                Home.user = user;
                                validate = "";
                                error = "";
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (Route<dynamic> route) => true);
                              });

                              /*Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfileScreen()),
                              );*/
                            }
                          }
                        },
                        child: const Text('Connexion'),
                      ),
                      ElevatedButton(
                          child: const Text('Inscription'),
                          onPressed: () => setState(() {
                                _authMode = 1;
                              })),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 15),
                      ),
                      Text(
                        validate,
                        style: const TextStyle(color: Colors.green, fontSize: 15),
                      ),
                    ],
                  )),
                ),
              )
            : Scaffold(
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: AuthenticationService.validateEmail,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => AuthenticationService.validatePassword(value!, null),
                      ),
                      TextFormField(
                          controller: passwordConfirmController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password Confirm',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              AuthenticationService.validatePassword(value!, passwordController.text)),
                      TextFormField(
                        controller: lastNameController,
                        validator: (value) =>
                            value!.isEmpty || value.length < 3 ? "Enter a valid last name" : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nom',
                        ),
                      ),
                      TextFormField(
                        controller: firstNameController,
                        validator: (value) =>
                            value!.isEmpty || value.length < 3 ? "Enter a valid last name" : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Prénom',
                        ),
                      ),
                      TextFormField(
                        controller: numTelController,
                        validator: AuthenticationService.validateNumTel,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tel',
                        ),
                      ),
                      TextFormField(
                        controller: carteEtuController,
                        validator: AuthenticationService.validateCarteEtu,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'CarteEtu',
                        ),
                      ),
                      ElevatedButton(
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
                                _authMode = 0;
                              });
                            }
                          }
                        },
                        child: const Text('Inscription'),
                      ),
                      ElevatedButton(
                        child: const Text('Déjà inscrit ?'),
                        onPressed: () => {
                          setState(() {
                            _authMode = 0;
                          })
                        },
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 15),
                      ),
                      Text(
                        validate,
                        style: const TextStyle(color: Colors.green, fontSize: 15),
                      ),
                    ],
                  )),
                ),
              );
  }
}

/*Profile*/
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) => Home.loading
      ? Loader()
      : Center(
          child: Column(children: [
            Text('Bonjour ${Home.user!.lastName} ${Home.user!.firstName}'),
            ElevatedButton(
                onPressed: () async => {
                      setState(() {
                        Home.loading = true;
                      }),
                      await _auth.signOut(),
                      setState(() {
                        Home.loading = false;
                        Home.user = null;
                      }),
                    },
                child: const Text('Log out'))
          ]),
        );
}
