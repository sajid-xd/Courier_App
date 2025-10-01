class Delivery {
  int? id;
  String? fromAddress;
  String? toAddress;
  String? senderName;
  String? receiverName;
  int? senderId;
  int? agentId;
  int? serviceId;
  int? weightId;
  int? locationId;
  String? trackingId;
  String? status;
  String? createdAt;

  Delivery(
      {
        this.id,
        this.fromAddress,
        this.toAddress,
        this.senderName,
        this.receiverName,
        this.senderId,
        this.agentId,
        this.serviceId,
        this.weightId,
        this.locationId,
        this.trackingId,
        this.status,
      this.createdAt});

  Delivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromAddress = json['from_Address'];
    toAddress = json['to_Address'];
    senderName = json['sender_Name'];
    receiverName = json['receiver_Name'];
    senderId = json['sender_Id'];
    agentId = json['agent_Id'];
    serviceId = json['service_Id'];
    weightId = json['weight_Id'];
    locationId = json['location_Id'];
    trackingId = json['tracking_Id'];
    status = json['status'];
    createdAt = json['created_At'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id']  = id;
    data['from_Address'] = fromAddress;
    data['to_Address'] = toAddress;
    data['sender_Name'] = senderName;
    data['receiver_Name'] = receiverName;
    data['sender_Id'] = senderId;
    data['agent_Id'] = agentId;
    data['service_Id'] = serviceId;
    data['weight_Id'] = weightId;
    data['location_Id'] = locationId;
    data['tracking_Id'] = trackingId;
    data['status'] = status;
    data['created_At'] = createdAt;
    return data;
  }
}