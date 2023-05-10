import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/models/users_model.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? _userCredential;

  var user = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    //skip intro
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignin = await _googleSignIn.isSignedIn();
      if (isSignin) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => _userCredential = value);

        print("USER CREDENTIAL");
        print(_userCredential);

        CollectionReference users = firestore.collection('users');
        await users.doc(_currentUser!.email).update({
          'lastSignInTime':
              _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChat = [];
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChat.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          }
          user.update((val) {
            val!.chats = dataListChat;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

        user.refresh();

        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        print("SUDAH BERHASIL LOGIN DENGAN AKUN : ");
        print(_currentUser);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => _userCredential = value);

        // simpan stattus login user
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // simpan data user di firestore
        CollectionReference users = firestore.collection('users');
        final cekUser = await users.doc(_currentUser!.email).get();

        if (cekUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            'uid': _userCredential!.user!.uid,
            'name': _currentUser!.displayName,
            'email': _currentUser!.email,
            'keyName': _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            'img': _currentUser!.photoUrl ?? "NoImage",
            'status': "",
            'phone': _userCredential!.user!.phoneNumber,
            'create_at':
                _userCredential!.user!.metadata.creationTime!.toIso8601String(),
            'lastSignInTime': _userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            'update_at': DateTime.now().toIso8601String(),
          });

          await users.doc(_currentUser!.email).collection("chats");
        } else {
          await users.doc(_currentUser!.email).update({
            'lastSignInTime': _userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChat = [];
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChat.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          }
          user.update((val) {
            val!.chats = dataListChat;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

        user.refresh();

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        print("TIDAK BERHASIL LOGIN");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    Get.offAllNamed(Routes.LOGIN);
  }

  void uploadImgUrl(String url) async {
    String date = DateTime.now().toIso8601String();
    //Update Firebase
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      'img': url,
      'update': date,
    });

    //Update Model
    user.update(
      (val) {
        val!.img = url;
        val.updateAt = date;
      },
    );
    user.refresh();
  }

  void changeProfile(String nama, String status) {
    String date = DateTime.now().toIso8601String();

    //Update Firebase
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      'name': nama,
      'keyName': nama.substring(0, 1).toUpperCase(),
      'status': status,
      'lastSignInTime':
          _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'update': date,
    });

    //Update Model
    user.update(
      (val) {
        val!.name = nama;
        val.keyName = nama.substring(0, 1).toUpperCase();
        val.status = status;
        val.lastSignInTime =
            _userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        val.updateAt = date;
      },
    );
    user.refresh();
  }

  void onUpdateStatus(String status) {
    String date = DateTime.now().toIso8601String();
    //Update Firebase
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      'status': status,
      'lastSignInTime':
          _userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'update': date,
    });

    //Update Model
    user.update(
      (val) {
        val!.status = status;
        val.lastSignInTime =
            _userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        val.updateAt = date;
      },
    );
    user.refresh();

    Get.defaultDialog(
      title: "Success",
      middleText: "CUpdate Status Success",
    );
  }

  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    String date = DateTime.now().toIso8601String();
    var chat_id;
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docChats =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (docChats.docs.isNotEmpty) {
      //user sudah pernah chatting dengan siapapun
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        //sudah pernah buat koneksi => friendEmail
        flagNewConnection = false;
        chat_id = checkConnection.docs[0].id;
      } else {
        //belum pernah buat koneksi => friendEmail
        //buat koneksi
        flagNewConnection = true;
      }
    } else {
      //belum pernah chatting
      //buat koneksi ...
      flagNewConnection = true;
    }

    //FIXING
    if (flagNewConnection) {
      //cek dari chats collection => connection => mereka berdua...
      final chatsCon = await chats.where(
        "connections",
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatsCon.docs.isNotEmpty) {
        //terdapat data chats
        final chatDataId = chatsCon.docs[0].id;
        final chatsData = chatsCon.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChat = List<ChatUser>.empty();
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChat.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          }
          user.update((val) {
            val!.chats = dataListChat;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

        chat_id = chatDataId;
        user.refresh();
      } else {
        //buat baru
        final newChatDoc = await chats.add({
          "connections": [
            _currentUser!.email,
            friendEmail,
          ],
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChat = List<ChatUser>.empty();
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChat.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"]));
          }
          user.update((val) {
            val!.chats = dataListChat;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

        chat_id = newChatDoc.id;
        user.refresh();
      }
    }

    print(chat_id);

    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("receiver", isEqualTo: _currentUser!.email)
        .get();

    updateStatusChat.docs.forEach((element) async {
      element.id;
      await chats
          .doc(chat_id)
          .collection("chat")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(_currentUser!.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        "chat_id": chat_id,
        "friendEmail": friendEmail,
      },
    );
  }
}
