class Delivery {
  final String id;
  final String recipient;
  final String address;
  String status;

  Delivery({
    required this.id,
    required this.recipient,
    required this.address,
    required this.status,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'].toString(),
      recipient: json['receiver_Name'] ?? 'Unknown',
      address: json['to_Address'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "receiver_Name": recipient,
      "to_Address": address,
      "status": status,
    };
  }
}
