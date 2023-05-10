import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          CardDialog(),
          Positioned(
            height: 40,
            width: 40,
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                "assets/icon/cancel.png",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardDialog extends StatelessWidget {
  final themeC = Get.find<ThemeController>();
  final authC = Get.find<AuthController>();
  CardDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16,
      ),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: themeC.isDarkMode.isTrue
              ? const Color(0xff343434)
              : const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/icon/alert.png",
            width: 72,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            "Alert",
            style: GoogleFonts.montserrat(
                fontSize: 24,
                color: const Color(0xffFF6750),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Apakah anda Yakin ingin Logout?",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              color: themeC.isDarkMode.isTrue
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(
            height: 52,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                  foregroundColor: Constant.primaryColor,
                  side: const BorderSide(
                    color: Constant.primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF6750),
                ),
                onPressed: () => authC.logout(),
                child: const Text("Logout"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
