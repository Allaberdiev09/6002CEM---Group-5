import 'dart:async';

import 'package:ad_offer_app/Categories/categories.dart';
import 'package:ad_offer_app/Receiver/OfferState/offer_state_list.dart';
import 'package:ad_offer_app/Receiver/ReceiverWidgets/receiver_offer_widget.dart';
import 'package:ad_offer_app/Receiver/Search/search_offer.dart';
import 'package:ad_offer_app/Receiver/ReceiverWidgets/receiver_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReceiverPanel extends StatefulWidget {

  @override
  State<ReceiverPanel> createState() => _ReceiverPanelState();
}

class _ReceiverPanelState extends State<ReceiverPanel> {

  int _backButtonPressedCount = 0;
  late Timer _backButtonTimer;
  String? offerCategoryFilter;
  String? offerStatusFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size})
  {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            backgroundColor: Color(0xe50e638d),
            title: const Text(
              'Filter Offer Category',
              textAlign: TextAlign.center,
              style:
              TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Categories.offerCategoryList.length,
                  itemBuilder: (ctx, index)
                  {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          offerCategoryFilter = Categories.offerCategoryList[index];
                        });
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                        print(
                          'offerCategoryList[index], ${Categories.offerCategoryList[index]}'
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Color(0xffdcdbdb),
                          ),
                          const SizedBox(width: 8),  // Add a SizedBox to create some space between the icon and the text.
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Categories.offerCategoryList[index],
                                style: const TextStyle(
                                  color: Color(0xffdcdbdb),
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,  // Optional: Handle overflow with an ellipsis.
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                onPressed: ()
                {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close', style:
                TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                ),
              ),
              TextButton(
                onPressed: ()
                {
                  setState(() {
                    offerCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel Filter', style:
                TextStyle(
                    color: Colors.white,
                  fontSize: 16,
                ),
                ),
              ),
            ],
          );
        }
    );
  }

  _showStateListDialog({required Size size})
  {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            backgroundColor: Color(0xe50e638d),
            title: const Text(
              'Filter Offer Status',
              textAlign: TextAlign.center,
              style:
              TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: OfferStateList.offerStateList.length,
                  itemBuilder: (ctx, index)
                  {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          offerStatusFilter = OfferStateList.offerStateList[index];
                        });
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                        print(
                            'offerStateList[index], ${OfferStateList.offerStateList[index]}'
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Color(0xffdcdbdb),
                          ),
                          const SizedBox(width: 8),  // Add a SizedBox to create some space between the icon and the text.
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(OfferStateList.offerStateList[index],
                                style: const TextStyle(
                                  color: Color(0xffdcdbdb),
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,  // Optional: Handle overflow with an ellipsis.
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                onPressed: ()
                {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close', style:
                TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                ),
              ),
              TextButton(
                onPressed: ()
                {
                  setState(() {
                    offerStatusFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel Filter', style:
                TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                ),
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _backButtonTimer = Timer(Duration(seconds: 2), () {
      _backButtonPressedCount = 0;
    });
    Categories categoriesObject = Categories();
    categoriesObject.getMyData();
  }

  @override
  void dispose() {
    _backButtonTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (_backButtonPressedCount < 1) {
          // Show a snackbar indicating the need to press back again
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Press back again to exit')),
          );
          _backButtonPressedCount++;
          return false; // Prevent the app from closing
        } else {
          return true; // Let the app exit
        }
      },

    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfff1f1f1),Color(0xffd0d0d0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: ReceiverBottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0a78a1),Color(0xff1c5e86)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 1.0],
              ),

            ),
          ),
          automaticallyImplyLeading: false,
          leading: PopupMenuButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xffdcdbdb),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.filter_list_rounded),
                  title: const Text('Filter Category'),
                  onTap: () {
                    Navigator.pop(context);
                    _showTaskCategoriesDialog(size: size);
                  },
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.filter_alt_outlined),
                  title: const Text('Filter Status'),
                  onTap: () {
                    Navigator.pop(context);
                    _showStateListDialog(size: size);
                  },
                ),
              ),
            ],
          ),

          actions: [
            IconButton(
                icon: const Icon(Icons.search_outlined, color: Color(0xffdcdbdb),),
              onPressed: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()));
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('offers')
              .where('offerCategory', isEqualTo: offerCategoryFilter)
              .where('state', isEqualTo: offerStatusFilter)
              .where('validity', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator(),);
              }
            else if(snapshot.connectionState == ConnectionState.active)
              {
                if(snapshot.data?.docs.isNotEmpty == true)
                  {
                    return ListView.builder
                      (
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index)
                        {
                          return ReceiverOfferWidget(
                            offerTitle: snapshot.data?.docs[index]['offerTitle'],
                            offerDescription: snapshot.data?.docs[index]['offerDescription'],
                            offerId: snapshot.data?.docs[index]['offerId'],
                            uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                            userImage: snapshot.data?.docs[index]['userImage'],
                            name: snapshot.data?.docs[index]['name'],
                            validity: snapshot.data?.docs[index]['validity'],
                            email: snapshot.data?.docs[index]['email'],
                            location: snapshot.data?.docs[index]['location'],
                          );
                        }
                    );
                  }
                else
                  {
                    return const Center(
                      child: Text(
                        'There is no offers'
                      ),
                    );
                  }
              }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          }
        ),
      ),
    ),
    );
  }
}
