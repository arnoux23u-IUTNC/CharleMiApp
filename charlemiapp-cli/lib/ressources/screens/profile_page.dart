import 'home.dart';
import '../loader.dart';
import '../assets/colors.dart';
import '../../models/transaction_data.dart';
import '../../services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

final AuthenticationService _auth = AuthenticationService();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> balance;
  late Future<List<TransactionData>> transactions;

  @override
  void initState() {
    super.initState();
    balance = Home.user!.getBalance();
    transactions = Home.user!.getTransactions();
  }

  @override
  Widget build(BuildContext context) => Home.loading
      ? const Loader()
      : Container(
          height: MediaQuery.of(context).size.height,
          color: darkColor,
          child: Scrollbar(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 50),
                    child: Text('Bonjour ${Home.user?.firstName}',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600)),
                  )),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FutureBuilder<String>(
                      future: balance,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Text('Votre solde est de ${snapshot.data} €',
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400))
                            : snapshot.hasError
                                ? Text('Votre solde est de -- €',
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400))
                                : const CircularProgressIndicator();
                      },
                    ),
                  )),
                  Container(
                      padding: const EdgeInsets.only(left: 55, right: 55, bottom: 15),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async => {
                          setState(() {
                            Home.loading = true;
                          }),
                          await _auth.signOut(),
                          setState(() {
                            Home.loading = false;
                            Home.user = null;
                          }),
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)), (route) => false)
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => _buildPopupBalance(context),
                            );
                          },
                          child: Text(
                            'Modifier mon solde',
                            style: GoogleFonts.poppins(color: colorAmbre, fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                        ),
                      )),
                  Container(
                      padding: const EdgeInsets.only(left: 55, right: 55),
                      width: double.infinity,
                      child: FutureBuilder<List<TransactionData>>(
                        future: transactions,
                        builder: _buildTransactions,
                      )),
                  Container(
                      padding: const EdgeInsets.only(left: 55, right: 55, top: 30, bottom: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async => {
                          setState(() {
                            Home.loading = true;
                          }),
                          await _auth.signOut(),
                          setState(() {
                            Home.loading = false;
                            Home.user = null;
                          }),
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)), (route) => false)
                        },
                        child: Text(
                          'Se déconnecter',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(buttonBlueColor),
                            padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                      )),
                  Container(
                      padding: const EdgeInsets.only(left: 55, right: 55, bottom: 15),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async => {
                          setState(() {
                            Home.loading = true;
                          }),
                          await _auth.signOut(),
                          setState(() {
                            Home.loading = false;
                            Home.user = null;
                          }),
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)), (route) => false)
                        },
                        child: ElevatedButton(
                          onPressed: () async => {
                            setState(() {
                              Home.loading = true;
                            }),
                            await _auth.deleteAccount(),
                            setState(() {
                              Home.loading = false;
                              Home.user = null;
                            }),
                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)), (route) => false)
                          },
                          child: Text(
                            'Supprimer mon compte',
                            style: GoogleFonts.poppins(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                        ),
                      )),
                ])),
          ),
        );

  Widget _buildPopupBalance(BuildContext context) {
    var _controller = TextEditingController();
    return AlertDialog(
      title: const Text('Modification de solde'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Solde',
            ),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}(\.\d{0,2})?'))],
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            if (_controller.text.isNotEmpty) {
              await Home.user!.updateBalance(double.parse(_controller.text));
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)),
                (Route<dynamic> route) => false,
              );
            } else {
              Fluttertoast.showToast(
                msg: "Montant invalide",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            }
          },
          child: const Text('Valider'),
        ),
      ],
    );
  }

  Widget _buildTransactions(BuildContext context, AsyncSnapshot<List<TransactionData>> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(TransactionData.transform(snapshot.data![index].category)),
              subtitle: Text(snapshot.data![index].date),
              trailing: Text("${snapshot.data![index].amount.toString()}€"),
            ),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Text('Aucune transaction trouvée',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400));
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
