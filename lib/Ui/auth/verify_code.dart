import 'package:firebase/Ui/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils.dart';
import '../widgets/round_buttom.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final verifycodecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 80),
            TextFormField(
              controller: verifycodecontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '6 digit code',
              ),
            ),
            SizedBox(height: 100),
            RoundButton(
              title: 'Verify',
              loading: loading,
              ontap: () async{
                setState(() {
                  loading=true;
                });
               final credential =PhoneAuthProvider.credential(
                   verificationId: widget.verificationId,
                   smsCode: verifycodecontroller.text.toString());
               try{
                 await auth.signInWithCredential(credential);
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
               }catch(e){
                 setState(() {
                   loading=false;
                 });
                 Utils().toastMessage(e.toString());
               }
              },
            ),
          ],
        ),
      ),
    );
  }
}
