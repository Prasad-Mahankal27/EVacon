import 'package:flutter/material.dart';

class UiHelper{
  static CustomTextField(TextEditingController controller, String text, IconData iconData, bool toHide){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          )
        ),
      ),
    );
  }

  static CustomAlertBox(BuildContext context, String text){
  return showDialog(context: context, builder: (BuildContext context){
return AlertDialog(
  title: Text(text, style: TextStyle(fontSize: 20),),
  actions: [
    TextButton(onPressed: (){
      Navigator.pop(context);
    }, child: Text("OK"),)
  ],
);
  });
}

static TextS(String data){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(data, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
  );
}
}

