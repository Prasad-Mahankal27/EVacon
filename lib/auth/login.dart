import 'package:ev/auth/ForgotPassword.dart';
import 'package:ev/auth/homepage.dart';
import 'package:ev/auth/signUp.dart';
import 'package:ev/auth/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
 
login(String email, String password) async{
   if(email=="" && password==""){
    UiHelper.CustomAlertBox(context, "Enter required Fields");
  }
  else{
     UserCredential? usercredential;
     try{
      usercredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const MyApp();
        },));
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
            login(_emailController.text.toString(), _passwordController.text.toString());
          }, child: const Text("Login", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              TextButton(onPressed: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
                return const SignUp();
              })));}, child: const Text("Sign Up", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
            ],
          ),
          SizedBox(height: 5,),
          TextButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
                return const ForgotPassword();
              })));
          }, child: const Text("Forgot Pasword??", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),)
        ],
      ),
    );
  }
}

