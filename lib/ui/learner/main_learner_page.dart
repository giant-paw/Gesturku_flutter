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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)], // Gradasi dari hijau muda ke putih
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.leaderboard_rounded),
                  label: 'Peringkat', 
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Akun',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.transparent, 
              elevation: 0, 
              selectedItemColor: Colors.green[800],
              unselectedItemColor: Colors.grey[600],
              showUnselectedLabels: false, 
            ),
          ),
        ),
      ),
    );
  }
}