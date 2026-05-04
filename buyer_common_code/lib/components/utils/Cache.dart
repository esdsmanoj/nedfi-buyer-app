import '../../model/Products.dart';

class Cache {
  static Cache instance = Cache();

  static Cache getInstance() {
    return instance;
  }

  List<VehicleType> vehicleTypeData = [];
  late ConfigUrl? configUrlData;

  clear() {
    vehicleTypeData = [];
  }

  List<VehicleType> getVehicleType() {
    return vehicleTypeData;
  }

  void setVehicleType(List<VehicleType> vehicleTypeData) {
    this.vehicleTypeData = vehicleTypeData;
  }

  ConfigUrl? getConfigUrl() {
    return configUrlData;
  }

  void setConfigUrl(ConfigUrl companies) {
    configUrlData = companies;
  }
}
