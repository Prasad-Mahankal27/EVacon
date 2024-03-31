import 'package:ev/auth/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
 
  TextEditingController _emailController=TextEditingController();
forgotpassword(String email) async {
if(email==""){
return UiHelper.CustomAlertBox(context, "Enter an email to reset password");
}
else{
  FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(_emailController, "Email", Icons.mail, false),
       const SizedBox(height: 10,),
       ElevatedButton(onPressed: (){forgotpassword(_emailController.text.toString());}, child: Text("Reset Password")),
  ],
      ),
    );
  }
}