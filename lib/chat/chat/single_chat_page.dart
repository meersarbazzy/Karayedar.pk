import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:karayedar_pk/chat/chat/widgets/text_message_url_widget.dart';
import 'package:karayedar_pk/chat/communication/communication_cubit.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasouce.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasource_impl.dart';
import 'package:karayedar_pk/chat/entities/text_messsage_entity.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';

enum PlayerState { stopped, playing, paused }

class SingleChatPage extends StatefulWidget {
  final String uid;
  final String channalId;
  final String otherUId;
  final UserEntity otherUser;

  const SingleChatPage(
      {Key? key,
      required this.uid,
      required this.channalId,
        required this.otherUser,
      required this.otherUId})
      : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  String messageContent = "";
  String swipeMessage = "";
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  final db = FirebaseRemoteRepositoryImpl();

  @override
  void initState() {

    BlocProvider.of<CommunicationCubit>(context)
        .getMessages(channelId: widget.channalId);

    _messageController.addListener(() {
      setState(() {});
    });

    if (_scrollController.hasClients) {
      Timer(
          Duration(milliseconds: 100),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.decelerate,
              duration: Duration(milliseconds: 500)));
    }

    ///[getMessages] fetch all the communications according to [channelId]

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.otherUser.username}"),
        backgroundColor: Colors.green[800], // Set the AppBar color to green[800]

      ),
      body: BlocBuilder<CommunicationCubit, CommunicationState>(
        builder: (context, communicationState) {
          if (communicationState is CommunicationLoaded) {
            return _bodyWidget(communicationState);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _bodyWidget(CommunicationLoaded communicationLoadedState) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: Container(
              height: 90,
              alignment: Alignment.topRight,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: communicationLoadedState.messages.length,
                itemBuilder: (ctx, index) {
                  final message = communicationLoadedState.messages[index];
                  return message.senderId == widget.uid
                      ? messageLayout(
                          color: Colors.lightGreen[400],
                          textMessageEntity: message,
                          text: message.content,
                          time: DateFormat("hh:mm a")
                              .format(message.time!.toDate()),
                          align: TextAlign.left,
                          messageId: message.messageId,
                          userId: message.senderId!,
                          nip: BubbleNip.rightTop,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignmentRow: MainAxisAlignment.end,
                          boxAlign: CrossAxisAlignment.end)
                      : messageLayout(
                          color: Colors.purple.shade200,
                          text: message.content,
                          textMessageEntity: message,
                          messageId: message.messageId,
                          userId: "",
                          time: DateFormat("hh:mm a")
                              .format(message.time!.toDate()),
                          align: TextAlign.left,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignmentRow: MainAxisAlignment.start,
                          boxAlign: CrossAxisAlignment.start);
                },
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 18, left: 18, right: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          offset: Offset(0.0, 0.50),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 60),
                                child: Scrollbar(
                                  child: TextField(
                                    style: TextStyle(fontSize: 14),
                                    controller: _messageController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type a message"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: _messageController.text.isEmpty
                    ? null
                    : () async {
                        BlocProvider.of<CommunicationCubit>(context)
                            .sendTextMessage(
                                textMessageEntity: TextMessageEntity(
                                  receiverName: "",
                                  senderId: widget.uid,
                                  senderName: "",
                                  time: Timestamp.now(),
                                  content: _messageController.text,
                                  recipientId: widget.otherUId,
                                  type: "TEXT",
                                ),
                                channelId: widget.channalId,
                                engageUserEntity: EngageUserEntity(
                                  otherUid: widget.otherUId,
                                  uid: widget.uid,
                                )).then((value) {
                                  _messageController.clear();
                                  setState(() {

                                  });
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(40)),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget messageLayout({
    text,
    time,
    color,
    align,
    boxAlign,
    messageId,
    nip,
    crossAxisAlignment,
    mainAxisAlignmentRow,
    required String userId,
    required TextMessageEntity textMessageEntity,
  }) {
    return Column(crossAxisAlignment: boxAlign, children: <Widget>[
      ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90),
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(3),
          child: Bubble(
            color: color,
            nip: nip,
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _diffMessage(
                    text: text,
                    textMessageEntity: textMessageEntity,
                    messageId: messageId),
                Wrap(
                  children: [
                    Text(
                      time,
                      textAlign: align,
                      style: TextStyle(
                          fontSize: 12, color: Colors.black.withOpacity(.4)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.done_all_outlined,
                      size: 14,
                      color: Colors.green,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _diffMessage(
      {required TextMessageEntity textMessageEntity,
      String? messageId,
      required String text}) {
    return TextMessageUrlWidget(
      textMessage: text,
    );
  }
}
