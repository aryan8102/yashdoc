import 'package:doctorsearch/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screen/patient_info.dart';
import '../utils/utils.dart';
import '../widget/Round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificartionId;
  const VerifyCodeScreen({Key? key, required this.verificartionId}):super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '6 digit code ',
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(title: 'Verify', loading: loading, onTap: () async {
              setState(() {
                loading = true;
              });

              final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verificartionId,
                  smsCode: verificationCodeController.text.toString());

              try {
                await auth.signInWithCredential(crendital);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PatientInfoScreen()));
              } catch (e) {
                setState(() {
                  loading = true;
                });
                utils().toastMessage(e.toString());
              }
            }
            )

          ],
        ),
      ),
    );
  }
}
