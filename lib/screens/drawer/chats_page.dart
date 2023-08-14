import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/chat/chat_bloc.dart';
import 'package:oumel/widgets/custom_app_bar_title.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/userbase/userbase_cubit.dart';
import '../../blocs/userchat/userchat_cubit.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import 'chat_room_screen.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  Message? latestMessage;

  /* Userbase (to search other) */
  late UserbaseCubit userbaseCubit;

  /* User Chats */
  late UserchatCubit userchatCubit;
  late List<String> refs;

  /* my uid */
  late String myUID;

  /* users i have chat with */
  final List<User> others = List.empty(growable: true);

  /* their last messages */
  final List<Message> lastMessages = List.empty(growable: true);

  // get the other user uid
  User getOther(String ref) {
    List<String> splitted = ref.split('+');

    return userbaseCubit.getUser(splitted[splitted[0] == myUID ? 1 : 0]);
  }

  // get last message
  Future<Message> getLastMessage(String other) async {
    return await context.read<ChatBloc>().getLatestMessage(myUID, other);
  }

  @override
  void didChangeDependencies() {
    userbaseCubit = context.read<UserbaseCubit>();
    userchatCubit = context.watch<UserchatCubit>();
    refs = userchatCubit.state.chatRefs;
    myUID = context.read<UserBloc>().state.user!.uid;

    for (var ref in refs) {
      others.add(getOther(ref));
    }

    () async {
      for (var user in others) {
        lastMessages.add(await getLastMessage(user.uid));
      }

      setState(() {});
    }();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: "Messages"),
      ),
      body: refs.isEmpty
          ? const Center(
              child: Text("Your chats will appear here"),
            )
          : lastMessages.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 4.spMax),
                  itemBuilder: (context, index) {
                    User otherUser = others[index];
                    Message lastMessage = lastMessages[index];

                    return ListTile(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(ChatRoomScreen.routeName, arguments: {
                        "currentUser": myUID,
                        "itemOwner": otherUser,
                      }),
                      leading: Container(
                        margin: EdgeInsets.symmetric(vertical: 6.0.spMax),
                        padding: EdgeInsets.all(2.0.spMax),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.sw),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: CircleAvatar(
                          backgroundImage:
                              Image.network(otherUser.photoURL, fit: BoxFit.cover).image,
                        ),
                      ),
                      title: Text(
                        "${otherUser.fName} ${otherUser.lName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "${lastMessage.sender == myUID ? "You" : "${otherUser.fName} ${otherUser.lName}"}: ${lastMessage.content}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        lastMessage.formattedTimeString(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.spMax,
                        ),
                      ),
                    );
                  },
                  itemCount: refs.length,
                ),
    );
  }
}
