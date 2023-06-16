import 'package:ad_offer_app/Receiver/ReceiverWidgets/receiver_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ad_offer_app/Receiver/ReceiverWidgets/all_clients_widget.dart';

import '../receiver_panel.dart';

class AllClientsScreen extends StatefulWidget {
  @override
  State<AllClientsScreen> createState() => _AllClientsScreenState();
}

class _AllClientsScreenState extends State<AllClientsScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = '';

  _getBackToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ReceiverPanel()),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for companies...',
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
    return WillPopScope(
      onWillPop: () async {
        return _getBackToHome();
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
        bottomNavigationBar: ReceiverBottomNavigationBarForApp(indexNum: 1),
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
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'sender')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              final List<QueryDocumentSnapshot<Object?>> documents =
                  snapshot.data?.docs ?? [];

              final List<QueryDocumentSnapshot<Object?>> filteredDocuments = documents
                  .where((doc) =>
                  doc['name'].toString().toLowerCase().contains(searchQuery))
                  .toList();

              if (filteredDocuments.isNotEmpty) {
                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = filteredDocuments[index];
                    return AllClientsWidget(
                      userID: user['id'] as String,
                      userName: user['name'] as String,
                      userEmail: user['email'] as String,
                      phoneNumber: user['phoneNumber'] as String,
                      userImageUrl: user['userImage'] as String,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No users found.'),
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
    ),
    );
  }
}
