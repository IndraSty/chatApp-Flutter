import 'dart:async';

import 'package:chatapps/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constant.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  ChatRoomView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();
  final themeC = Get.find<ThemeController>();
  final String chatId = (Get.arguments as Map<String, dynamic>)["chat_id"];
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          backgroundColor: themeC.isDarkMode.isTrue ? Constant.appbarColor : Constant.primaryColor,
          leading: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.HOME),
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: controller.streamFriendData(
                        (Get.arguments as Map<String, dynamic>)["friendEmail"]),
                    builder: (context, snapFriendUser) {
                      if (snapFriendUser.connectionState ==
                          ConnectionState.active) {
                        var dataFriend =
                            snapFriendUser.data!.data() as Map<String, dynamic>;
                        if (dataFriend["img"] == "NoImage") {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/icon/man.png",
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              dataFriend["img"],
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                          );
                        }
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/icon/man.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          title: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: controller.streamFriendData(
                (Get.arguments as Map<String, dynamic>)["friendEmail"]),
            builder: (context, snapFriendUser) {
              if (snapFriendUser.connectionState == ConnectionState.active) {
                var dataFriend =
                    snapFriendUser.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataFriend["name"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      dataFriend["status"],
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Unknown...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Unknown...",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            if (controller.isShowEmoji.isTrue) {
              controller.isShowEmoji.value = false;
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.streamChat(chatId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var chat = snapshot.data!.docs;
                      Timer(
                        Duration.zero,
                        () => controller.scrollC
                            .jumpTo(controller.scrollC.position.maxScrollExtent),
                      );
                      return ListView.builder(
                          controller: controller.scrollC,
                          itemCount: chat.length,
                          itemBuilder: (contex, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff2E4F4F),
                                    ),
                                    child: Text(
                                      "${chat[index]["groupTime"]}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  ItemChat(
                                    isSender: chat[index]["sender"] ==
                                            authC.user.value.email!
                                        ? true
                                        : false,
                                    msg: "${chat[index]["msg"]}",
                                    time: chat[index]["time"],
                                  ),
                                ],
                              );
                            } else {
                              if (chat[index]["groupTime"] ==
                                  chat[index - 1]["groupTime"]) {
                                return ItemChat(
                                  isSender: chat[index]["sender"] ==
                                          authC.user.value.email!
                                      ? true
                                      : false,
                                  msg: "${chat[index]["msg"]}",
                                  time: chat[index]["time"],
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      "${chat[index]["groupTime"]}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    ItemChat(
                                      isSender: chat[index]["sender"] ==
                                              authC.user.value.email!
                                          ? true
                                          : false,
                                      msg: "${chat[index]["msg"]}",
                                      time: chat[index]["time"],
                                    ),
                                  ],
                                );
                              }
                            }
                          });
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Container(
                width: Get.width,
                margin: EdgeInsets.only(
                    bottom: controller.isShowEmoji.isTrue
                        ? 5
                        : context.mediaQueryPadding.bottom),
                // ignore: prefer_const_constructors
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        autocorrect: false,
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        onEditingComplete: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none),
                          fillColor: Color(0xff2E4F4F),
                          filled: true,
                          prefixIcon: IconButton(
                            onPressed: () {
                              controller.focusNode.unfocus();
                              controller.isShowEmoji.toggle();
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      color: Constant.primaryColor,
                      child: InkWell(
                        onTap: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: 325,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojitoChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                        }, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Constant.primaryColor,
                          iconColor: Colors.grey,
                          iconColorSelected: Constant.primaryColor,
                          backspaceColor: Constant.primaryColor,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecents: const Text(
                            'No Recents',
                            style: TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ), // Needs to be const Widget
                          loadingIndicator:
                              const SizedBox.shrink(), // Needs to be const Widget
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
        ),
        // backgroundColor: Colors.black12,
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    super.key,
    required this.isSender,
    required this.msg,
    required this.time,
  });

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: isSender ? 0 : 10, horizontal: 10),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: isSender ? 120 : 0,
              right: isSender ? 0 : 120,
            ),
            decoration: BoxDecoration(
              color: isSender ? Constant.primaryColor : Color(0xff2E4F4F),
              borderRadius: isSender
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 50, top: 10, bottom: 10),
                  child: Text(
                    msg,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Text(
                    DateFormat.Hm().format(DateTime.parse(time)),
                    style: TextStyle(
                        color: isSender ? Colors.grey[700] : Colors.grey[500],
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
