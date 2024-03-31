import 'package:ev/auth/homepage.dart';
import 'package:ev/auth/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();

 signUp(String email, String password) async{
  if(email=="" && password==""){
    UiHelper.CustomAlertBox(context, "Enter required Fields");
  }
  else{
    UserCredential? usercredential;
    try{
      usercredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
                return const MyApp();
              })));
      });
    }
    on FirebaseAuthException catch(ex){
      return UiHelper.CustomAlertBox(context, ex.code.toString());
    }
  }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(_emailController, "Email", Icons.mail, false),
          const SizedBox(height: 10,),
          UiHelper.CustomTextField(_passwordController, "Password", Icons.password, true),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: (){
            signUp(_emailController.text.toString(), _passwordController.text.toString());
          }, child: const Text("Sign Up", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),),
          const SizedBox(height: 20,),
          ],
      ),
    );;
  }
}