
import 'package:ad_offer_app/Receiver/ReceiverWidgets/receiver_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:ad_offer_app/user_state.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfilesScreen extends StatefulWidget {

  final String userID;

  const ProfilesScreen({
    required this.userID
});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async
  {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

      if (userDoc == null) {
        return;
      }
      else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    }
    catch (error) {} finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactBy({
    required Color color, required Function fct, required IconData icon
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void _openWhatsAppChat() async
  {
    var url = 'https://wa.me/$phoneNumber?text=HelloWorld';
    launchUrlString(url);
  }

  void _mailTo() async
  {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Write subject here, Please&body=Hello, please write details here',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNumber() async
  {
    var url = 'tell://$phoneNumber';
    launchUrlString(url);
  }

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
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffe1e1e1),Color(0xffc0c0c0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: ReceiverBottomNavigationBarForApp(indexNum: 2),
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isLoading
              ?
              const Center(
                child: CircularProgressIndicator(),
              )
              :
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Stack(
                    children: [
                      Card(
                        color: Color(0xc50e638d),
                        margin: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name == null
                                      ?
                                      'Name here'
                                      :
                                      name!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 15,),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Account Information :',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 22.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: userInfo(
                                  icon: Icons.email,
                                  content: email
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: userInfo(
                                    icon: Icons.phone,
                                    content: phoneNumber
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 25,),
                              _isSameUser
                              ?
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: MaterialButton(
                                    onPressed: (){
                                      _logout(context);
                                    },
                                    color: Color(0xff189dbd),
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Logout',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins-Medium',
                                              fontSize: 28,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Icon(
                                            Icons.logout_rounded,
                                            size: 28,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _contactBy(
                                    color: Colors.green,
                                    fct: (){
                                      _openWhatsAppChat();
                                    },
                                    icon: FontAwesome.whatsapp,
                                  ),
                                  _contactBy(
                                    color: Colors.red,
                                    fct: (){
                                      _mailTo();
                                    },
                                    icon: Icons.mail_outline,
                                  ),
                                  _contactBy(
                                    color: Colors.lightGreen,
                                    fct: (){
                                      _callPhoneNumber();
                                    },
                                    icon: Icons.call,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25,),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.26,
                            height: size.width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 3.5,
                                color: Colors.black45,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  imageUrl == null
                                      ?
                                      'https://www.pngitem.com/pimgs/m/579-5798505_user-placeholder-svg-hd-png-download.png'
                                      :
                                      imageUrl,
                                ),
                                fit: BoxFit.fill,
                              )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
