import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/text_widget.dart';

class GenerateScreen extends StatelessWidget {
  GenerateScreen({super.key});

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: const Border.symmetric(
              horizontal: BorderSide(
                color: Color(0xffFDB623),
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                "assets/scaner.svg",
                height: 100,
              ),
              const Gap(50),
              CustomText(
                text: "Text",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
              ),
              const Gap(10),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  hintText: "Enter Text",
                ),
              ),
              const Gap(40),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                child: FloatingActionButton(
                  backgroundColor: const Color(0xffFDB623),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          child: QrImageView(
                            data: textController.text,
                            version: QrVersions.auto,
                          ),
                        );
                      },
                    );
                  },
                  child: CustomText(
                    text: "Generate QR Code",
                    color:  Colors.black,
                    fontWeight: FontWeight.bold,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
