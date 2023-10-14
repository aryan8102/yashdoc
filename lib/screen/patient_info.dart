import 'package:doctorsearch/screen/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';
import '../widget/Round_button.dart';

class PatientInfoScreen extends StatefulWidget {
  const PatientInfoScreen({super.key});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {



  final nameController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post2');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Yourself',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),



            TextFormField(
              maxLines: 1,
              controller: nameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder()

              ),
            ),



            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: (){
                  setState(() {
                    loading=true;
                  });
                  databaseRef.child(DateTime.now().microsecondsSinceEpoch.toString()).set({

                    'name':nameController.text.toString(),

                    'id':DateTime.now().microsecondsSinceEpoch.toString(),
                  }).then((value){
                    utils().toastMessage('Registered');
                    setState(() {
                      loading=false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  }).onError((error, stackTrace) {
                    utils().toastMessage(error.toString());
                    setState(() {
                      loading=false;
                    });
                  });
                }

            ),

          ],

        ),


      ),


    );
  }
}
