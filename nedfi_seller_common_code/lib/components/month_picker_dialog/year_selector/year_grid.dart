import 'package:nedfi_seller_common_code/components/month_picker_dialog/year_selector/year_button.dart';
import 'package:flutter/material.dart';

import '../helpers/controller.dart';
import '../helpers/locale_utils.dart';

class YearGrid extends StatelessWidget {
  const YearGrid({
    super.key,
    required this.page,
    required this.onYearSelected,
    required this.controller,
  });
  final int page;
  final ValueChanged<int> onYearSelected;
  final MonthpickerController controller;

  @override
  Widget build(BuildContext context) {
    final String localeString =
        getLocale(context, selectedLocale: controller.locale);
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      children: List<Widget>.generate(
        12,
        (final int index) => YearButton(
          theme: controller.theme,
          controller: controller,
          page: page,
          index: index,
          onYearSelected: onYearSelected,
          localeString: localeString,
        ),
      ).toList(growable: false),
    );
  }
}
