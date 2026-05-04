import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../app_imports.dart';

class ImagePreviewer extends StatefulWidget {
  String urlImage;

  ImagePreviewer({Key? key, required this.urlImage}) : super(key: key);

  @override
  State<ImagePreviewer> createState() => _ImagePreviewerState();
}

class _ImagePreviewerState extends State<ImagePreviewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(onTap: () => Navigator.pop(context), child: SvgPicture.asset("assets/images/cross.svg", height: 30)),
            )
          ],
        ),
        body: Center(
          child: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ZoomOverlay(
                modalBarrierColor: Colors.black12,
                minScale: 0.5,
                maxScale: 3.0,
                twoTouchOnly: true,
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.fastOutSlowIn,
                onScaleStart: () {},
                onScaleStop: () {},
                child: FadeInImage.assetNetwork(
                    placeholder: ApiURL.imgPlaceHolder, imageErrorBuilder: (ctx, obj, st) => Image.file(File(image), fit: BoxFit.fill), image: widget.urlImage, fit: BoxFit.fill)),
          ),
        ));
  }
}
