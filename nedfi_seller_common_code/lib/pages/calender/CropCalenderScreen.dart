import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/utils/steppers.dart' as step;

class CropCalendarScreen extends StatefulWidget {
  String? cropID, from, cropName, image, date, actionType;

  CropCalendarScreen({super.key, this.cropID, this.from, this.cropName, this.image, this.date, this.actionType});

  @override
  _CropCalendarScreenState createState() => _CropCalendarScreenState();
}

class _CropCalendarScreenState extends State<CropCalendarScreen> {
  bool dateVisible = false;
  bool isDataNotFound = false;
  DateTime selectedDateTwo = DateTime.now();
  String  season = "";
  int indexTapped = 0, nurseryIndexTapped = 0;
  Color? color;

  Future<void> _selectDateTwo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDateTwo, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateTwo) {
      setState(() {
        selectedDateTwo = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCropCalendarDetails();
    if (widget.from == "home") {
      dateVisible = true;
    } else {
      dateVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
        title: WidgetUtils.appTextWidget(context: context, title: 'Crop Calender'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
      ),
      child: Provider.of<LandCropProvider>(context, listen: false).newResultData == null
          ? Center(
              child: Text(
                'Data not available'.tr,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.left,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: const EdgeInsets.only(bottom: 18),
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      color: const Color(0xffE7F3EB),
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.image!,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 50,
                                child: Container(
                                    decoration: BoxDecoration(
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                )),
                              ),
                              placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover, height: 58, width: 58),
                              errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover, height: 58, width: 58),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          // height: MediaQuery.of(context).size.height * 0.12,
                          // width: double.maxFinite,
                          // decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16))),
                          WidgetUtils.appTextWidget(
                              context: context,
                              title: (widget.cropName ?? "") + " (" + season + ")",
                              textAlign: TextAlign.center,
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              family: 'Graphik'),
                        ],
                      )),
                  (Provider.of<LandCropProvider>(context, listen: false).newResultData != null && Provider.of<LandCropProvider>(context, listen: false).newResultData!.fieldPreparation != null) &&
                          Provider.of<LandCropProvider>(context, listen: false).newResultData!.fieldPreparation!.isNotEmpty
                      ? Container(
                          // height: 45,
                          margin: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
                          child: ToggleList(
                            shrinkWrap: true,
                            trailing: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.keyboard_arrow_down_sharp, color: Color(0xFF0F853B)),
                            ),
                            children: [
                              ToggleListItem(
                                  isInitiallyExpanded: true,
                                  title: SizedBox(
                                    // height: 45,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                                      child: WidgetUtils.appTextWidget(
                                          context: context, title: "Field Preparation".tr, fontSize: 16, color: const Color(0xFF0F853B), fontWeight: FontWeight.w500, family: 'Graphik'),
                                    ),
                                  ),
                                  headerDecoration: BoxDecoration(color: const Color(0xffE7F3EB), borderRadius: BorderRadius.circular(4)),
                                  // itemDecoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(12)),
                                  // expandedHeaderDecoration: BoxDecoration(color: const Color(0xff27914F), borderRadius: BorderRadius.circular(4)),
                                  content: SizedBox(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: Provider.of<LandCropProvider>(context, listen: false).newResultData!.fieldPreparation!.length,
                                        itemBuilder: (ctx, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0, left: 12, right: 9),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                WidgetUtils.appTextWidget(
                                                    context: context,
                                                    title: HeaderSingleton().local == 'en'
                                                        ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.fieldPreparation![index].activities!
                                                        : Provider.of<LandCropProvider>(context, listen: false).newResultData!.fieldPreparation![index].activitiesMr!,
                                                    fontWeight: FontWeight.w500,
                                                    family: 'Graphik',
                                                    color: Colors.black,
                                                    fontSize: 14),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                WidgetUtils.appTextWidget(
                                                    context: context,
                                                    title: HeaderSingleton().local == 'en'
                                                        ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.fieldPreparation![index].details!
                                                        : Provider.of<LandCropProvider>(context, listen: false).newResultData!.fieldPreparation![index].detailsMr!,
                                                    fontWeight: FontWeight.w400,
                                                    family: 'Graphik',
                                                    fontSize: 14),
                                                const SizedBox(height: 08),
                                              ],
                                            ),
                                          );
                                        }),
                                  ))
                            ],
                          ),
                        )
                      : Container(),
                  Provider.of<LandCropProvider>(context, listen: false).newResultData != null && Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery != null
                      ? Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.maxFinite,
                              height: 34,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: WidgetUtils.appTextWidget(
                                  context: context, title: "Nursery".tr, textAlign: TextAlign.start, color: const Color(0xFF0F853B), family: 'Graphik', fontSize: 16.0, fontWeight: FontWeight.w400),
                              decoration: const BoxDecoration(color: Color(0xFFCFE7D8)),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            Container(
                              child: Theme(
                                  data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: color)),
                                  child: step.Steppers(
                                    physics: const NeverScrollableScrollPhysics(),
                                    currentStep: nurseryIndexTapped,
                                    controlsBuilder: (ctx, details) {
                                      return Container();
                                    },
                                    onStepTapped: (value) {
                                      nurseryIndexTapped = value;
                                      setState(() {});
                                    },
                                    steps: List.generate(Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery!.length, (index) {
                                      DateTime dateTwoSelected =
                                          selectedDateTwo.add(Duration(days: int.parse(Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].daysCount!)));
                                      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
                                      String formattedValue = "";
                                      color = Colors.green;

                                      if (widget.date != null) {
                                        DateTime tempDate = DateFormat("dd-MMM-yyyy")
                                            .parse(widget.date!)
                                            .add(Duration(days: int.parse(Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].daysCount!) - 1));
                                        formattedValue = formatter.format(tempDate);
                                        DateTime currentDate = DateTime.now();
                                        if (currentDate.isSameDate(tempDate)) {
                                          color = Colors.orange;
                                        } else if (currentDate.isAfter(tempDate)) {
                                          color = Colors.green;
                                        } else if (currentDate.isBefore(tempDate)) {
                                          color = Colors.deepPurple;
                                        }
                                      } else {
                                        formattedValue = formatter.format(dateTwoSelected);
                                        DateTime currentDate = DateTime.now();
                                        if (currentDate.isSameDate(dateTwoSelected)) {
                                          color = Colors.orange;
                                        } else if (currentDate.isAfter(dateTwoSelected)) {
                                          color = Colors.green;
                                        } else if (currentDate.isBefore(dateTwoSelected)) {
                                          color = Colors.deepPurple;
                                        }
                                      }
                                      return step.Steps(
                                          state: step.StepsState.complete,
                                          isActive: nurseryIndexTapped >= 0,
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 120,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: color),
                                                child: Text(
                                                  formattedValue,
                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                              const Icon(Icons.keyboard_arrow_down)
                                            ],
                                          ),
                                          content: InkWell(
                                            onTap: () {
                                              (HeaderSingleton().local == "en"
                                                              ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].details
                                                              : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].detailsMr) !=
                                                          null &&
                                                      (HeaderSingleton().local == "en"
                                                              ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].details!
                                                              : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].detailsMr!)
                                                          .isNotEmpty
                                                  ? _showCalendarDetail(context, Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index])
                                                  : {};
                                            },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                (HeaderSingleton().local == "en"
                                                                ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].activities!
                                                                : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].activitiesMr!) !=
                                                            null &&
                                                        (HeaderSingleton().local == "en"
                                                                ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].activities!
                                                                : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].activitiesMr!)
                                                            .isNotEmpty
                                                    ? SizedBox(
                                                        width: 180,
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: HeaderSingleton().local == "en"
                                                                ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].activities!
                                                                : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].activitiesMr!,
                                                            color: const Color(0xFF000000),
                                                            fontSize: 14,
                                                            family: 'Graphik',
                                                            fontWeight: FontWeight.w500))
                                                    : Container(),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                (HeaderSingleton().local == "en"
                                                                ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].details
                                                                : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].detailsMr) !=
                                                            null &&
                                                        (HeaderSingleton().local == "en"
                                                                ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].details!
                                                                : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].detailsMr!)
                                                            .isNotEmpty
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          SizedBox(
                                                            child: WidgetUtils.appTextWidget(
                                                                context: context,
                                                                title: HeaderSingleton().local == "en"
                                                                    ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].details!
                                                                    : Provider.of<LandCropProvider>(context, listen: false).newResultData!.nursery![index].detailsMr!,
                                                                softWrap: true,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400,
                                                                family: 'Graphik',
                                                                fontSize: 11),
                                                            width: MediaQuery.of(context).size.width * 0.5,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 8.0),
                                                            child: WidgetUtils.appTextWidget(context: context, title: "Read more".tr, fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500),
                                                          )
                                                        ],
                                                      )
                                                    : Text(
                                                        'Data not available'.tr,
                                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
                                                        textAlign: TextAlign.left,
                                                      )
                                              ],
                                            ),
                                          ));
                                    }),
                                  )),
                            ),
                          ],
                        )
                      : Container(),
                  Provider.of<LandCropProvider>(context, listen: false).newResultData != null && Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting != null
                      ? Column(children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: 34,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: WidgetUtils.appTextWidget(
                                context: context, title: "Transplanting".tr, textAlign: TextAlign.start, color: const Color(0xFF0F853B), fontSize: 16.0, fontWeight: FontWeight.w400),
                            decoration: const BoxDecoration(color: Color(0xFFCFE7D8)),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          Container(
                            child: Theme(
                                data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: color)),
                                child: step.Steppers(
                                  physics: const NeverScrollableScrollPhysics(),
                                  currentStep: indexTapped,
                                  controlsBuilder: (ctx, details) {
                                    return Container();
                                  },
                                  onStepTapped: (value) {
                                    indexTapped = value;
                                    setState(() {});
                                  },
                                  steps: List.generate(Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting!.length, (index) {
                                    String? formattedValue;

                                    if (Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].daysCount != null) {
                                      DateTime dateTwoSelected =
                                          selectedDateTwo.add(Duration(days: int.parse(Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].daysCount!)));
                                      final DateFormat formatter = DateFormat('dd-MMM-yyyy');

                                      color = Colors.green;

                                      if (widget.date != null) {
                                        DateTime tempDate = DateFormat("dd-MMM-yyyy")
                                            .parse(widget.date!)
                                            .add(Duration(days: int.parse(Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].daysCount!) - 1));
                                        formattedValue = formatter.format(tempDate);
                                        DateTime currentDate = DateTime.now();
                                        if (currentDate.isSameDate(tempDate)) {
                                          color = Colors.orange;
                                        } else if (currentDate.isAfter(tempDate)) {
                                          color = Colors.green;
                                        } else if (currentDate.isBefore(tempDate)) {
                                          color = Colors.deepPurple;
                                        }
                                      } else {
                                        formattedValue = formatter.format(dateTwoSelected);
                                        DateTime currentDate = DateTime.now();
                                        if (currentDate.isSameDate(dateTwoSelected)) {
                                          color = Colors.orange;
                                        } else if (currentDate.isAfter(dateTwoSelected)) {
                                          color = Colors.green;
                                        } else if (currentDate.isBefore(dateTwoSelected)) {
                                          color = Colors.deepPurple;
                                        }
                                      }
                                    }
                                    return step.Steps(
                                        state: step.StepsState.complete,
                                        isActive: indexTapped >= 0,
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 120,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: color),
                                              child: Text(
                                                formattedValue ?? 'NULL',
                                                style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            const Icon(Icons.keyboard_arrow_down)
                                          ],
                                        ),
                                        content: InkWell(
                                          onTap: () {
                                            (HeaderSingleton().local == "en"
                                                            ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].details
                                                            : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].detailsMr) !=
                                                        null &&
                                                    (HeaderSingleton().local == "en"
                                                            ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].details!
                                                            : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].detailsMr!)
                                                        .isNotEmpty
                                                ? _showCalendarDetail(context, Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index])
                                                : {};
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              (HeaderSingleton().local == "en"
                                                              ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].activities ?? 'NULL'
                                                              : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].activitiesMr ?? 'NULL') !=
                                                          null &&
                                                      (HeaderSingleton().local == "en"
                                                              ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].activities ?? 'NULL'
                                                              : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].activitiesMr ?? 'NULL')
                                                          .isNotEmpty
                                                  ? SizedBox(
                                                      width: 180,
                                                      child: WidgetUtils.appTextWidget(
                                                          context: context,
                                                          title: HeaderSingleton().local == "en"
                                                              ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].activities ?? 'NULL'
                                                              : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].activitiesMr ?? 'NULL',
                                                          color: const Color(0xFF000000),
                                                          family: 'Graphik',
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500))
                                                  : Container(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              (HeaderSingleton().local == "en"
                                                              ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].details
                                                              : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].detailsMr) !=
                                                          null &&
                                                      (HeaderSingleton().local == "en"
                                                              ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].details!
                                                              : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].detailsMr!)
                                                          .isNotEmpty
                                                  ? Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        SizedBox(
                                                          child: WidgetUtils.appTextWidget(
                                                              context: context,
                                                              title: HeaderSingleton().local == "en"
                                                                  ? Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].details!
                                                                  : Provider.of<LandCropProvider>(context, listen: false).newResultData!.transplanting![index].detailsMr!,
                                                              softWrap: true,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w400),
                                                          width: MediaQuery.of(context).size.width * 0.5,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8.0),
                                                          child: WidgetUtils.appTextWidget(
                                                              context: context, title: "Read more".tr, color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500, family: 'Graphik'),
                                                        )
                                                      ],
                                                    )
                                                  : Text(
                                                      'Data not available'.tr,
                                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                                                      textAlign: TextAlign.left,
                                                    )
                                            ],
                                          ),
                                        ));
                                  }),
                                )),
                          )
                        ])
                      : Container()

                  // Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  //     child: Card(
                  //       child: ListView.builder(
                  //           itemCount: landCropModel.cropCalenderList.length,
                  //           scrollDirection: Axis.vertical,
                  //           shrinkWrap: true,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           itemBuilder: (context, index) {
                  //             return _farmerItem(landCropModel.cropCalenderList[index], index);
                  //           }),
                  //     )),
                ],
              ),
            ),
    );
  }

  void _showCalendarDetail(BuildContext ctx, final cropCal) {
    showDialog(
        context: ctx,
        builder: (BuildContext newCtx) {
          return Consumer<LandCropProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (builderContext, StateSetter setState) {
              return AlertDialog(
                  titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  contentPadding: const EdgeInsets.only(left: 16, right: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: WidgetUtils.buttonWidget(
                          context: context,
                          height: 45,
                          borderWidth: 0.2,
                          radius: 8,
                          title: "Ok".tr,
                          size: 16,
                          family: 'Graphik',
                          weight: FontWeight.w500,
                          callback: () {
                            Navigator.pop(newCtx);
                          },
                          textColor: Colors.white,
                          color: const Color(0xff27914F)),
                    )
                  ],
                  title: WidgetUtils.appTextWidget(
                      context: context, title: (widget.cropName ?? "".tr) + " (" + season + ")", textAlign: TextAlign.start, fontWeight: FontWeight.w700, family: 'Graphik', fontSize: 16),
                  content: SizedBox(
                    // height: MediaQuery.of(builderContext).size.height * 0.35, // Change as per your requirement
                    width: 600.0,
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        WidgetUtils.appTextWidget(context: context, title: 'Activities :'.tr, color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, family: 'Graphik'),
                        const SizedBox(width: 10),
                        Container(
                            child: Text(HeaderSingleton().local == "en" ? cropCal!.activities! : cropCal!.activitiesMr!,
                                textAlign: TextAlign.justify, style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Graphik'))),
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title: 'Details :   '.tr, color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, family: 'Graphik'),
                        const SizedBox(width: 10),
                        Container(
                            child: Text(HeaderSingleton().local == "en" ? cropCal.details! : cropCal.detailsMr!,
                                textAlign: TextAlign.justify, style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Graphik'))),
                        const SizedBox(height: 15),
                        Visibility(
                          visible: dateVisible,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: WidgetUtils.appTextWidget(context: context, title: "Date :", color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, family: 'Graphik'),
                              ),
                              const SizedBox(width: 5),
                              WidgetUtils.appTextWidget(context: context, title: cropCal.createdOn!.split(" ")[0]),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        // CustomDarkButton(
                        //     caption: "OK",
                        //     onPressed: () {
                        //       Navigator.pop(builderContext);
                        //     })
                      ]),
                    ),
                  ));
            });
          });
        });
  }

  Future fetchCropCalendarDetails() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final param = {'calender_action': widget.actionType ?? "Seedlings", 'crop_id': widget.cropID!, 'seeding_date': widget.date, 'user_id': HeaderSingleton().paramsMaps!.userId!};
        final response = await APIService.postAPIMethod(url: ApiURL.cropCalendarData, params: param);
        var data = json.decode(response.body);
        print(data);
        CropCalenderResponse cropDetails = CropCalenderResponse.fromJson(data);
        if (cropDetails.success != 1) {
          isDataNotFound = true;
          WidgetUtils.informationDialog(context, data["msg"] ?? "");
        } else {
          var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
          setCalendarDetails(cropDetails,'calendar',landCropModel);
          setCalendarDetails(cropDetails,'newResult',landCropModel);
          // if (cropDetails.data != null && cropDetails.data!.cropCal!.isNotEmpty) {
          //   var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
          //   landCropModel.setCropCalenderList(cropDetails.data!.cropCal!);
          //   if (widget.date == null) {
          //     _selectDateTwo(context);
          //   }
          //   season = cropDetails.season ?? "";
          // }
          // if (cropDetails.data != null && cropDetails.data!.newResult != null) {
          //   var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
          //   landCropModel.setNewResultData(cropDetails.data!.newResult!);
          //   if (widget.date == null) {
          //     _selectDateTwo(context);
          //   }
          //   season = cropDetails.season ?? "";
          // }
        }
        setState(() {});
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  void setCalendarDetails(final cropDetails, String title, final landCropModel) {
    switch (title) {
      case "calendar":
        if (cropDetails.data != null && cropDetails.data!.cropCal!.isNotEmpty) {
          landCropModel.setCropCalenderList(cropDetails.data!.cropCal!);
        }
        break;
      case "newResult":
        if (cropDetails.data != null && cropDetails.data!.newResult != null) {
          landCropModel.setNewResultData(cropDetails.data!.newResult!);
        }
        break;
    }
    if (widget.date == null) {
      _selectDateTwo(context);
    }
    season = cropDetails.season ?? "";
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
