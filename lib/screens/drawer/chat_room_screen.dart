import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../models/chat_message.dart';
import '../../models/message.dart';
import '../../models/user.dart';

class ChatRoomScreen extends StatefulWidget {
  // route name
  static const routeName = '/chatroom';

  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> with WidgetsBindingObserver {
  /* Params */
  late String currentUser;
  late User itemOwner;

  /* Controllers */
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  void didChangeDependencies() {
    /* Accessing parameters sent using route navigator */
    var args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    currentUser = args["currentUser"] as String;
    itemOwner = args["itemOwner"] as User;

    /* intialize the chat room */
    context.read<ChatBloc>().add(InitChatEvent(currentUser, itemOwner.uid));

    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    /* dispose the chat room */
    context.read<ChatBloc>().add(const DisposeChat());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    /* force updating the chats screen */
    final chatBloc = context.watch<ChatBloc>();

    return Scaffold(
      /* Chat Screen App Bar */
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: Container(
            margin: EdgeInsets.symmetric(vertical: 18.h),
            padding: EdgeInsets.all(6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.sw),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: CircleAvatar(
              backgroundImage: Image.network(itemOwner.photoURL, fit: BoxFit.cover).image,
            ),
          ),
          // Username
          title: Text(
            '${itemOwner.fName} ${itemOwner.lName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            itemOwner.about,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => _controller.animateTo(
                    _controller.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  ),
              icon: const Icon(Icons.keyboard_double_arrow_up))
        ],
      ),

      /* Chat Body */
      body: Stack(
        children: [
          /* Chat Messages */
          ListView.builder(
            reverse: true,
            controller: _controller,
            padding: EdgeInsets.only(
              left: 24.h,
              right: 24.h,
              top: 42.h,
              bottom: 200.h,
            ),
            itemBuilder: (context, index) =>
                ChatMessage(message: chatBloc.state.messages[index]),
            itemCount: chatBloc.state.messages.length,
          ),

          /* Message Field */
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 24.w,
              ),
              width: 100.sw,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: const Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.grey,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 0.8.sw,
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.edit),
                        hintText: "Message",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton.filled(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          context.read<ChatBloc>().add(
                                SendMessageEvent(
                                  Message(
                                      sender: context.read<UserBloc>().state.user!.uid,
                                      receiver: context.read<UserBloc>().state.user!.uid ==
                                              currentUser
                                          ? itemOwner.uid
                                          : currentUser,
                                      time: DateTime.now(),
                                      content: _messageController.text),
                                ),
                              );
                        }

                        // after sending the event clear the text
                        _messageController.clear();
                      },
                      icon: const Icon(Icons.send_rounded)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
