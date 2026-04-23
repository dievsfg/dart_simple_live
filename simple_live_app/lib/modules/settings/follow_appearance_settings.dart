import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/controller/app_settings_controller.dart';
import 'package:simple_live_app/routes/app_navigation.dart';
import 'package:simple_live_app/services/follow_service.dart';
import 'package:simple_live_app/widgets/settings/settings_action.dart';

class FollowAppearanceSettings extends StatelessWidget {
  final AppSettingsController controller;

  const FollowAppearanceSettings({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => SettingsAction(
            title: "关注列表样式",
            subtitle: "切换关注列表为传统单列或封面网格模式",
            value: controller.followListStyle.value == 0 ? "列表模式" : "封面网格模式",
            onTap: () {
              _showListStyleDialog();
            },
          ),
        ),
        AppStyle.divider,
        Obx(() {
          String sortValue = "默认排序";
          int sortMode = controller.followSortMode.value;
          if (sortMode == 1) {
            sortValue = "按热度排序";
          } else if (sortMode == 2) {
            sortValue = "按开播时间排序";
          } else if (sortMode == 3) {
            var currentId = controller.currentCustomSortId.value;
            var customSort = controller.customSortList
                .firstWhereOrNull((e) => e.id == currentId);
            if (customSort != null) {
              sortValue = "自定义：${customSort.name}";
            } else {
              sortValue = "自定义排序 (未选择)";
            }
          }

          return SettingsAction(
            title: "直播列表排序方式",
            subtitle: "设置开播主播的优先排序规则",
            value: sortValue,
            onTap: () {
              _showSortModeDialog();
            },
          );
        }),
        AppStyle.divider,
        Obx(() {
          var colorValue = controller.liveTitleColor.value;
          var displayValue = colorValue == 0 ? "默认颜色" : "自定义颜色";
          return SettingsAction(
            title: "直播标题颜色",
            subtitle: "设置网格模式下的直播标题颜色",
            value: displayValue,
            onTap: () {
              _showTitleColorDialog(context);
            },
          );
        }),
      ],
    );
  }

  void _showListStyleDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("选择列表样式"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => RadioListTile<int>(
                  title: const Text("传统列表模式"),
                  value: 0,
                  groupValue: controller.followListStyle.value,
                  onChanged: (e) {
                    if (e != null) {
                      controller.setFollowListStyle(e);
                      Get.back();
                    }
                  },
                )),
            Obx(() => RadioListTile<int>(
                  title: const Text("封面网格模式"),
                  value: 1,
                  groupValue: controller.followListStyle.value,
                  onChanged: (e) {
                    if (e != null) {
                      controller.setFollowListStyle(e);
                      Get.back();
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showSortModeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("直播列表排序方式"),
        content: SizedBox(
          width: 300,
          child: Obx(
            () => ListView(
              shrinkWrap: true,
              children: [
                RadioListTile<int>(
                  title: const Text("默认排序 (添加顺序)"),
                  value: 0,
                  groupValue: controller.followSortMode.value,
                  onChanged: (e) {
                    if (e != null) {
                      controller.setFollowSortMode(e);
                      Get.back();
                      FollowService.instance.filterData();
                    }
                  },
                ),
                RadioListTile<int>(
                  title: const Text("按热度排序"),
                  value: 1,
                  groupValue: controller.followSortMode.value,
                  onChanged: (e) {
                    if (e != null) {
                      controller.setFollowSortMode(e);
                      Get.back();
                      FollowService.instance.filterData();
                    }
                  },
                ),
                RadioListTile<int>(
                  title: const Text("按开播时间排序"),
                  value: 2,
                  groupValue: controller.followSortMode.value,
                  onChanged: (e) {
                    if (e != null) {
                      controller.setFollowSortMode(e);
                      Get.back();
                      FollowService.instance.filterData();
                    }
                  },
                ),
                if (controller.customSortList.isNotEmpty) const Divider(),
                ...controller.customSortList
                    .map(
                      (customSort) => RadioListTile<String>(
                        title: Row(
                          children: [
                            Expanded(child: Text("自定义：${customSort.name}")),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                Get.back();
                                AppNavigator.toCustomSortManager(customSort.id);
                              },
                            ),
                          ],
                        ),
                        value: customSort.id,
                        groupValue: controller.followSortMode.value == 3
                            ? controller.currentCustomSortId.value
                            : "",
                        onChanged: (e) {
                          if (e != null) {
                            controller.setFollowSortMode(3);
                            controller.setCurrentCustomSortId(e);
                            Get.back();
                            FollowService.instance.filterData();
                          }
                        },
                      ),
                    )
                    .toList(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text("添加自定义排序"),
                  onTap: () {
                    Get.back();
                    AppNavigator.toCustomSortManager(null);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTitleColorDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("设置直播标题颜色"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => RadioListTile<int>(
                    title: const Text("默认颜色"),
                    value: 0,
                    groupValue: controller.liveTitleColor.value,
                    onChanged: (e) {
                      if (e != null) {
                        controller.setLiveTitleColor(e);
                        Get.back();
                      }
                    },
                  )),
              Obx(() => RadioListTile<int>(
                    title: Row(
                      children: [
                        const Text("红色"),
                        const SizedBox(width: 8),
                        Container(width: 16, height: 16, color: Colors.red),
                      ],
                    ),
                    value: Colors.red.value,
                    groupValue: controller.liveTitleColor.value,
                    onChanged: (e) {
                      if (e != null) {
                        controller.setLiveTitleColor(e);
                        Get.back();
                      }
                    },
                  )),
              Obx(() => RadioListTile<int>(
                    title: Row(
                      children: [
                        const Text("橙色"),
                        const SizedBox(width: 8),
                        Container(width: 16, height: 16, color: Colors.orange),
                      ],
                    ),
                    value: Colors.orange.value,
                    groupValue: controller.liveTitleColor.value,
                    onChanged: (e) {
                      if (e != null) {
                        controller.setLiveTitleColor(e);
                        Get.back();
                      }
                    },
                  )),
              Obx(() => RadioListTile<int>(
                    title: Row(
                      children: [
                        const Text("黄色"),
                        const SizedBox(width: 8),
                        Container(width: 16, height: 16, color: Colors.yellow),
                      ],
                    ),
                    value: Colors.yellow.value,
                    groupValue: controller.liveTitleColor.value,
                    onChanged: (e) {
                      if (e != null) {
                        controller.setLiveTitleColor(e);
                        Get.back();
                      }
                    },
                  )),
              Obx(() => RadioListTile<int>(
                    title: Row(
                      children: [
                        const Text("绿色"),
                        const SizedBox(width: 8),
                        Container(width: 16, height: 16, color: Colors.green),
                      ],
                    ),
                    value: Colors.green.value,
                    groupValue: controller.liveTitleColor.value,
                    onChanged: (e) {
                      if (e != null) {
                        controller.setLiveTitleColor(e);
                        Get.back();
                      }
                    },
                  )),
              Obx(() => RadioListTile<int>(
                    title: Row(
                      children: [
                        const Text("蓝色"),
                        const SizedBox(width: 8),
                        Container(width: 16, height: 16, color: Colors.blue),
                      ],
                    ),
                    value: Colors.blue.value,
                    groupValue: controller.liveTitleColor.value,
                    onChanged: (e) {
                      if (e != null) {
                        controller.setLiveTitleColor(e);
                        Get.back();
                      }
                    },
                  )),
              Obx(() => RadioListTile<int>(
                    title: Row(
                      children: [
                        const Text("紫色"),
                        const SizedBox(width: 8),
                        Container(width: 16, height: 16, color: Colors.purple),
                      ],
                    ),
                    value: Colors.purple.value,
                    groupValue: controller.liveTitleColor.value,
                    onChanged: (e) {
                      if (e != null) {
                        controller.setLiveTitleColor(e);
                        Get.back();
                      }
                    },
                  )),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text("自定义颜色..."),
                onTap: () {
                  Get.back();
                  _showCustomColorPicker(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomColorPicker(BuildContext context) {
    Color pickerColor = controller.liveTitleColor.value == 0
        ? Colors.white
        : Color(controller.liveTitleColor.value);

    Get.dialog(
      AlertDialog(
        title: const Text('选择自定义颜色'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (Color color) {
              pickerColor = color;
            },
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
            pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('确定'),
            onPressed: () {
              controller.setLiveTitleColor(pickerColor.value);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
