import 'package:buyer_common_code/model/LoanDetailsResponse.dart';
import 'package:flutter/material.dart';

import '../model/LoanTypeResponse.dart';

class LoanTypeProvider extends ChangeNotifier {
  List<LoanTypeData> loanTypeList = [];

  setLoanTypeList(List<LoanTypeData> list) {
    loanTypeList = List<LoanTypeData>.empty();
    loanTypeList = list;
    notifyListeners();
  }

  List<LoanDetailsData> loanDetailsList = [];

  setLoanDetailsList(List<LoanDetailsData> list) {
    loanDetailsList = List<LoanDetailsData>.empty();
    loanDetailsList = list;
    notifyListeners();
  }
}
