import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teeth_identification_final_year_project/screens/sign_up_screen.dart';
import 'package:teeth_identification_final_year_project/widgets/submit_button.dart';
import 'package:teeth_identification_final_year_project/widgets/text_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("images/teeth_splash.webp",),
                ),
              ),
              const SizedBox(height: 20,),
              TextWidget1(text: "Sign In", fontSize: 20.dp, fontWeight: FontWeight.bold, isTextCenter: false, textColor: Colors.black),
              const SizedBox(height: 50,),
              // InputField(inputController: inputController)
              _image != null
                  ? Image.file(
                _image!,
                height: 200,
                width: 200,
              )
                  : TextWidget1(text: "Pick Image", fontSize: 14.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: Colors.black),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SubmitButton(
                    width: 35.w,
                      title: "Gallery",
                      press: (){
                        _pickImage(ImageSource.gallery);
                      }
                  ),
                  SubmitButton(
                      width: 35.w,
                      title: "Camera",
                      press: (){
                        _pickImage(ImageSource.camera);
                      }
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              SubmitButton(
                  width: 78.w,
                  title: "Sign In",
                  press: (){

                  }
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget1(
                      text: "Don't have an account?",
                      fontSize: 16.dp,
                      fontWeight: FontWeight.w500,
                      isTextCenter: false,
                      textColor: Colors.black
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
                    },
                    child: TextWidget1(
                        text: "Sign Up",
                        fontSize: 16.dp,
                        fontWeight: FontWeight.w500,
                        isTextCenter: false,
                        textColor: Colors.blue
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
