import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:teeth_identification_final_year_project/screens/sign_in_screen.dart';
import 'package:teeth_identification_final_year_project/widgets/input_field.dart';
import 'package:teeth_identification_final_year_project/widgets/submit_button.dart';
import 'package:teeth_identification_final_year_project/widgets/text_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var userNameC = TextEditingController();

  File? _image;

  bool isLoading = false;

  final String url = "https://33b5-2400-adc7-14a-6200-d9c1-ae3c-7f3-3fc6.ngrok-free.app/signup/";

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        log('No image selected.');
      }
    });
  }

  Future<void> _signUp(context,File image, String name) async {
    // Replace with your API endpoint
    String uploadUrl = url;

    try {
      // Create a multipart request
      setState(() {
        isLoading = true;
      });

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      request.fields['username'] = name;

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      // Add the string variable to the request

      // Send the request
      var response = await request.send();

      // Read the response
      final res = await http.Response.fromStream(response);

      // Handle the response
      if (response.statusCode == 200) {
        log('Image and data uploaded successfully');
        log('Response: ${res.body}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen(),));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Created Successfully!'),
            duration: Duration(seconds: 3), // Set the duration for how long the snackbar will be visible
          ),
        );
        setState(() {
          isLoading = false;
        });

      } else {
        log('Upload failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Creation Failed!'),
            duration: Duration(seconds: 3), // Set the duration for how long the snackbar will be visible
          ),
        );
        log('Response: ${res.body}');
        setState(() {
          isLoading = false;
        });

      }
    } catch (e) {
      log('Upload failed: $e');
      setState(() {
        isLoading = false;
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("images/teeth_splash.webp",),
                ),
              ),
              const SizedBox(height: 20,),
              Center(child: TextWidget1(text: "Sign Up", fontSize: 18.dp, fontWeight: FontWeight.bold, isTextCenter: false, textColor: Colors.black)),
              const SizedBox(height: 50,),
              TextWidget1(text: "User Name", fontSize: 14.dp,
                  fontWeight: FontWeight.w500, isTextCenter: false, textColor: Colors.black),
              const SizedBox(height: 10,),
              InputField(
                  inputController: userNameC,
                bdRadius: 10,
                hintText: "Enter User Name",
              ),
              const SizedBox(height: 10,),
              // InputField(inputController: inputController)
              _image != null
                  ? Image.file(
                _image!,
                height: 200,
                width: 200,
              )
                  : TextWidget1(text: "Pick Image", fontSize: 14.dp,
                  fontWeight: FontWeight.w500, isTextCenter: false, textColor: Colors.black),
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
              Center(
                child: isLoading ?
                const CircularProgressIndicator(color: Colors.blue,) :
                SubmitButton(
                    width: 78.w,
                    title: "Sign Up",
                    press: (){
                      // uploadUsernameAndFile(userNameC.text.toString(), _image!);
                      _signUp(context,_image!, userNameC.text.toString());
                      // signIn(name: userNameC.text.toString(), image: _image!);
                    }
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget1(
                      text: "Already have an account?",
                      fontSize: 16.dp,
                      fontWeight: FontWeight.w500,
                      isTextCenter: false,
                      textColor: Colors.black
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: TextWidget1(
                        text: "Sign in",
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


class ApiService{
  static Future<http.StreamedResponse> multipartPost({
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, String> fields,
    // required List<File> files,
  }) async {
    try {
      final Uri url = Uri.parse(endPoint);

      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields.addAll(fields);

      // for (File file in files) {
      //   String fileName = p.basename(file.path); // Use basename to get the filename
      //   request.files.add(
      //     await http.MultipartFile.fromPath(
      //       'file', // The field name for the file
      //       file.path,
      //       filename: fileName,
      //     ),
      //   );
      // }

      http.StreamedResponse response = await request.send();
      // var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return response;
      }
    } on SocketException {
      throw Exception('SocketException');
    }
  }
}


// Future<void> uploadUsernameAndFile(String username, File imageFile) async {
//   // Create a multipart request
//   var request = http.MultipartRequest('POST', Uri.parse(url));
//
//   // Add username as a form field
//   request.fields['username'] = username;
//
//   // Add the file (image)
//   request.files.add(await http.MultipartFile.fromPath(
//     'file', // This is the key for the file in your backend
//     imageFile.path,
//     filename: basename(imageFile.path),
//   ));
//
//   // Send the request
//   var response = await request.send();
//
//   // Get the response from the server
//   if (response.statusCode == 200) {
//     var responseData = await response.stream.bytesToString();
//     log('Response: $responseData');
//   } else {
//     log('Failed to upload. Status code: ${response.statusCode}');
//   }
// }

// Future<void> signIn({
//   required String name,
//   required File image,
// }) async{
//
//   try{
//     final body = {
//       "username" : name,
//       "reference_image" : image.path,
//     };
//     log("Screen Body:: $body");
//     var headers = {'Content-Type': 'application/json'};
//     final request = await ApiService.multipartPost(
//         fields: body,
//         headers: headers,
//         endPoint: url
//     );
//
//     log("Status Code:: ${request.statusCode}");
//     if(request.statusCode == 200 || request.statusCode == 201){
//       final responseBody = await request.stream.bytesToString();
//       final jsonResponse = json.decode(responseBody);
//
//       log(jsonResponse);
//
//       setState(() {
//         isLoading = false;
//       });
//     }
//     else{
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }catch (e){
//     throw e.toString();
//   }
// }
