import 'package:flutter/material.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';




class SingleItemChatWidget extends StatelessWidget {
  final UserEntity user;
  final String time;
  final String name;
  final String recentMessage;
  final String messageType;
  final String selectedChat;
  final String chatChannelId;
  final VoidCallback onSelectedChatClear;

  const SingleItemChatWidget(
      {Key? key,
        required this.user,
        required this.chatChannelId,
      required this.onSelectedChatClear,
      required this.selectedChat,
      required this.messageType,
      required this.time,
      required this.name,
      required this.recentMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${user.username}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: Text(
                            "$recentMessage",
                            maxLines: null,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "$time",
                        style: TextStyle(
                            fontSize: 12),
                      ),
                      selectedChat == ""
                          ? Container(
                            height: 0,
                            width: 0,
                          )
                          : selectedChat==chatChannelId?InkWell(
                        onTap: onSelectedChatClear,
                            child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.green, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                )),
                          ):Container(
                        height: 0,
                        width: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 10),
            child: Divider(
              thickness: 1.20,
              color: Colors.black.withOpacity(.080),
            ),
          ),
        ],
      ),
    );
  }
}
