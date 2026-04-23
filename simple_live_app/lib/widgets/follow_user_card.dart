import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/sites.dart';
import 'package:simple_live_app/app/controller/app_settings_controller.dart';
import 'package:simple_live_app/app/utils.dart';
import 'package:simple_live_app/models/db/follow_user.dart';
import 'package:simple_live_app/routes/app_navigation.dart';
import 'package:simple_live_app/widgets/net_image.dart';
import 'package:simple_live_app/widgets/shadow_card.dart';

class FollowUserCard extends StatelessWidget {
  final FollowUser item;
  final Function()? onTap;
  final Function()? onLongPress;

  const FollowUserCard({
    required this.item,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var site = Sites.allSites[item.siteId]!;
    bool isLiving = item.liveStatus.value == 2;
    String coverUrl =
        (isLiving && item.liveCover != null && item.liveCover!.isNotEmpty)
            ? item.liveCover!
            : item.face; // 如果没开播或者没有封面，则使用头像作为封面背景
    String title =
        (isLiving && item.liveTitle != null) ? item.liveTitle! : "暂未开播";
    int titleColorValue = AppSettingsController.instance.liveTitleColor.value;
    Color titleColor = titleColorValue == 0
        ? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black
        : Color(titleColorValue);

    return ShadowCard(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: ColorFiltered(
                  colorFilter: isLiving
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.multiply)
                      : const ColorFilter.mode(
                          Colors.grey, BlendMode.saturation),
                  child: NetImage(
                    coverUrl,
                    fit: BoxFit.cover,
                    height: 110,
                    width: double.infinity,
                  ),
                ),
              ),
              // 平台Logo
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(
                    site.logo,
                    width: 14,
                    height: 14,
                  ),
                ),
              ),
              // 左下角悬浮头像
              Positioned(
                left: 8,
                bottom: -16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).cardColor,
                      width: 2,
                    ),
                  ),
                  child: NetImage(
                    item.face,
                    width: 32,
                    height: 32,
                    borderRadius: 16,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 20, // 利用悬浮头像旁边的空间
            padding: const EdgeInsets.only(
                left: 46, right: 8, top: 4), // 留出左侧悬浮头像的位置
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11, // 改小标题文字，不加粗
                color: titleColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500, // 恢复原来主播名称的粗细
                    ),
                  ),
                ),
                if (isLiving)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0)
                .copyWith(bottom: 8.0, top: 4.0),
            child: Row(
              children: [
                if (isLiving) ...[
                  const Text(
                    "直播中",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  if (item.liveOnline != null && item.liveOnline! > 0) ...[
                    const Icon(
                      Remix.fire_fill,
                      color: Colors.grey,
                      size: 12,
                    ),
                    AppStyle.hGap4,
                    Text(
                      Utils.onlineToString(item.liveOnline!),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ] else
                  const Text(
                    "未开播",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
