import 'package:flutter/material.dart';
import 'package:ad_offer_app/ProfilePage/profile_sender.dart';

class ChatWidget extends StatefulWidget {
  final String chatId;
  final String writerId;
  final String writerName;
  final String writerBody;
  final String writerImageUrl;

  const ChatWidget({
    required this.chatId,
    required this.writerId,
    required this.writerName,
    required this.writerBody,
    required this.writerImageUrl,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final List<Color> _colors = [
    Color(0xed8a69a8),
    Color(0xd758a84d),
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreenSender(userID: widget.writerId)));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: _colors[1],
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.writerImageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.writerName,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffececec),
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.writerBody,
                  maxLines: 5,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Color(0xffececec),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
