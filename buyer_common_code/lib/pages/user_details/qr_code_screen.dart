import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../components/utils/Constants.dart';
import '../../components/utils/widget_utils.dart';

class QRCodeScreen extends StatefulWidget {
  final String qrImagePath;
  final String userName;
  final String profileImageUrl;

  const QRCodeScreen({Key? key, required this.qrImagePath, required this.userName, required this.profileImageUrl}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff27914F),
          title: WidgetUtils.appTextWidget(context: context, title: 'My QR Code', fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white)
          ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.profileImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(scale: 30, image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset("assets/images/user.png", fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              WidgetUtils.appTextWidget(context: context, title: widget.userName, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 26),
              const SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height * 0.352,
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 34),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff27914F)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Image.network(widget.qrImagePath, height: MediaQuery.of(context).size.height * 0.266, width: MediaQuery.of(context).size.width * 0.627),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Container(
                width: MediaQuery.of(context).size.width * 0.66,
                height: MediaQuery.of(context).size.height * 0.074,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff27914F)),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    WidgetUtils.appTextWidget(context: context, title: 'Share my code', fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 18, color: const Color(0xff27914F)),
                    const Icon(Icons.share, color: Color(0xff27914F), size: 30)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
