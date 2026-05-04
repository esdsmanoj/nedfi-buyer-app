import 'package:nedfi_seller_common_code/pages/marketPlace/product_screen/ProductListScreen.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/seller/SellerHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/utils/Constants.dart';

class BuySellScreen extends StatefulWidget {
  const BuySellScreen({Key? key}) : super(key: key);

  @override
  _BuySellScreenState createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> with TickerProviderStateMixin {
  var kLabels = ['Buy Products', 'Sell Product'];
  var kTabBgColor = const Color(0xff7cb342);
  var kTabFgColor = Colors.white;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = TabController(length: 2, vsync: this);
    return Scaffold( backgroundColor: Colors.white,
      body: Column(
        children: [
          /*MyTabBar(
            controller: _controller,
            labels: kLabels,
            backgroundColor: kTabFgColor,
            foregroundColor: kTabBgColor,
            activeBackgroundColor: kTabBgColor,
            activeForegroundColor: kTabFgColor,
            fontSize: 18,
          ),*/
          Container(
            margin: const EdgeInsets.all(10),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                25.0,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              // give the indicator a decoration (color and border radius)
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                color: Color(int.parse(themeColor.value.barColor!.color!)),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                // first tab [you can add an icon using the icon property]
                Tab(text: 'Buy Products'.tr),

                // second tab [you can add an icon using the icon property]
                Tab(text: 'Sell Product'.tr)
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                const ProductListScreen(),
                SellerHomeScreen(onAddButtonTap: (i) {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
