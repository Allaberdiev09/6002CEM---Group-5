import 'package:ad_offer_app/Receiver/profiles.dart';
import 'package:ad_offer_app/Receiver/Search/search_clients.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ad_offer_app/Receiver/receiver_panel.dart';
import 'package:ad_offer_app/user_state.dart';

class ReceiverBottomNavigationBarForApp extends StatelessWidget {

  int indexNum = 0;

  ReceiverBottomNavigationBarForApp({required this.indexNum});

  void _logout(context)
  {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
      context: context,
      builder: (context)
        {
          return AlertDialog(
            backgroundColor: Color(0xe50e638d),
            title: Row(
              children: const [
                Padding(
                    padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Do you want to Log Out?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('No', style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
              TextButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserState()));
                },
                child: const Text('Yes', style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Color(0xff097096),
      backgroundColor: Color(0xff3b9ac2),
      buttonBackgroundColor: Color(0xff055675),
      height: 50,
      index: indexNum,
      items: const [
        Icon(Icons.list, size: 21, color: Color(0xffdcdbdb),),
        Icon(Icons.search, size: 21, color: Color(0xffdcdbdb),),
        Icon(Icons.person_pin, size: 21, color: Color(0xffdcdbdb),),
        Icon(Icons.exit_to_app, size: 21, color: Color(0xffdcdbdb),),
      ],
      animationDuration: Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index)
      {
        if(index == 0)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReceiverPanel()));
          }
        else if(index == 1)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllClientsScreen()));
        }
        else if(index == 2)
        {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfilesScreen(
            userID: uid,
          )));
        }
        else if(index == 3)
        {
        _logout(context);
        }
      },
    );
  }
}
