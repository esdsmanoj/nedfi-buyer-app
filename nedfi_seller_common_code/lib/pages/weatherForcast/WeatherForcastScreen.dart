import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/utils/Constants.dart';
import '../../components/utils/widget_utils.dart';
import '../../model/WeatherResponse.dart';
import '../../singleton/header_singleton.dart';

class WeatherForecastScreen extends StatefulWidget {
  final WeatherModel weatherModel;

  const WeatherForecastScreen({Key? key, required this.weatherModel}) : super(key: key);

  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  String? temp, icon, dateStr;
  dynamic time;
  bool isScroll = false;
  final itemKey = GlobalKey(), itemKey1 = GlobalKey();

  @override
  void initState() {
    temp = widget.weatherModel.forecast!.forecastday![0].day!.maxtempC.toString();
    icon = widget.weatherModel.forecast!.forecastday![0].day!.condition!.text.toString();
    Future.delayed(const Duration(seconds: 2), () {
      scrollToIndex();
    });
    super.initState();
  }

  /// Scroll weather to particular device time.
  Future scrollToIndex() async {
    final ctx = itemKey.currentContext!;
    await Scrollable.ensureVisible(ctx);
    final ctx1 = itemKey1.currentContext!;
    await Scrollable.ensureVisible(ctx1);
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    dateStr = today.toString().substring(11, 13);
    time = int.parse(dateStr!);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetUtils.appTextWidget(context: context, title: 'Weather Forecast'.tr, color: Colors.white, fontSize: 18),
            WidgetUtils.appTextWidget(context: context, title: 'Source: Weather API', color: Colors.white, fontSize: 12),
          ],
        ),
        leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
      ),
      //  backgroundColor: ColorsConst.backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            key: itemKey1,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ValueListenableBuilder(
                  valueListenable: HeaderSingleton().weatherStreamController,
                  builder: (ctx, WeatherModel? weatherDetails, child) {
                    String imagePath = "";
                    String iconImage = weatherDetails!.current!.condition!.icon!;
                    if (iconImage.toLowerCase().contains("day")) {
                      imagePath = "day";
                    } else if (iconImage.toLowerCase().contains("night")) {
                      imagePath = "night";
                    }
                    return weatherDetails != null
                        ? Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WidgetUtils.appTextWidget(
                                        context: context,
                                        title: '${widget.weatherModel.forecast!.forecastday![0].hour![time].tempC.toString().substring(0, 2)}°C',
                                        family: 'Graphik',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          width: 150,
                                          child: WidgetUtils.appTextWidget(
                                            context: context,
                                            overflow: TextOverflow.ellipsis,
                                            title: weatherDetails.location!.name! + ", " + weatherDetails.location!.region! + ", " + weatherDetails.location!.country!,
                                            family: 'Graphik',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(child: Image.asset("assets/weather_icons/$imagePath/${weatherDetails.current!.condition!.text!}.png", fit: BoxFit.fill, height: 47, width: 60)),
                                      Flexible(
                                        child: SizedBox(
                                          width: 120,
                                          child: WidgetUtils.appTextWidget(
                                              context: context,
                                              overflow: TextOverflow.ellipsis,
                                              title: weatherDetails.current!.condition!.text!,
                                              family: 'Graphik',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: WidgetUtils.appTextWidget(
                                context: context, title: 'No Weather Data available', family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black, textAlign: TextAlign.center),
                          );
                  }),
              Container(
                  height: 185,
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/thermometer.sun.svg', color: Color(int.parse(themeColor.value.iconColor!.color!)), height: 28, width: 28),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetUtils.appTextWidget(context: context, title: "Pressure".tr, fontSize: 12, fontWeight: FontWeight.w500, family: 'Graphik'),
                                  //  const SizedBox(height: 5),
                                  WidgetUtils.appTextWidget(
                                      context: context, title: widget.weatherModel.current!.pressureIn!.toString() + " ATM", fontSize: 16, fontWeight: FontWeight.w500, family: 'Graphik'),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/cloud.hail.svg', color: Color(int.parse(themeColor.value.barColor!.color!)), height: 28, width: 28),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 90,
                                      child: WidgetUtils.appTextWidget(
                                          context: context, overflow: TextOverflow.ellipsis, softWrap: true, title: "Chance of rain".tr, fontSize: 12, family: 'Graphik', fontWeight: FontWeight.w500)),
                                  //  const SizedBox(height: 5),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: widget.weatherModel.forecast!.forecastday![0].day!.dailyChanceOfRain!.toString() + "%",
                                      fontSize: 16,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w500),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/sunrise.fill.svg', color: Color(int.parse(themeColor.value.iconColor!.color!)), height: 28, width: 28),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetUtils.appTextWidget(context: context, title: "Sunrise".tr, fontSize: 12, fontWeight: FontWeight.w500, family: 'Graphik'),
                                  //  const SizedBox(height: 5),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      softWrap: true,
                                      title: widget.weatherModel.forecast!.forecastday![0].astro!.sunrise!,
                                      fontSize: 16,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w500),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/sunset.fill.svg', color: Color(int.parse(themeColor.value.iconColor!.color!)), height: 28, width: 28),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 90, child: WidgetUtils.appTextWidget(context: context, title: "Sunset".tr, fontSize: 12, fontWeight: FontWeight.w500, family: 'Graphik')),
                                  //  const SizedBox(height: 5),
                                  WidgetUtils.appTextWidget(
                                      context: context, title: widget.weatherModel.forecast!.forecastday![0].astro!.sunset!, fontSize: 16, fontWeight: FontWeight.w500, family: 'Graphik'),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/wind.svg', color: Color(int.parse(themeColor.value.iconColor!.color!)), height: 28, width: 28),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetUtils.appTextWidget(context: context, title: "Wind".tr, fontSize: 12, family: 'Graphik', fontWeight: FontWeight.w500),
                                  //  const SizedBox(height: 5),
                                  WidgetUtils.appTextWidget(
                                      context: context, title: widget.weatherModel.current!.windKph!.toString() + "Km/h", fontSize: 16, family: 'Graphik', fontWeight: FontWeight.w500),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/humidity.fill.svg', color: Color(int.parse(themeColor.value.iconColor!.color!)), height: 28, width: 28),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 90, child: WidgetUtils.appTextWidget(context: context, title: "Humidity".tr, fontSize: 12, family: 'Graphik', fontWeight: FontWeight.w500)),
                                  //  const SizedBox(height: 5),
                                  WidgetUtils.appTextWidget(
                                      context: context, title: widget.weatherModel.current!.humidity!.toString() + "%", family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
              const SizedBox(height: 20),
              WidgetUtils.appTextWidget(context: context, title: 'Hourly Forecast'.tr, fontSize: 20, family: 'Graphik', fontWeight: FontWeight.w500),
              SizedBox(height: MediaQuery.of(context).size.height * 0.012),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.150,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.weatherModel.forecast!.forecastday![0].hour!.length,
                        itemBuilder: (ctx, index) {
                          String imagePath = "";
                          String iconImage = widget.weatherModel.forecast!.forecastday![0].hour![index].condition!.icon!;
                          if (iconImage.toLowerCase().contains("day")) {
                            imagePath = "day";
                          } else if (iconImage.toLowerCase().contains("night")) {
                            imagePath = "night";
                          }
                          String hourTime = widget.weatherModel.forecast!.forecastday![0].hour![index].time!.toString().substring(11, 13);
                          return Container(
                              key: hourTime == dateStr ? itemKey : null,
                              height: 140,
                              width: 80,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: hourTime == dateStr ? Colors.lightBlue.shade50 : const Color(0xffF7F7F7)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  WidgetUtils.appTextWidget(
                                    context: context,
                                    title: hourTime == dateStr
                                        ? 'Now'
                                        : int.parse(hourTime) < 12
                                            ? int.parse(hourTime) == 00
                                                ? '12 AM'
                                                : '${hourTime.substring(int.parse(hourTime) < 10 ? 1 : 0, hourTime.length)} AM'
                                            : '$hourTime PM',
                                    fontSize: 14,
                                    family: 'Graphik',
                                    fontWeight: FontWeight.w300,
                                  ),
                                  Image.asset("assets/weather_icons/$imagePath/${widget.weatherModel.forecast!.forecastday![0].hour![index].condition!.text!}.png",
                                      fit: BoxFit.fill, height: 47, width: 60),
                                  WidgetUtils.appTextWidget(
                                    context: context,
                                    title: hourTime == dateStr
                                        ? '${widget.weatherModel.forecast!.forecastday![0].hour![index].tempC.toString().substring(0, 2)}°C'
                                        : '${widget.weatherModel.forecast!.forecastday![0].hour![index].tempC!.toString().substring(0, 2)}°C',
                                    fontSize: 17,
                                    family: 'Graphik',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ));
                        }),
                  )),
              const SizedBox(height: 20),
              WidgetUtils.appTextWidget(
                context: context,
                title: 'Upcoming Forecast'.tr,
                fontSize: 20,
                family: 'Graphik',
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.012),
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.weatherModel.forecast!.forecastday!.length,
                  itemBuilder: (ctx, index) {
                    String imagePath = "";
                    String iconImage = widget.weatherModel.forecast!.forecastday![index].hour![0].condition!.icon!;
                    if (iconImage.toLowerCase().contains("day")) {
                      imagePath = "day";
                    } else if (iconImage.toLowerCase().contains("night")) {
                      imagePath = "night";
                    }
                    DateTime dateTime = DateTime.parse(widget.weatherModel.forecast!.forecastday![index].hour![0].time!);
                    String day = DateFormat('EEEE').format(dateTime);
                    final String formatter = DateFormat('MMMMd').format(dateTime);
                    return Container(
                        height: 75,
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xffF7F7F7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WidgetUtils.appTextWidget(
                                  context: context,
                                  title: day.toString().substring(0, 3),
                                  fontSize: 18,
                                  family: 'Graphik',
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 10),
                                WidgetUtils.appTextWidget(context: context, title: formatter, fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w400),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Image.asset("assets/weather_icons/$imagePath/${widget.weatherModel.forecast!.forecastday![index].day!.condition!.text!}.png", fit: BoxFit.fill, height: 40, width: 50),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: 94,
                              child: WidgetUtils.appTextWidget(
                                  context: context,
                                  softWrap: true,
                                  title: widget.weatherModel.forecast!.forecastday![index].day!.condition!.text.toString(),
                                  fontSize: 18,
                                  family: 'Graphik',
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffEF9920)),
                            ),
                            WidgetUtils.appTextWidget(
                              context: context,
                              title: '${widget.weatherModel.forecast!.forecastday![index].day!.maxtempC!.toString().substring(0, 2)}°C',
                              fontSize: 18,
                              family: 'Graphik',
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ));
                  }),
            ],
          ),
        ),
      )),
    ));
  }
}
