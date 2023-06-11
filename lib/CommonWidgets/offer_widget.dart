import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ad_offer_app/Offers/offer_details.dart';
import 'package:ad_offer_app/Services/global_methods.dart';

class OfferWidget extends StatefulWidget {

  final String offerTitle;
  final String offerDescription;
  final String offerId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool validity;
  final String email;
  final String location;

  const OfferWidget({
    required this.offerTitle,
    required this.offerDescription,
    required this.offerId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.validity,
    required this.email,
    required this.location,
});

  @override
  State<OfferWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {


  _deleteDialog()
  {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async{
                  try
                  {
                    await FirebaseFirestore.instance.collection('offers')
                        .doc(widget.offerId)
                        .delete();
                    await Fluttertoast.showToast(
                      msg: 'Offer has been deleted',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 18.0,
                    );
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  }
                  catch(error)
                  {
                    GlobalMethod.showErrorDialog(error: 'This task cannot be completed', ctx: ctx);
                  } finally {}
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.red
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xba0e638d),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OfferDetailScreen(
            uploadedBy: widget.uploadedBy,
            offerID: widget.offerId,
          )));
        },
        onLongPress: (){
          _deleteDialog();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1, color: Color(0xffeae9e9),),
            ),
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.offerTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xffeae9e9),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xffeae9e9),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.offerDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xffeae9e9),
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Color(0xffeae9e9),
        ),
      ),
    );
  }
}
