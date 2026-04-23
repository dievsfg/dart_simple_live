import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/sites.dart';
import 'package:simple_live_app/widgets/net_image.dart';
import 'custom_sort_manager_controller.dart';

class CustomSortManagerPage extends GetView<CustomSortManagerController> {
  const CustomSortManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.sortId == null ? "添加自定义排序" : "编辑自定义排序"),
        actions: [
          if (controller.sortId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirm();
              },
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              controller.save();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: "排序名称",
                hintText: "请输入自定义排序的名称",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "长按并拖动主播来调整排序位置。新关注的主播会自动排在最下面。",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ReorderableListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: controller.sortUsers.length,
                onReorder: controller.onReorder,
                itemBuilder: (context, index) {
                  var item = controller.sortUsers[index];
                  var site = Sites.allSites[item.siteId]!;
                  return ListTile(
                    key: ValueKey(item.id),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${index + 1}",
                            style: const TextStyle(color: Colors.grey)),
                        AppStyle.hGap12,
                        NetImage(
                          item.face,
                          width: 40,
                          height: 40,
                          borderRadius: 20,
                        ),
                      ],
                    ),
                    title: Text(item.userName),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(site.logo, width: 14),
                        const SizedBox(width: 4),
                        Text(site.name, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm() {
    Get.dialog(
      AlertDialog(
        title: const Text("删除排序"),
        content: const Text("确定要删除这个自定义排序吗？"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteSort();
            },
            child: const Text("删除", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
