class FollowUserSort {
  String id;
  String name;
  List<String> userIds; // 存储 id = siteId_roomId

  FollowUserSort({
    required this.id,
    required this.name,
    required this.userIds,
  });

  factory FollowUserSort.fromJson(Map<String, dynamic> json) {
    return FollowUserSort(
      id: json['id'],
      name: json['name'],
      userIds: List<String>.from(json['userIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userIds': userIds,
    };
  }

  FollowUserSort copyWith({
    String? id,
    String? name,
    List<String>? userIds,
  }) {
    return FollowUserSort(
      id: id ?? this.id,
      name: name ?? this.name,
      userIds: userIds ?? this.userIds,
    );
  }
}
