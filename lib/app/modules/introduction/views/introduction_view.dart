import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../routes/app_pages.dart';
import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  IntroductionView({Key? key}) : super(key: key);

  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: "Title of introduction page1",
      body: "Welcome to the app! This is a description of how it works.",
      image: const Center(
        child: Icon(Icons.waving_hand, size: 50.0),
      ),
    ),
    PageViewModel(
      title: "Title of introduction page2",
      body: "Welcome to the app! This is a description of how it works.",
      image: const Center(
        child: Icon(Icons.waving_hand, size: 50.0),
      ),
    ),
    PageViewModel(
      title: "Title of introduction page3",
      body: "Welcome to the app! This is a description of how it works.",
      image: const Center(
        child: Icon(Icons.waving_hand, size: 50.0),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        pages: listPagesViewModel,
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text("Next"),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () {
          Get.offAllNamed(Routes.LOGIN);
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
