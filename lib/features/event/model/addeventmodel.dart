class AddeventModelResponse {
  final String status;
  final int network_id;

  AddeventModelResponse({
    required this.status,
    required this.network_id,

  });

  factory AddeventModelResponse.fromJson(Map<String, dynamic> json) {
    return AddeventModelResponse(
      status: json['status'] ?? '',
      network_id: json['network_id'] ?? 0,

    );
  }
}

