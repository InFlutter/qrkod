import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/qr_cubit.dart';
import '../widgets/text_widget.dart';
import 'generate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<CutoutsizeCubit, double>(
            builder: (context, state) {
              return GestureDetector(
                onPanUpdate: (details) {
                  context.read<CutoutsizeCubit>().onPanUpdate(
                        details: details,
                        context: context,
                      );
                },
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.yellow,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: state,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildContainer(
                isShadow: true,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildtopButton(Icons.image, () {}),
                    _buildtopButton(Icons.flash_on, () {
                      controller?.toggleFlash();
                    }),
                    _buildtopButton(Icons.cameraswitch_rounded, () {
                      controller?.flipCamera();
                    }),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildContainer(
              isShadow: false,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(
                    Icons.qr_code,
                    "Generate",
                    () {
                      controller?.stopCamera();
                      Navigator.of(context)
                          .push(
                        CupertinoPageRoute(
                          builder: (context) => GenerateScreen(),
                        ),
                      )
                          .then(
                        (value) {
                          controller?.resumeCamera();
                        },
                      );
                    },
                  ),
                  _buildButton(
                    Icons.history,
                    "History",
                    () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            left: MediaQuery.of(context).size.width / 2.5,
            child: Container(
              padding: const EdgeInsets.all(15),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffFDB623),
                    blurRadius: 20,
                    blurStyle: BlurStyle.solid,
                  ),
                ],
                color: const Color(0xffFDB623),
                borderRadius: BorderRadius.circular(100),
              ),
              child: SvgPicture.asset(
                "assets/scaner.svg",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        controller.stopCamera();
        final urlCode = result!.code.toString();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Result"),
              content: Text(urlCode),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    const Gap(10),
                    FilledButton(
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(text: urlCode))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text("Url copied to Clipboard")));
                        });
                      },
                      child: const Text("Copy"),
                    ),
                    const Gap(10),
                    FilledButton(
                      onPressed: () async {
                        Uri url = Uri.parse(urlCode);

                        if (await launchUrl(url)) {
                          print("Wrong url");
                        }
                      },
                      child: const Text("Open"),
                    )
                  ],
                )
              ],
            );
          },
        ).then(
          (value) {
            controller.resumeCamera();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildButton(IconData icon, String text, Function() function) {
    return GestureDetector(
      onTap: function,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
          ),
          CustomText(
            text: text,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }

  Widget _buildtopButton(IconData icon, Function() function) {
    return InkWell(
      onTap: function,
      child: Icon(
        icon,
        size: 30,
      ),
    );
  }

  Widget _buildContainer(Widget widget, {required bool isShadow}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: BoxDecoration(
        boxShadow: isShadow
            ? [
                const BoxShadow(
                  color: Color(0xff333333),
                  blurRadius: 15,
                  spreadRadius: 5,
                )
              ]
            : null,
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff333333),
      ),
      child: widget,
    );
  }
}
