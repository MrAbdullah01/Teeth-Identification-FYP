import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:teeth_identification_final_year_project/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.name,
    required this.percentage,
  });

  final String name;
  final double percentage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          title: TextWidget1(
              text: "Home Screen",
              fontSize: 18.dp, fontWeight: FontWeight.bold,
              isTextCenter: false, textColor: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                height: 25.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: TextWidget1(
                          text: "Your Details", fontSize: 20.dp,
                          fontWeight: FontWeight.bold, isTextCenter: false,
                          textColor: Colors.white),
                    ),
                    const SizedBox(height: 20,),
                    TextWidget1(
                        text: "Name : ${widget.name}", fontSize: 18.dp,
                        fontWeight: FontWeight.w500, isTextCenter: false,
                        textColor: Colors.white),
                    const SizedBox(height: 20,),
                    TextWidget1(
                        text: "Similarity Percentage : ${widget.percentage}", fontSize: 18.dp,
                        fontWeight: FontWeight.w500, isTextCenter: false,
                        textColor: Colors.white),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
