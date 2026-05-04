import '../../app_imports.dart';

enum MessageType { sent, received }

class FlatChatMessage extends StatelessWidget {
  final String? message;
  final MessageType? messageType;
  final Color? backgroundColor;
  final Color? textColor;
  final String? time;
  final String? imageUser;
  final bool? showTime;
  final double? maxWidth;
  final double? minWidth;

  const FlatChatMessage({super.key, this.message, this.messageType, this.backgroundColor, this.textColor, this.time, this.imageUser, this.showTime, this.minWidth, this.maxWidth});

  CrossAxisAlignment messageAlignment() {
    if (messageType == null || messageType == MessageType.received) {
      return CrossAxisAlignment.start;
    } else {
      return CrossAxisAlignment.end;
    }
  }

  MainAxisAlignment messageMainAlignment() {
    if (messageType == null || messageType == MessageType.received) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.end;
    }
  }

  double topLeftRadius() {
    if (messageType == null || messageType == MessageType.received) {
      return 0.0;
    } else {
      return 12.0;
    }
  }

  double topRightRadius() {
    if (messageType == null || messageType == MessageType.received) {
      return 12.0;
    } else {
      return 0.0;
    }
  }

  Color messageBgColor(BuildContext context) {
    if (messageType == null || messageType == MessageType.received) {
      return Colors.grey.shade300;
    } else {
      return Color(int.parse(themeColor.value.buttonColor!.color!));
    }
  }

  Color messageTextColor() {
    if (messageType == null || messageType == MessageType.received) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  Text messageTime() {
    if (showTime != null && showTime == true) {
      return Text(
        time ?? "Time",
        style: TextStyle(fontSize: 10.0, color: messageTextColor()),
      );
    } else {
      return const Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
      child: Column(
        crossAxisAlignment: messageAlignment(),
        children: [
          Row(
            mainAxisAlignment: messageMainAlignment(),
            children: [
              messageType == MessageType.received
                  ? SizedBox(
                  width: 36,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: HeaderSingleton().configurationDetails!.partnerImgUrl! + (imageUser ?? ""),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                      ),
                      placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.asset('assets/images/user.png'),
                    ),
                  ))
                  : Container(),
              const SizedBox(width: 5),
              Container(
                constraints: BoxConstraints(minWidth: minWidth ?? 100.0, maxWidth: maxWidth ?? 250.0),
                decoration: BoxDecoration(
                  color: backgroundColor ?? messageBgColor(context),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topLeftRadius()), topRight: Radius.circular(topRightRadius()), bottomLeft: const Radius.circular(12.0), bottomRight: const Radius.circular(12.0)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: messageType == null || messageType == MessageType.received ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text(
                      message ?? "Message here...",
                      style: TextStyle(fontSize: 14, color: textColor ?? messageTextColor(), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    messageTime(),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              messageType == MessageType.sent
                  ? SizedBox(
                  width: 36,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: HeaderSingleton().configurationDetails!.partnerImgUrl! + HeaderSingleton().imageValue.value,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                      ),
                      placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.asset('assets/images/user.png'),
                    ),
                  ))
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}
