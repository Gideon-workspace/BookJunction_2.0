// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ViewPicture extends StatelessWidget{
  final String image;
  const ViewPicture({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,


        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new,size: 18,),
        
         onPressed: () { 
            Navigator.pop(context);

         },),

         title: Padding(
           padding: EdgeInsets.only(left:screenSize.width*0.23),
           child: Text('View',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
         ),
      ),

      body: Expanded(
        child: Center(
          child:Image.network(image) ,),),
    );
  }
}