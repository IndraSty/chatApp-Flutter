import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../screens/select_img_option.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController namaC;
  late TextEditingController statusC;
  late ImagePicker _picker;
  var isEdit = false.obs;

  File? image_;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadImg() async{
    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = storage.ref("$currentTime.png");
    File file = File(image_!.path);
    

    try{
      await storageRef.putFile(file);
      final photoUrl = await storageRef.getDownloadURL();
      resetImg();
      return photoUrl;
    }catch (e){
      print(e);
      return null;
    }
  }

  void pickImage(ImageSource source) async {
    try {
      // final dataImage = await _picker.pickImage(source: ImageSource.gallery);
      final image = await _picker.pickImage(source: source);
      if (image != null) {
        File? img = File(image.path);
        img = await _cropImage(imageFile: img);
        
        image_ = img;
      }
      isEdit.value = true;
      update();
    } catch (error) {
      print(error);
      image_ = null;
      update();
    }
  }

    Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

//   Future _pickImage(ImageSource source) async {
//   try {
//     final image = await ImagePicker().pickImage(source: source);
//     if (image == null) return;
//     File? img = File(image.path);
//     img = await _cropImage(imageFile: img);
//     _image = img;
//     Get.back();
//   } on PlatformException catch (e) {
//     print(e);
//     Get.back();
//   }
// }

  void resetImg() {
    image_ = null;
    update();
  }



  

  void showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectImgOption(
                onTap: pickImage,
              ),
            );
          }),
    );
  }

  @override
  void onInit() {
    emailC = TextEditingController();
    namaC = TextEditingController();
    _picker = ImagePicker();
    statusC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    namaC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
