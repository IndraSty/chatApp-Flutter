// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) => UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
    UsersModel({
        this.uid,
        this.email,
        this.keyName,
        this.name,
        this.img,
        this.phone,
        this.status,
        this.createAt,
        this.lastSignInTime,
        this.updateAt,
        this.chats,
    });

    String? uid;
    String? email;
    String? keyName;
    String? name;
    String? img;
    String? phone;
    String? status;
    String? createAt;
    String? lastSignInTime;
    String? updateAt;
    List<ChatUser>? chats;

    factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        uid: json["uid"],
        email: json["email"],
        keyName: json["keyName"],
        name: json["name"],
        img: json["img"],
        phone: json["phone"],
        status: json["status"],
        createAt: json["create_at"],
        lastSignInTime: json["lastSignInTime"],
        updateAt: json["update_at"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "keyName": keyName,
        "name": name,
        "img": img,
        "phone": phone,
        "status": status,
        "create_at": createAt,
        "lastSignInTime": lastSignInTime,
        "update_at": updateAt,
    };
}

class ChatUser {
    ChatUser({
        this.connection,
        this.chatId,
        this.lastTime,
        this.total_unread,
    });

    String? connection;
    String? chatId;
    String? lastTime;
    int? total_unread;

    factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        connection: json["connection"],
        chatId: json["chat_id"],
        lastTime: json["lastTime"],
        total_unread: json["total_unread"],
    );

    Map<String, dynamic> toJson() => {
        "connection": connection,
        "chat_id": chatId,
        "lastTime": lastTime,
        "total_unread": total_unread,
    };
}
