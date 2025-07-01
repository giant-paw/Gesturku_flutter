import 'package:flutter/material.dart';
import 'pages/akun_page.dart';
import 'pages/beranda_page.dart';
import 'pages/informasi_page.dart';

class MainLearnerPage extends StatefulWidget {
  const MainLearnerPage({super.key});

  @override
  State<MainLearnerPage> createState() => _MainLearnerPageState();
}

class _MainLearnerPageState extends State<MainLearnerPage> {
  int _selectedIndex = 0; 

  static const List<Widget> _widgetOptions = <Widget>[
    BerandaPage(),
    InformasiPage(),
    AkunPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex, 
        selectedItemColor: Colors.blue[800], 
        onTap: _onItemTapped,
      ),
    );
  }
}