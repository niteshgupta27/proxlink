import '../../membersList/model/NetworkModel.dart';

class NetworkListResponse {
  final String? status;
  final String? viewAs;
  final int? total;
  final List<NetworkModel>? networks;

  NetworkListResponse({
    this.status,
    this.viewAs,
    this.total,
    this.networks,
  });

  factory NetworkListResponse.fromJson(Map<String, dynamic> json) {
    return NetworkListResponse(
      status: json['status'],
      viewAs: json['view_as'],
      total: json['total'],
      networks: json['networks'] != null
          ? List<NetworkModel>.from(
        json['networks'].map((x) => NetworkModel.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'view_as': viewAs,
      'total': total,
      'networks': networks?.map((x) => x.toJson()).toList(),
    };
  }
}
