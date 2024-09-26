import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:teeth_identification_final_year_project/screens/home_screen.dart';
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

  bool isLoading = false;

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

  Future<void> _signIn(File image) async {
    // Replace with your API endpoint
    String uploadUrl = 'https://33b5-2400-adc7-14a-6200-d9c1-ae3c-7f3-3fc6.ngrok-free.app/signin/';

    try {
      setState(() {
        isLoading = true;
      });
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath('reference_image', image.path));

      // Send the request
      var response = await request.send();

      final res = await http.Response.fromStream(response);

      // Handle the response
      if (response.statusCode == 200) {

        final jsonResponse = jsonDecode(res.body);
        final percentage = jsonResponse['highest_similarity_score'];
        final name = jsonResponse['name'];

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                  name: name,
                  percentage: percentage
              ),));

        setState(() {
          isLoading = false;
        });

        log('Image uploaded successfully');
        log('Response: ${res.body}');
      } else {
        log('Image upload failed with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      log('Image upload failed: $e');
    }
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
              isLoading ?
              const CircularProgressIndicator(color: Colors.blue,) :
              SubmitButton(
                  width: 78.w,
                  title: "Sign In",
                  press: (){
                    if(_image != null){
                      _signIn(_image!);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Image is not Selected!'),
                          duration: Duration(seconds: 3), // Set the duration for how long the snackbar will be visible
                        ),
                      );
                    }
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
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
