
import 'package:ad_offer_app/Receiver/profiles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllClientsWidget extends StatefulWidget {

  final String userID;
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final String userImageUrl;

  const AllClientsWidget({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.phoneNumber,
    required this.userImageUrl,
});


  @override
  State<AllClientsWidget> createState() => _AllClientsWidgetState();
}

class _AllClientsWidgetState extends State<AllClientsWidget> {

  void _mailTo() async
  {
    var mailUrl = 'mailto: ${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');

    if(await canLaunchUrlString(mailUrl))
      {
        await launchUrlString(mailUrl);
      }
    else
      {
        print('Error');
        throw 'Error Occured';
      }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Color(0xba0e638d),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilesScreen(userID: widget.userID)));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1, color: Color(0xffeae9e9),),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
                widget.userImageUrl == null
                    ?
                    'https://www.pngitem.com/pimgs/m/579-5798505_user-placeholder-svg-hd-png-download.png'
                    :
                    widget.userImageUrl
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffeae9e9),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'Visit Profile',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xffeae9e9),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.mail_outline,
          size: 30,
            color: Color(0xffeae9e9),
          ),
          onPressed: (){
            _mailTo();
          },
        ),
      ),
    );
  }
}
