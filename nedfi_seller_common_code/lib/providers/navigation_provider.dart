import 'package:flutter/material.dart';
import '../model/MenuResponse.dart';

class NavigationProvider extends ChangeNotifier {
  List<Menu> menuList = List<Menu>.empty();

  /*from(json.decode(
      "[{id:2,title:Home,map_key:Home,icon:home},{id:3,title:My Farms,map_key:My-Farms,icon:my_farm},{id:4,title:Apply for Loan,map_key:Apply-for-Loan,icon:loan},{id:5,title:Commodity,map_key:Commodity,icon:commodity},{id:6,title:My Orders,map_key:My-Orders,icon:order},{id:7,title:Weather-Forcast,map_key:weather,icon:weather},{id:8,title:IOT-Devices,map_key:IOT-Devices,icon:iot_icon},{id:11,title:NPK Calculator,map_key:NPK-Calculator,icon:ic_calc},{id:12,title:Dockbox,map_key:Dockbox,icon:docbox},{id:14,title:Invite,map_key:Invite,icon:ic_invite},{id:15,title:About us,map_key:About-us,icon:about_us},{id:16,title:Privacy Policy,map_key:Privacy-Policy,icon:ic_assignment},{id:16,title:Notice,map_key:Notice,icon:ic_notice},{id:17,title:Announcement,map_key:Announcement,icon:ic_announcement},{id:18,title:Setting,map_key:Setting,icon:seeting}]")
  );*/

  setMenuList(List<Menu> list) {
    menuList = List<Menu>.empty();
    menuList = list;
    notifyListeners();
  }

  String profileImage = "";

  setProfileImage(String profile) {
    profileImage = profile;
    notifyListeners();
  }
}
