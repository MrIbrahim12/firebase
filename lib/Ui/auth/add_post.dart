import 'package:firebase/Ui/utils.dart';
import 'package:firebase/Ui/widgets/round_buttom.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final postcontroller =TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: postcontroller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add your logic ...',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(title: 'Add', loading:loading, ontap: (){
              setState(() {
                loading=true;
              });
              String id =DateTime.now().microsecondsSinceEpoch.toString();
              databaseRef.child(id).set(
                {'title': postcontroller.text.toString(),
                'id':id}
              ).then((value){
                setState(() {
                  loading=false;
                });
                Utils().toastMessage('Post added');
              }).onError((error,stacktrace){
                setState(() {
                  loading=false;
                });
                Utils().toastMessage(error.toString());
              });
    })

          ],
        ),
      ),
    );
  }


}
