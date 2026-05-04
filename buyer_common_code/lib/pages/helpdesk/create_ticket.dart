import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../app_imports.dart';

class CreateTicketScreen extends StatefulWidget {
  final String helpDeskId;

  const CreateTicketScreen({super.key, required this.helpDeskId});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  TextEditingController titleController = TextEditingController(), descriptionController = TextEditingController();
  List<File>? imagePath;
  List<bool> isSelected = [false, false, false];
  List<String> isSelectedExt = ["", "", ""];
  int selectedIndex = 0;
  String? extension;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "true");
        return true;
      },
      child: SafeArea(
        child: CustomProgressHandler(
          loadingText: '',
          isLoading: isLoading,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                title: WidgetUtils.appTextWidget(context: context, title: 'Create Ticket'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace_sharp),
                  onPressed: () {
                    Navigator.pop(context, "true");
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetUtils.appTextWidget(context: context, title: 'Title'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                      const SizedBox(height: 08),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 58,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintText: 'Enter Title'.tr,
                              border: InputBorder.none,
                              counterText: ""),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(height: 12),
                      WidgetUtils.appTextWidget(context: context, title: 'Add Description'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                      const SizedBox(height: 08),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 106,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(4)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintText: 'Enter Description'.tr,
                              border: InputBorder.none,
                              counterText: ""),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(height: 12),
                      WidgetUtils.appTextWidget(context: context, title: 'Upload Attachment'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                      const SizedBox(height: 08),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          width: double.maxFinite,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: const Color(0xffCFCFCF))),
                          height: 162,
                          child: imagePath == null || (imagePath?.isEmpty ?? false)
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        List<File>? filePath = await HelperUtils().getFromGallery(context, 0, isMultiImagePick: true, isDocumentPick: true);
                                        setState(() {});
                                        imagePath = filePath;
                                        if (filePath != null || (filePath?.isNotEmpty ?? false)) {
                                          extension = p.extension(filePath![0].path);
                                          for (int i = 0; i < filePath.length; i++) {
                                            isSelected[i] = true;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(80), border: Border.all(color: const Color(0xffCFCFCF))),
                                          alignment: Alignment.center,
                                          height: 80,
                                          width: 80,
                                          child: SvgPicture.asset("assets/images/camera.svg", height: 23, color: const Color(0xff6F6F6F))),
                                    ),
                                    const SizedBox(height: 4),
                                    WidgetUtils.appTextWidget(
                                        context: context, title: "Upload Screenshots".tr, color: const Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 16, family: 'Graphik'),
                                    const SizedBox(height: 4),
                                    WidgetUtils.appTextWidget(
                                        context: context, title: "jpg,png,jpeg | limit 5MB".tr, color: const Color(0xffA0A0A0), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                  ],
                                )
                              : extension == ".pdf"
                                  ? Image.asset("assets/images/pdf.png", fit: BoxFit.cover)
                                  : extension == ".mp3"
                                      ? Image.asset("assets/images/mp3.png", fit: BoxFit.cover)
                                      : extension == ".mp4"
                                          ? Image.asset("assets/images/mp4.png", fit: BoxFit.cover)
                                          : extension == ".png" || extension == ".jpeg"
                                              ? const Icon(Icons.image, size: 140)
                                              : Image.file(imagePath![selectedIndex], fit: BoxFit.cover)),
                      const SizedBox(height: 12),
                      imagePath != null && (imagePath?.isNotEmpty ?? false)
                          ? Container(
                              height: 120,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (documentCtx, documentIndex) {
                                    for (int i = 0; i < imagePath!.length; i++) {
                                      final ext = p.extension(imagePath![i].path);
                                      isSelectedExt[i] = ext;
                                    }
                                    return Stack(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if (!isSelected[documentIndex]) {
                                              final filePath = await HelperUtils().getFromGallery(context, 0, isDocumentPick: true);
                                              setState(() {});
                                              imagePath!.insert(documentIndex, File(filePath[0].path));
                                              extension = p.extension(filePath[0].path);
                                              isSelected[documentIndex] = true;
                                            } else {
                                              selectedIndex = documentIndex;
                                              extension = p.extension(imagePath![documentIndex].path);
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 67,
                                            width: 66,
                                            margin: const EdgeInsets.only(right: 8),
                                            child: isSelected[documentIndex]
                                                ? isSelectedExt[documentIndex] == ".pdf"
                                                    ? Image.asset("assets/images/pdf.png", fit: BoxFit.cover)
                                                    : isSelectedExt[documentIndex] == ".mp3"
                                                        ? Image.asset("assets/images/mp3.png", fit: BoxFit.cover)
                                                        : isSelectedExt[documentIndex] == ".mp4"
                                                            ? Image.asset("assets/images/mp4.png", fit: BoxFit.cover)
                                                            : extension == ".png" || extension == ".jpeg"
                                                                ? const Icon(Icons.image, size: 60)
                                                                : Image.file(imagePath![documentIndex], fit: BoxFit.cover)
                                                : const Icon(Icons.add, size: 30),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey)),
                                          ),
                                        ),
                                        !isSelected[documentIndex]
                                            ? Container()
                                            : Positioned(
                                                right: 5,
                                                top: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (isSelected[documentIndex]) {
                                                      imagePath!.removeAt(documentIndex);
                                                      isSelected[documentIndex] = false;
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                                ))
                                      ],
                                    );
                                  },
                                  itemCount: isSelected.length))
                          : Container()
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: InkWell(
                    onTap: () async {
                      if (titleController.text.isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Enter title'.tr);
                        setState(() {});
                      } else if (descriptionController.text.isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please description title'.tr);
                        setState(() {});
                      } else if (imagePath?.isEmpty ?? true) {
                        WidgetUtils.errorDialog(context, 'Please select attachment'.tr);
                        setState(() {});
                      } else {
                        await createNewTicket();
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(int.parse(themeColor.value.barColor!.color!))),
                        height: 58,
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SvgPicture.asset("assets/images/CreateTicket.svg", height: 18),
                          const SizedBox(width: 8),
                          WidgetUtils.appTextWidget(context: context, title: "Create Support  Ticket".tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16)
                        ])),
                  ))),
        ),
      ),
    );
  }

  Future createNewTicket() async {
    isLoading = true;
    setState(() {});
    try {
      final request = http.MultipartRequest('POST', Uri.parse("https://dev.famrut.com/support/api/tickets/createTicket"));

      for (int i = 0; i < imagePath!.length; i++) {
        if (i < 3) {
          request.files.add(await http.MultipartFile.fromPath('attachment[]', imagePath![i].path));
        }
      }
      request.fields["user_id"] = widget.helpDeskId;
      request.fields["opener"] = "user";
      request.fields["department_id"] = "2";
      request.fields["subject"] = titleController.text;
      request.fields["body"] = descriptionController.text;
      request.fields["user_lang"] = "lang";
      request.fields["ticket_id"] = "";
      request.fields["ticketMsgId"] = "";
      Future.delayed(const Duration(milliseconds: 500), () async {
        await request.send().then((response) async {
          response.stream.transform(utf8.decoder).listen((value) {
            final data = json.decode(value);
            if (data["success"] == 1) {
              WidgetUtils.successDialog(context, data["message"]);
              isLoading = false;
              setState(() {});
              // Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pop(context, "true");
              // });
            } else {
              WidgetUtils.errorDialog(context, data["message"]);
              isLoading = false;
              setState(() {});
            }
          });
        });
      });
    } catch (e) {
      WidgetUtils.errorDialog(context, e.toString());
      isLoading = false;
      setState(() {});
      //   }
    }
  }
}
