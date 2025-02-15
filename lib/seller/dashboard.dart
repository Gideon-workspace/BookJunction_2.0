import 'package:bookjunction2_0/Seller/dashboard2.dart';
import 'package:bookjunction2_0/seller/home.dart';
import 'package:bookjunction2_0/seller/settings.dart';
import 'package:bookjunction2_0/seller/withdrawal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


class Home extends StatefulWidget{
  const Home({super.key});

  @override
  _HomeState createState()=> _HomeState();
  }
  
  class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Homepage(),
    const Dashboard2(),
    Withdrawal(),
     Profile(),

  

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Set the color of the selected item
    
        items: const [
          BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_pie), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.wallet), label: 'Withdraw'),
          BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.user_cog), label: 'Profile Setting'),
        ],
      ),
    );
  }
}