// import 'package:nedfi_seller_common_code/app_imports.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../components/widgets/base_widget.dart';
//
// class SelectDateScreen extends StatefulWidget {
//   String? cropID, from, cropName, image, date;
//
//   SelectDateScreen({super.key, this.cropID, this.from, this.cropName, this.image, this.date});
//
//   @override
//   _SelectDateScreenState createState() => _SelectDateScreenState();
// }
//
// class _SelectDateScreenState extends State<SelectDateScreen> {
//   final DateRangePickerController _datePickerController = DateRangePickerController();
//   DateTime selectedDateTwo = DateTime.now();
//   late CropCalenderOption season;
//   String selected = "";
//   List<CropCalenderOption> cropCalenderActionList = [];
//
//   @override
//   initState() {
//     _datePickerController.selectedDate = DateTime.now();
//     getAction();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: BaseWidget(
//         appBar: AppBar(
//           elevation: 0,
//           centerTitle: true,
//           backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
//           title: WidgetUtils.appTextWidget(context: context, title: 'Select Seeding Date'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
//           leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
//         ),
//         child: Container(
//           child: ListView(
//             children: [
//               cropCalenderActionList.isEmpty ? Container() : const SizedBox(height: 5),
//               cropCalenderActionList.isEmpty
//                   ? Container()
//                   : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Text('Type'.tr, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
//                     ),
//               cropCalenderActionList.isEmpty ? Container() : const SizedBox(height: 5),
//               cropCalenderActionList.isEmpty
//                   ? Container()
//                   : SizedBox(
//                       height: 50,
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             height: 50,
//                             width: 150,
//                             child: Row(
//                               children: [
//                                 Radio(
//                                     value: cropCalenderActionList[0],
//                                     groupValue: season,
//                                     activeColor: Color(int.parse(themeColor.value.iconColor!.color!)),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         season = value as CropCalenderOption;
//                                         selected = season.id!;
//                                       });
//                                     }),
//                                 Text(cropCalenderActionList[0].value!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Graphik',color: Colors.black)),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 50,
//                             width: 170,
//                             child: Row(
//                               children: [
//                                 Radio(
//                                     value: cropCalenderActionList[1],
//                                     groupValue: season,
//                                     activeColor: Color(int.parse(themeColor.value.iconColor!.color!)),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         season = value as CropCalenderOption;
//                                         selected = season.id!;
//                                       });
//                                     }),
//                                 Text(cropCalenderActionList[1].value!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Graphik',color: Colors.black)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 height: 300,
//                 width: MediaQuery.of(context).size.width,
//                 child: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//                   child: SfDateRangePicker(
//                     headerHeight: 60,
//                     viewSpacing: 10,
//                     selectionTextStyle: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontSize: 18, fontWeight: FontWeight.w400),
//                     monthCellStyle:  DateRangePickerMonthCellStyle(
//                         todayTextStyle: TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontFamily: 'Graphik', fontSize: 18, fontWeight: FontWeight.w400),
//                         weekendTextStyle: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontSize: 18, fontWeight: FontWeight.w400),
//                         textStyle: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontSize: 18, fontWeight: FontWeight.w400)),
//                     // headerStyle: DateRangePickerHeaderStyle(backgroundColor: Colors.grey.shade300),
//                     showNavigationArrow: true,
//                     view: DateRangePickerView.month,
//                     selectionMode: DateRangePickerSelectionMode.single,
//                     controller: _datePickerController,
//                     selectionColor: const Color(0xff27914F),
//                     onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//                       if (args.value is DateTime) {
//                         selectedDateTwo = args.value;
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavBar: SizedBox(
//           height: 100,
//           child: Center(
//             child: CustomDarkButton(
//                 caption: 'Next'.tr,
//                 onPressed: () {
//                   final DateFormat formatters = DateFormat('dd-MMM-yyyy');
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               CropCalendarScreen(actionType: selected, cropID: widget.cropID, from: "dss", cropName: widget.cropName, image: widget.image, date: formatters.format(selectedDateTwo))));
//                 }),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future getAction() async {
//     setState(() {
//       isLoading.value = true;
//     });
//     try {
//       final response = await APIService.getAPIMethod(url: ApiURL.crop_calender_action + "/" + widget.cropID!);
//       final data = json.decode(response.body);
//       // print(data);
//       var res = CropCalenderAction.fromJson(data);
//       if (res.success == 1) {
//         if (res.data != null) {
//           cropCalenderActionList = res.data![0].data!.option!;
//           season = cropCalenderActionList[0];
//           selected = cropCalenderActionList[0].id!;
//         }
//       }
//       setState(() {
//         isLoading.value = false;
//       });
//     } catch (e) {
//       // print(e.toString());
//       setState(() {
//         isLoading.value = false;
//       });
//     }
//   }
// }
