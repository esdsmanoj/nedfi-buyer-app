import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart' as web;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../model/home_page_model.dart';

class MediaDetailsScreen extends StatefulWidget {
  final Media mediaData;
  final String baseUrl;

  const MediaDetailsScreen(this.mediaData, this.baseUrl, {Key? key}) : super(key: key);

  @override
  _MediaDetailsScreenState createState() => _MediaDetailsScreenState();
}

class _MediaDetailsScreenState extends State<MediaDetailsScreen> {
  late VideoPlayerController _controller;
  YoutubePlayerController? youtubeController;
  bool isFullscreenEnabled = false;
  var loadingPercentage = 0;
  dynamic videoId;

  final controller = Completer<web.WebViewController>();
  var unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    if (widget.mediaData.urlType == "youtube") {
      videoId = YoutubePlayer.convertUrlToId(widget.mediaData.url!);
      youtubeController = YoutubePlayerController(initialVideoId: videoId!, flags: const YoutubePlayerFlags(autoPlay: false));
    }
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.mediaData.url!))..initialize().then((value) => setState(() {}));
    // _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getTimePassed(DateTime datetime, {bool full = true}) {
    DateTime now = DateTime.now();
    DateTime ago = datetime;
    Duration dur = now.difference(ago);
    int days = dur.inDays;
    int years = days ~/ 365;
    int months = (days - (years * 365)) ~/ 30;
    int weeks = (days - (years * 365 + months * 30)) ~/ 7;
    int rdays = days - (years * 365 + months * 30 + weeks * 7).toInt();
    int hours = (dur.inHours % 24).toInt();
    int minutes = (dur.inMinutes % 60).toInt();
    int seconds = (dur.inSeconds % 60).toInt();
    var diff = {"d": rdays, "w": weeks, "m": months, "y": years, "s": seconds, "i": minutes, "h": hours};

    Map str = {'y': 'year', 'm': 'month', 'w': 'week', 'd': 'day', 'h': 'hour', 'i': 'minute', 's': 'second'};

    str.forEach((k, v) {
      if (diff[k]! > 0) {
        str[k] = diff[k].toString() + ' ' + v.toString() + (diff[k]! > 1 ? 's' : '');
      } else {
        str[k] = "";
      }
    });
    str.removeWhere((index, ele) => ele == "");
    List<String> tlist = [];
    str.forEach((k, v) {
      tlist.add(v);
    });
    if (full) {
      return str.isNotEmpty ? tlist.join(", ") + " ago" : "Just Now";
    } else {
      return str.isNotEmpty ? tlist[0] + " ago" : "Just Now";
    }
  }

  @override
  Widget build(BuildContext context) {
    late String duration, elapse;
    Orientation orientation = MediaQuery.of(context).orientation;
    if (widget.mediaData.publishedOn != null) {
      DateTime dateTime = DateTime.parse(widget.mediaData.publishedOn!);
      final date2 = DateTime.now();
      duration = date2.difference(dateTime).inDays.toString();
      elapse = getTimePassed(dateTime, full: true);
    }
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: !isFullscreenEnabled
              ? AppBar(
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                  title: WidgetUtils.appTextWidget(context: context, title: 'Media'.tr, color: Colors.white, fontSize: 18),
                  leading: InkWell(
                      onTap: () async {
                        await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white)),
                )
              : null,
          body: SafeArea(
            child: !isFullscreenEnabled
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        !isFullscreenEnabled ? const SizedBox(height: 24) : SizedBox(),
                        Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                            margin: EdgeInsets.symmetric(horizontal: !isFullscreenEnabled ? 16 : 0),
                            // height: orientation == Orientation.portrait ? 200 : 250,
                            width: double.maxFinite,
                            child: widget.mediaData.urlType == "youtube"
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                    child: YoutubePlayer(
                                      controller: youtubeController!,
                                      showVideoProgressIndicator: true,
                                      // onReady: () => print("ready"),
                                      bottomActions: [
                                        CurrentPosition(),
                                        ProgressBar(
                                          isExpanded: true,
                                          colors: ProgressBarColors(playedColor: Color(int.parse(themeColor.value.barColor!.color!)), handleColor: Colors.blue),
                                        ),
                                        RemainingDuration(),
                                        IconButton(
                                          icon: const Icon(Icons.fullscreen, color: Colors.white),
                                          onPressed: () {
                                            youtubeController = YoutubePlayerController(initialVideoId: videoId!, flags: const YoutubePlayerFlags(autoPlay: true));
                                            isFullscreenEnabled = !isFullscreenEnabled;
                                            youtubeController!.toggleFullScreenMode();
                                            setState(() {});
                                          },
                                        )

                                        // FullScreenButton()
                                      ],
                                    ),
                                  )
                                : _controller.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio: (orientation == Orientation.portrait) ? _controller.value.aspectRatio : 2.8,
                                        child: Stack(
                                          // alignment: AlignmentDirectional.center,
                                          children: [
                                            VideoPlayer(_controller),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              left: 0,
                                              child: Container(
                                                height: 40,
                                                color: Colors.black38,
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                                          });
                                                        },
                                                        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 30, color: Colors.white)),
                                                    SizedBox(
                                                        width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.550 : MediaQuery.of(context).size.width * 0.7,
                                                        child: VideoProgressIndicator(_controller,
                                                            allowScrubbing: true,
                                                            colors: VideoProgressColors(playedColor: Color(int.parse(themeColor.value.barColor!.color!)), backgroundColor: Colors.white))),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          if (orientation == Orientation.portrait) {
                                                            await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
                                                          } else {
                                                            await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                                                          }
                                                        },
                                                        child: const Icon(Icons.fullscreen, size: 30, color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                    : const Center(child: CircularProgressIndicator())),
                        !isFullscreenEnabled ? const SizedBox(height: 20) : const SizedBox(),
                        !isFullscreenEnabled
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.88,
                                child: WidgetUtils.appTextWidget(
                                    context: context, family: 'Graphik', title: widget.mediaData.title!, fontWeight: FontWeight.w500, fontSize: 20, overflow: TextOverflow.ellipsis, softWrap: true))
                            : Container(),
                        !isFullscreenEnabled ? const SizedBox(height: 16) : const SizedBox(),
                        !isFullscreenEnabled
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.88,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xfff3f3f3)), color: const Color(0xfff3f3f3), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                        padding: const EdgeInsets.all(10),
                                        child: WidgetUtils.appTextWidget(
                                            context: context,
                                            family: 'Graphik',
                                            title: (widget.mediaData.viewCount ?? "0") + " Views",
                                            fontWeight: FontWeight.w200,
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true)),
                                    Container(
                                      decoration:
                                          BoxDecoration(border: Border.all(color: const Color(0xfff3f3f3)), color: const Color(0xfff3f3f3), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      padding: const EdgeInsets.all(10),
                                      child: WidgetUtils.appTextWidget(
                                          context: context,
                                          family: 'Graphik',
                                          title: elapse != null ? elapse.split(',').first + " ago" : 'unknown',
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        !isFullscreenEnabled ? SizedBox(height: MediaQuery.of(context).size.height * 0.01) : const SizedBox(),
                        !isFullscreenEnabled
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.88,
                                child: Html(
                                  /*     onLinkTap: (value, ctx, mapValues, element) {
                                    launchURL(value.toString().substring(2, value.toString().length - 2));
                                  },*/
                                  data: unescape.convert(widget.mediaData.description!),
                                  style: {"body": Style(fontFamily: 'Graphik', wordSpacing: 10, fontSize: FontSize(15), fontWeight: FontWeight.w400, color: Colors.black38)},
                                ))
                            : const SizedBox(),
                      ],
                    ),
                  )
                : buildPlayer(orientation, widget.mediaData.urlType == "youtube" ? youtubeController : _controller),
          ),
        ),
      ),
    );
  }

  buildPlayer(final orientation, final videoController) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.symmetric(horizontal: !isFullscreenEnabled ? 16 : 0),
        // height: orientation == Orientation.portrait ? 200 : 250,
        width: double.maxFinite,
        child: widget.mediaData.urlType == "youtube"
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: YoutubePlayer(
                  controller: videoController!,
                  showVideoProgressIndicator: true,
                  // onReady: () => print("ready"),
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: ProgressBarColors(playedColor: Color(int.parse(themeColor.value.barColor!.color!)), handleColor: Colors.blue),
                    ),
                    RemainingDuration(),
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: () {
                        isFullscreenEnabled = !isFullscreenEnabled;
                        youtubeController!.toggleFullScreenMode();
                        youtubeController!.flags.autoPlay != true;
                        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                        setState(() {});
                      },
                    )
                    // FullScreenButton()
                  ],
                ),
              )
            : _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: (orientation == Orientation.portrait) ? videoController.value.aspectRatio : 2.8,
                    child: Stack(
                      // alignment: AlignmentDirectional.center,
                      children: [
                        VideoPlayer(_controller),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Container(
                            height: 40,
                            color: Colors.black38,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        videoController.value.isPlaying ? _controller.pause() : _controller.play();
                                      });
                                    },
                                    child: Icon(videoController.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 30, color: Colors.white)),
                                SizedBox(
                                    width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.550 : MediaQuery.of(context).size.width * 0.7,
                                    child: VideoProgressIndicator(videoController,
                                        allowScrubbing: true, colors: VideoProgressColors(playedColor: Color(int.parse(themeColor.value.barColor!.color!)), backgroundColor: Colors.white))),
                                GestureDetector(
                                    onTap: () async {
                                      if (orientation == Orientation.portrait) {
                                        await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
                                      } else {
                                        await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                                      }
                                    },
                                    child: const Icon(Icons.fullscreen, size: 30, color: Colors.white)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
                : const Center(child: CircularProgressIndicator()));
  }

  Future launchURL(String urlLaunch) async {
    final url = urlLaunch;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
