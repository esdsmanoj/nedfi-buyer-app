import 'package:nedfi_seller_common_code/components/custom_progress_handler.dart';
import 'package:nedfi_seller_common_code/model/Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../components/utils/Constants.dart';
import '../../components/utils/custom_text.dart';
import '../../singleton/header_singleton.dart';

class ServiceDetailsScreen extends StatefulWidget {
  ServiceOptions serviceData;

  ServiceDetailsScreen(this.serviceData, {super.key});

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool? _isLoading;
  String? _loadingText;
  var unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
          title: Text(
            HeaderSingleton().local == "en" ? (widget.serviceData.productServicesName ?? "") : (widget.serviceData.productServicesNameMr ?? ""),
          ),
        ),
        body: CustomProgressHandler(
            isLoading: _isLoading!,
            loadingText: _loadingText!,
            child: SafeArea(
                child: Scaffold( backgroundColor: Colors.white,
              body: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Text(widget.serviceData.productServicesName ?? "",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: CustomText(
                      fontsize: 20,
                      labelText: ('Brief'.tr),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Html(
                      data: unescape.convert(widget.serviceData.brief ?? ""),
                      style: {"body": Style(fontSize:  FontSize(20), letterSpacing: 0.0)},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: CustomText(
                      fontsize: 20,
                      labelText: 'key_overview'.tr,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Html(
                      data: unescape.convert(widget.serviceData.overview ?? ""),
                      style: {"body": Style(fontSize:  FontSize(18), letterSpacing: 0.0)},
                    ),
                  ),
                ],
              ),
            ))));
  }
}
