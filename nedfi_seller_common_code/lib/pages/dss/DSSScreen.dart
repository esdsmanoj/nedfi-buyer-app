import 'package:nedfi_seller_common_code/pages/crop_list/crop_list.dart';
import 'package:flutter/material.dart';

class DSSScreen extends StatelessWidget {
  const DSSScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CropListScreen(isStatus: 'DSS');
  }
}
