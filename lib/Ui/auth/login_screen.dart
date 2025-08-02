import 'package:firebase/Ui/auth/login_with_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase/Ui/utils.dart';
import 'package:firebase/Ui/post_screen.dart';
import 'package:firebase/Ui/auth/sign_up_screen.dart';
import 'package:firebase/Ui/widgets/round_buttom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    setState(() => loading = true);
    _auth
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text.trim(),
    )
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostScreen()));
    })
        .catchError((error) {
      Utils().toastMessage(error.toString());
    })
        .whenComplete(() => setState(() => loading = false));
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      // 🔴 Important: Sign out previous session to allow account selection
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      Utils().toastMessage("Logged in as ${userCredential.user!.email}");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostScreen()),
      );
    } catch (e) {
      Utils().toastMessage("Google login error: $e");
    }
  }


  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [], // empty permissions
    );

    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken;
      final facebookAuthCredential =
      FacebookAuthProvider.credential(accessToken!.token);

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      Utils().toastMessage("Logged in as ${userCredential.user!.email}");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostScreen()),
      );
    } else {
      print('Facebook login failed: ${result.message}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Login', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder()),
                          validator: (value) =>
                          value!.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() => _obscureText = !_obscureText);
                              },
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? 'Enter password' : null,
                        ),
                      ],
                    )),
                const SizedBox(height: 50),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  ontap: () {
                    if (_formKey.currentState!.validate()) login();
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xff313957))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR',
                          style: TextStyle(color: Color(0xff313957))),
                    ),
                    Expanded(child: Divider(color: Color(0xff313957))),
                  ],
                ),
                const SizedBox(height: 30),
                SocialButton(
                  icon: Image.asset('assets/goggle.png', height: 24),
                  text: 'Sign in with Google',
                  onPressed: signInWithGoogle,
                ),
                const SizedBox(height: 10),
                SocialButton(
                  icon: Image.asset('assets/facebook.png', height: 24),
                  text: 'Sign in with Facebook',
                  onPressed: signInWithFacebook,
                ),
                SizedBox(height: 10,),
               InkWell(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhone()));
                 },
                 child: Container(
                   height: 50,
                   width: 250,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(50),
                     border: Border.all(color: Colors.black)
                   ),
                   child:  Center(
                     child: Text('Login with Phone'),
                   ),
                 ),
               ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: const Text('Sign up'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
