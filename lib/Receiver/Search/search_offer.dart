import 'package:ad_offer_app/Receiver/ReceiverWidgets/receiver_offer_widget.dart';
import 'package:ad_offer_app/Receiver/receiver_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for offers...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _clearSearchQuery();
        },
      ),
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery.toLowerCase();
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfff1f1f1),Color(0xffd0d0d0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
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
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReceiverPanel()),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('offers')
              .where('validity', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                  snapshot.data?.docs ?? [];

              final List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredDocuments = documents
                  .where((doc) =>
                  doc['offerTitle'].toString().toLowerCase().contains(searchQuery))
                  .toList();

              if (filteredDocuments.isNotEmpty) {
                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final offer = filteredDocuments[index];

                    return ReceiverOfferWidget(
                      offerTitle: offer['offerTitle'],
                      offerDescription: offer['offerDescription'],
                      offerId: offer['offerId'],
                      uploadedBy: offer['uploadedBy'],
                      userImage: offer['userImage'],
                      name: offer['name'],
                      validity: offer['validity'],
                      email: offer['email'],
                      location: offer['location'],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No offers found.',
                  ),
                );
              }
            }

            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
