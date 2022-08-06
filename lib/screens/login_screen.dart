import 'dart:ui';

import 'package:admin_app/screens/categories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login-page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double _widthS = MediaQuery.of(context).size.width;
    double _heightS = MediaQuery.of(context).size.height;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 200,
                  left: -100,
                  child: Container(
                    width: _widthS / 3,
                    height: _heightS / 4,
                    decoration: BoxDecoration(
                      color: Colors.orange[400],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(150),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: -10,
                  child: Container(
                    width: _widthS / 10,
                    height: _heightS / 5,
                    decoration: BoxDecoration(
                      color: Colors.orange[400],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 80,
                      sigmaY: 80,
                    ),
                    child: Container(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        _logo(),
                        const SizedBox(
                          height: 70,
                        ),
                        _loginLabel(),
                        const SizedBox(
                          height: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: GoogleFonts.josefinSans(
                                textStyle: const TextStyle(
                                  color: Color(0xff8fa1b6),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              obscureText: false,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                hintText: 'enter email',
                                hintStyle: GoogleFonts.josefinSans(
                                  textStyle: const TextStyle(
                                    color: Color(0xffc5d2e1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffdfe8f3)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                       Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.josefinSans(
                                textStyle: const TextStyle(
                                  color: Color(0xff8fa1b6),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.red,
                              decoration: InputDecoration(
                                hintText: 'enter password',
                                hintStyle: GoogleFonts.josefinSans(
                                  textStyle: const TextStyle(
                                    color: Color(0xffc5d2e1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffdfe8f3)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 90,
                        ),
                        _loginBtn(),
                        const SizedBox(
                          height: 90,
                        ),
                        // _signUpLabel("Don't have an account yet?",
                        //     const Color(0xff909090)),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // _signUpLabel("Sign Up", const Color(0xff164276)),
                        // const SizedBox(
                        //   height: 35,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
  return Container(
    width: double.infinity,
    height: 60,
    decoration: const BoxDecoration(
      color: Color(0xff008fff),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: TextButton(
      onPressed: () => {
        Login()
      },
      child: Text(
        "Login",
        style: GoogleFonts.josefinSans(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
    ),
  );

}

  Future Login()async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((value) => Navigator.of(context).pushNamed(CategoriesScreen.routeName));
  } on FirebaseAuthException catch(e){print(e);}
}
}

Widget _signUpLabel(String label, Color textColor) {
  return Text(
    label,
    style: GoogleFonts.josefinSans(
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w800,
        fontSize: 18,
      ),
    ),
  );
}





Widget _loginLabel() {
  return Center(
    child: Text(
      "Admin Login",
      style: GoogleFonts.josefinSans(
        textStyle: const TextStyle(
          color: Color(0xff164276),
          fontWeight: FontWeight.w900,
          fontSize: 34,
        ),
      ),
    ),
  );
}

Widget _logo() {
  return Center(
    child: SizedBox(
      child: Text(
        'BROTCHEN2U',
        style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      height: 80,
    ),
  );
}
