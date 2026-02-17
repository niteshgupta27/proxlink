class NetworkModel {
  final int? networkId;
  final String? name;
  final String? description;
  final int? ownerUserId;
  final String? ownerName;
  final int? totalMembers;
  final int? isJoined;
  final int? canEdit;
  final int? canDelete;

  NetworkModel({
    this.networkId,
    this.name,
    this.description,
    this.ownerUserId,
    this.ownerName,
    this.totalMembers,
    this.isJoined,
    this.canEdit,
    this.canDelete,
  });

  factory NetworkModel.fromJson(Map<String, dynamic> json) {
    return NetworkModel(
      networkId: json['network_id'],
      name: json['name'],
      description: json['description'],
      ownerUserId: json['owner_user_id'],
      ownerName: json['owner_name'],
      totalMembers: json['total_members'],
      isJoined: json['is_joined'],
      canEdit: json['can_edit'],
      canDelete: json['can_delete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'network_id': networkId,
      'name': name,
      'description': description,
      'owner_user_id': ownerUserId,
      'owner_name': ownerName,
      'total_members': totalMembers,
      'is_joined': isJoined,
      'can_edit': canEdit,
      'can_delete': canDelete,
    };
  }
}
