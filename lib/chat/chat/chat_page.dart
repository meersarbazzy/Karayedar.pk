import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:karayedar_pk/chat/chat/single_chat_page.dart';
import 'package:karayedar_pk/chat/chat/widgets/single_item_chat_widget.dart';
import 'package:karayedar_pk/chat/communication/communication_cubit.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasouce.dart';

import 'package:karayedar_pk/chat/my_chat/my_chat_cubit.dart';
import 'package:karayedar_pk/chat/single_user/single_user_cubit.dart';
import 'package:karayedar_pk/user/data/remote_data_source/firebase_remote_data_source_impl.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';
import 'package:karayedar_pk/user/presentation/cubit/user/get_users_cubit.dart';



typedef OnLongPressChat = Function(bool isLongPressed);

class ChatPage extends StatefulWidget {
  final String uid;

  const ChatPage(
      {Key? key,
      required this.uid})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isOpenActionMenu = false;
  String _selectedChat = "";

  final db = UserFirebaseRemoteDataSourceImpl();

  @override
  void initState() {
    BlocProvider.of<MyChatCubit>(context).getMyChat(uid: widget.uid);
    BlocProvider.of<SingleUserCubit>(context).getSingleUser(uid: widget.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800], // Set the AppBar color to green[800]

        title: Text("Chat"),
      ),
      body: BlocBuilder<MyChatCubit, MyChatState>(builder: (
        context,
        myChatState,
      ) {
        if (myChatState is MyChatLoaded) {
          return BlocBuilder<SingleUserCubit, SingleUserState>(
              builder: (context, singleUserState) {
            if (singleUserState is SingleUserLoaded) {
              return Column(
                children: [
                  Expanded(
                      child: _myChatListWidget(myChatState,singleUserState.uid)),
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          });
        }

        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget _myChatMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.5),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Icon(
              Icons.message,
              color: Colors.white.withOpacity(.6),
              size: 40,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding:  EdgeInsets.all(15),
              child: Text(
                "No direct messages yet!",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _myChatListWidget(MyChatLoaded myChatData, String  uid) {


    final filterChat = myChatData.myChat;

    final myChat =
        filterChat.where((chat) => chat.isArchived == false).toList();

    return Container(
      child: myChat.isEmpty
          ? _myChatMessage()
          : ListView.builder(
              itemCount: myChat.length,
              itemBuilder: (_, index) {
                final myChatUser = myChat[index];


                return StreamBuilder<List<UserEntity>>(
                    stream: db.getSingleUser(myChatUser.recipientUID!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData ==false)
                        return Center(
                          child: CircularProgressIndicator(),
                        );


                      if (snapshot.data!.isEmpty){
                        return SizedBox();
                      }

                      final recipientProfile=snapshot.data!.first;

                    return InkWell(
                      onTap: () async {

                        BlocProvider.of<CommunicationCubit>(context)
                            .createChatChannel(
                                engageUserEntity: EngageUserEntity(
                          uid: widget.uid,
                          otherUid:  myChatUser.recipientUID,
                        ))
                            .then((value) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SingleChatPage(uid: uid, channalId: myChatUser.channelId!, otherUId: recipientProfile.uid!,otherUser: recipientProfile,)));
                        });
                      },
                      child: SingleItemChatWidget(
                        user: recipientProfile,
                        chatChannelId: myChatUser.channelId == null
                            ? ""
                            : myChatUser.channelId!,
                        onSelectedChatClear: () {

                        },
                        name: myChatUser.recipientName!,
                        selectedChat: _selectedChat,
                        time:
                            DateFormat('hh:mm a').format(myChatUser.time!.toDate()),
                        recentMessage: myChatUser.recentTextMessage!,
                        messageType: "Chat",
                      ),
                    );
                  }
                );
              },
            ),
    );
  }
}
