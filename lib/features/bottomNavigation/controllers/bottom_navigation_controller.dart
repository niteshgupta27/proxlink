import 'package:get/get.dart';
import 'package:proxlink/features/Chat/view/chatView.dart';
import 'package:proxlink/features/discovery/view/discoveryView.dart';
import 'package:proxlink/features/job/view/jobView.dart';
import 'package:proxlink/features/network/view/networkView.dart';
import 'package:proxlink/features/zone/view/zone_view.dart';

import '../../../Utill/app_storage.dart';


class BottomNavigationController extends GetxController {

  String TAG = "BottomNavigationController";
  RxBool isMobilex = false.obs;
  final List<GetView> pages = [
     DiscoveryView(),
     NetworkView(),
    JobView(),
    ZoneView(),
     ChatView()
  ];
  var appStorage = Get.find<AppStorage>();

  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  changeIndex(val) {_currentIndex.value = val;
    if(val==0){
   // AppUtils.updateHeaderColor(appStorage.productheadColor);
    }
  else if(val==1){
    //AppUtils.updateHeaderColor(appStorage.serviceheadColor);
  }
    else{
     // AppUtils.updateHeaderColor(appStorage.AmcHeaderColor);
    }
  }

  @override
  void onInit() {
    super.onInit();
    var x = Get.arguments;
    if (x != null) {
      _currentIndex.value = x["selectedIndex"];
    }


    }

}
