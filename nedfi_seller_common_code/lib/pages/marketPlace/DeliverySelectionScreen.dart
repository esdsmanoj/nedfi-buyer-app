import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/AllMenu.dart';
import 'CheckOutScreen.dart';
import 'SelectPickupPointScreen.dart';

class DeliverySelectionScreen extends StatefulWidget {
  const DeliverySelectionScreen({Key? key}) : super(key: key);

  @override
  _DeliverySelectionScreenState createState() => _DeliverySelectionScreenState();
}

class _DeliverySelectionScreenState extends State<DeliverySelectionScreen> {
  List<RadioModel> sampleData = [];
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late HomeDashboardProvider homeDashboardProvider;
  Location location = Location();
  bool? _isLoading;
  late String _loadingText;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    _initLocation();
    homeDashboardProvider = Provider.of<HomeDashboardProvider>(context, listen: false);
    getAllMenu();
  }

  _initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    homeDashboardProvider.setLatLog(_locationData.latitude.toString(), _locationData.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: _isLoading!,
      loadingText: _loadingText,
      child: SafeArea(
        child: Scaffold( backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            iconTheme: const IconThemeData(color: Colors.white),
            title: WidgetUtils.appTextWidget(context: context, title: 'Select Delivery type'.tr, color: Colors.white, fontSize: 18),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: ListView.builder(
                      itemCount: sampleData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              for (var element in sampleData) {
                                element.isSelected = false;
                              }
                              sampleData[index].isSelected = true;
                            });
                          },
                          child: RadioItem(sampleData[index]),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true),
                ),
                const SizedBox(height: 50),
                CustomDarkButton(
                  onPressed: () {
                    for (var element in sampleData) {
                      if (element.isSelected == true && element.map_key == "order_pickup") {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectPickupPointScreen()));
                      } else if (element.isSelected == true && element.map_key == "order_delivery") {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckOutScreen()));
                      }
                    }
                  },
                  caption: 'Submit'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getAllMenu() async {
    setState(() {
      _isLoading = true;
    });
    try {
      http.Response response = await http.get(Uri.parse(baseURL + ApiURL.all_menu), headers: headerParams);
      var data = json.decode(response.body);
      var res = AllMenu.fromJson(data);
      if (res.status == 1) {
        var homeDashboardModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        homeDashboardModel.setDeliveryMenuList(res.data!.pickupDeliveryMenu!);
        for (var element in res.data!.pickupDeliveryMenu!) {
          sampleData.add(RadioModel(false, '', element.title ?? '', element.mapKey ?? "order_pickup"));
        }
      } else {
        sampleData.add(RadioModel(false, '', 'Pickup Delivery'.tr, "order_pickup"));
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      sampleData.add(RadioModel(false, '', 'Pickup Delivery'.tr, "order_pickup"));
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: const Color(0xff92b89e).withOpacity(0.7), offset: const Offset(0, 15), blurRadius: 16.0),
        ],
        border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!)), width: 1.0, style: BorderStyle.solid),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 30.0,
              width: 30.0,
              child: const Center(
                child: Icon(Icons.check, size: 25, color: Colors.white),
              ),
              decoration: BoxDecoration(
                  color: _item.isSelected ? Colors.green : Colors.transparent,
                  border: Border.all(width: 1.0, color: _item.isSelected ? Colors.green : Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0))),
            ),
            Container(margin: const EdgeInsets.only(left: 10.0), child: Text(_item.text))
          ],
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;
  final String map_key;

  RadioModel(this.isSelected, this.buttonText, this.text, this.map_key);
}
