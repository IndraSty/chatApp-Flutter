import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_image_controller.dart';

class EditImageView extends GetView<EditImageController> {
  const EditImageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditImageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditImageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
