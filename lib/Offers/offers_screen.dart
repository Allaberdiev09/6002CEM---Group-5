import 'package:ad_offer_app/Categories/categories.dart';
import 'package:ad_offer_app/Receiver/OfferState/offer_state_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ad_offer_app/CommonWidgets/bottom_nav_bar.dart';
import 'package:ad_offer_app/CommonWidgets/offer_widget.dart';

class OfferScreen extends StatefulWidget {
  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? offerCategoryFilter;
  String? offerStatusFilter;

  _showTaskCategoriesDialog({required Size size})
  {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            backgroundColor: Color(0xe50e638d),
            title: const Text(
              'Offer Category',
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffe0e0e0),Color(0xfff8f8f8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0a78a1),Color(0xff1c5e86)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 1.0],
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
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('offers')
              .where('validity', isEqualTo: true)
              .where('uploadedBy', isEqualTo: _auth.currentUser!.uid)
              .where('offerCategory', isEqualTo: offerCategoryFilter)
              .where('state', isEqualTo: offerStatusFilter)
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final offerData = snapshot.data!.docs[index].data();
                    return OfferWidget(
                      offerTitle: offerData['offerTitle'],
                      offerDescription: offerData['offerDescription'],
                      offerId: offerData['offerId'],
                      uploadedBy: offerData['uploadedBy'],
                      userImage: offerData['userImage'],
                      name: offerData['name'],
                      validity: offerData['validity'],
                      email: offerData['email'],
                      location: offerData['location'],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('You have not made any offer yet'),
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
          },
        ),
      ),
    );
  }
}
