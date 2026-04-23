import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/controller/app_settings_controller.dart';
import 'package:simple_live_app/models/db/follow_user.dart';
import 'package:simple_live_app/models/db/follow_user_sort.dart';
import 'package:simple_live_app/services/follow_service.dart';

class CustomSortManagerController extends GetxController {
  final String? sortId;
  CustomSortManagerController({this.sortId});

  TextEditingController nameController = TextEditingController();
  RxList<FollowUser> sortUsers = <FollowUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    List<FollowUser> allFollows = FollowService.instance.followList;

    if (sortId != null) {
      // 编辑已有排序
      var customSort = AppSettingsController.instance.customSortList
          .firstWhereOrNull((e) => e.id == sortId);
      if (customSort != null) {
        nameController.text = customSort.name;

        // 按照 customSort.userIds 的顺序排列已关注的用户
        List<FollowUser> sorted = [];
        for (var uid in customSort.userIds) {
          var user = allFollows.firstWhereOrNull((e) => e.id == uid);
          if (user != null) {
            sorted.add(user);
          }
        }

        // 将新关注且不在列表中的用户补充在末尾
        for (var user in allFollows) {
          if (!customSort.userIds.contains(user.id)) {
            sorted.add(user);
          }
        }

        sortUsers.value = sorted;
        return;
      }
    }

    // 新建排序 (默认按关注顺序或原有顺序)
    sortUsers.value = List.from(allFollows);
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final FollowUser item = sortUsers.removeAt(oldIndex);
    sortUsers.insert(newIndex, item);
  }

  void save() {
    String name = nameController.text.trim();
    if (name.isEmpty) {
      SmartDialog.showToast("请输入排序名称");
      return;
    }

    List<String> userIds = sortUsers.map((e) => e.id).toList();

    var currentList = AppSettingsController.instance.customSortList.toList();

    if (sortId == null) {
      // 新建
      String newId = DateTime.now().millisecondsSinceEpoch.toString();
      currentList.add(FollowUserSort(id: newId, name: name, userIds: userIds));
      AppSettingsController.instance.setCustomSortList(currentList);
      AppSettingsController.instance.setFollowSortMode(3);
      AppSettingsController.instance.setCurrentCustomSortId(newId);
    } else {
      // 更新
      int index = currentList.indexWhere((e) => e.id == sortId);
      if (index != -1) {
        currentList[index] =
            FollowUserSort(id: sortId!, name: name, userIds: userIds);
        AppSettingsController.instance.setCustomSortList(currentList);
      }
    }

    FollowService.instance.filterData();
    Get.back();
    SmartDialog.showToast("保存成功");
  }

  void deleteSort() {
    if (sortId == null) return;
    var currentList = AppSettingsController.instance.customSortList.toList();
    currentList.removeWhere((e) => e.id == sortId);
    AppSettingsController.instance.setCustomSortList(currentList);

    if (AppSettingsController.instance.currentCustomSortId.value == sortId) {
      AppSettingsController.instance.setFollowSortMode(0); // 切回默认
      AppSettingsController.instance.setCurrentCustomSortId("");
    }

    FollowService.instance.filterData();
    Get.back();
    SmartDialog.showToast("已删除该自定义排序");
  }
}
