import 'package:doctorsearch/auth/signup_screen.dart';
import 'package:doctorsearch/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import '../utils/utils.dart';
import '../widget/Round_button.dart';
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().then((value) => Get.to(HomeScreen()));

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );


  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool loading = false ;
  final _formKey = GlobalKey<FormState>();

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }
  void signin(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text).then((value) {
      utils().toastMessage(value.user!.email.toString());
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>HomeScreen()));
      setState(() {
        loading = false;
      });
    } ).onError((error, stackTrace) {
      debugPrint(error.toString());
      utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(child: Text('Sign in',style: TextStyle(fontSize: 20),)),
        ),
        body:



        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key:_formKey,
                  child: SizedBox(
                    // height: 80,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailcontroller,
                          obscureText: false,
                          decoration:const InputDecoration(
                              hintText: 'Email',
                              helperText: 'enter email e.g john@gmail.com',
                              prefixIcon: Icon(Icons.alternate_email)

                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return'enter email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordcontroller,

                          obscureText: true,
                          decoration:const InputDecoration(
                            hintText: 'Password',


                          ),

                        ),
                      ],
                    ),
                  )
              ),
              const SizedBox(height: 80),
              RoundButton(
                  title: 'Sign in',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      signin();
                    }
                  }
              ),

              Row(

                children: [
                  Text("Not to Doc Search?"),
                  TextButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context)=>SignupScreenn())
                    );
                  },
                      child: Text('Sign up'))
                ],
              ),

              SizedBox(height: 50),
              InkWell(
                onTap: ()async {
                  try{
                    await signInWithGoogle();

                  }
                  catch(e){
                    Get.to(HomeScreen());
                  };
                },

                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Colors.black
                      )
                  ),
                  child: Center(
                    child: Text('Coninue with google'),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
