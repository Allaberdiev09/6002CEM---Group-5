import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ad_offer_app/Offers/offers_screen.dart';
import 'package:ad_offer_app/Services/global_methods.dart';
import 'package:ad_offer_app/Services/global_variables.dart';
import 'package:ad_offer_app/CommonWidgets/chat_widget.dart';
import 'package:uuid/uuid.dart';

class OfferDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String offerID;

  const OfferDetailScreen({
    required this.uploadedBy,
    required this.offerID,
  });

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _chatController = TextEditingController();
  bool _isChatting = false;

  String? authorName;
  String? userImageUrl;
  String? offerCategory;
  String? offerDescription;
  String? offerTitle;
  bool? validity;
  Timestamp? postedDateTimeStamp;
  String? postedDate;
  String? locationCompany = '';
  String? emailCompany = '';
  bool showChat = false;
  String? state;

  void getOfferData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot offerDatabase = await FirebaseFirestore.instance
        .collection('offers')
        .doc(widget.offerID)
        .get();

    if (offerDatabase == null) {
      return;
    } else {
      setState(() {
        offerTitle = offerDatabase.get('offerTitle');
        offerDescription = offerDatabase.get('offerDescription');
        validity = offerDatabase.get('validity');
        emailCompany = offerDatabase.get('email');
        locationCompany = offerDatabase.get('location');
        postedDateTimeStamp = offerDatabase.get('createdAt');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
        state = offerDatabase.get('state');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOfferData();
  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
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
            icon: const Icon(
              Icons.close,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OfferScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Color(0xc50e638d),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            offerTitle == null ? '' : offerTitle!,
                            maxLines: 3,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null ? '' : authorName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xffdcdbdb),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    locationCompany!,
                                    style: const TextStyle(color: Color(0xffdcdbdb),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dividerWidget(),
                                  const Text(
                                    'Validity',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xffdcdbdb),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection('offers')
                                                  .doc(widget.offerID)
                                                  .update(
                                                      {'validity': true});
                                            } catch (error) {
                                              GlobalMethod.showErrorDialog(
                                                error:
                                                    'Action cannot be performed',
                                                ctx: context,
                                              );
                                            }
                                          getOfferData();
                                        },
                                        child: const Text(
                                          'ON',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xffdcdbdb),
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: validity == true ? 1 : 0,
                                        child: const Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('offers')
                                                .doc(widget.offerID)
                                                .update(
                                                {'validity': false});
                                          } catch (error) {
                                            GlobalMethod.showErrorDialog(
                                              error:
                                              'Action cannot be performed',
                                              ctx: context,
                                            );
                                          }
                                          getOfferData();
                                        },
                                        child: const Text(
                                          'OFF',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xffdcdbdb),
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: validity == false ? 1 : 0,
                                        child: const Icon(
                                          Icons.check_box,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        dividerWidget(),
                        const Text(
                          'Offer Description',
                          style: TextStyle(
                            color: Color(0xffdcdbdb),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          offerDescription == null ? '' : offerDescription!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xffdcdbdb),
                          ),
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Uploaded on:',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              postedDate == null ? '' : postedDate!,
                              style: const TextStyle(
                                color: Color(0xffdcdbdb),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Color(0xc50e638d),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          child: _isChatting
                        ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: TextField(
                                        controller: _chatController,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                        maxLength: 200,
                                        keyboardType: TextInputType.text,
                                        maxLines: 6,
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xffececec),
                                          enabledBorder:
                                              UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder:
                                              OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: MaterialButton(
                                              onPressed: () async{
                                                if(_chatController.text.length < 0)
                                                  {
                                                    GlobalMethod.showErrorDialog(
                                                      error: 'Message cannot empty',
                                                      ctx: context,
                                                    );
                                                  }
                                                else
                                                  {
                                                    final _generatedId = const Uuid().v4();
                                                    await FirebaseFirestore.instance
                                                    .collection('offers')
                                                    .doc(widget.offerID)
                                                    .update({
                                                      'offerChat':
                                                          FieldValue.arrayUnion([{
                                                            'userId': FirebaseAuth.instance.currentUser!.uid,
                                                            'chatId': _generatedId,
                                                            'name': name,
                                                            'userImageUrl': userImage,
                                                            'chatBody': _chatController.text,
                                                            'time': Timestamp.now(),
                                                          }]),
                                                    });
                                                    await Fluttertoast.showToast(
                                                      msg: 'Your message has been sent',
                                                      toastLength: Toast.LENGTH_LONG,
                                                      backgroundColor: Colors.grey,
                                                      fontSize: 18.0,
                                                    );
                                                    _chatController.clear();
                                                  }
                                                setState(() {
                                                  showChat = true;
                                                });
                                              },
                                              color: Colors.blueAccent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'Send',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _isChatting = !_isChatting;
                                                showChat = false;
                                              });
                                            },
                                            child: const Text(
                                              'Cancel', style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                        :
                          Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isChatting = !_isChatting;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.message,
                                        color: Color(0xffececec),
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showChat = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Color(0xffececec),
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        showChat == false
                            ?
                            Container()
                            :
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('offers')
                                    .doc(widget.offerID)
                                    .get(),
                                builder: (context, snapshot)
                                {
                                  if(snapshot.connectionState == ConnectionState.waiting)
                                    {
                                      return const Center(child: CircularProgressIndicator(),);
                                    }
                                  else
                                  {
                                    if(snapshot.data == null)
                                      {
                                        const Center(child: Text('No messages yet'),);
                                      }
                                  }
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index)
                                    {
                                      return ChatWidget(
                                        chatId: snapshot.data!['offerChat'] [index]['chatId'],
                                        writerId: snapshot.data!['offerChat'] [index]['userId'],
                                        writerName: snapshot.data!['offerChat'] [index]['name'],
                                        writerBody: snapshot.data!['offerChat'] [index]['chatBody'],
                                        writerImageUrl: snapshot.data!['offerChat'] [index]['userImageUrl'],
                                      );
                                    },
                                    separatorBuilder: (context, index)
                                    {
                                      return const Divider(
                                        thickness: 1,
                                        color: Color(0xffececec),
                                      );
                                    },
                                    itemCount: snapshot.data!['offerChat'].length,
                                  );
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
