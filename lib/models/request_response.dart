class RequestResponse {
  String? responseId;
  String? requestId;
  String? donorId;
  String? donorName;
  String? patientName;
  String? bloodGroup;
  String? recipientId;
  DateTime? responseDate;
  String? responseMessage;

  bool? responseStatus;

  RequestResponse({
    this.responseId,
    this.requestId,
    this.donorId,
    this.donorName,
    this.patientName,
    this.bloodGroup,
    this.recipientId,
    this.responseDate,
    this.responseMessage,
    this.responseStatus,
  });

  factory RequestResponse.fromMap(Map<String, dynamic> data) {
    return RequestResponse(
      responseId: data['responseId'],
      requestId: data['requestId'],
      donorId: data['donorId'],
      donorName: data['donorName'],
      patientName: data['patientName'],
      bloodGroup: data['bloodGroup'],
      recipientId: data['recipientId'],
      responseDate: data['responseDate'],
      responseMessage: data['responseMessage'],
      responseStatus: data['responseStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseId'] = responseId;
    data['requestId'] = requestId;
    data['donorId'] = donorId;
    data['donorName'] = donorName;
    data['patientName'] = patientName;
    data['bloodGroup'] = bloodGroup;
    data['recipientId'] = recipientId;
    data['responseDate'] = responseDate;
    data['responseMessage'] = responseMessage;
    data['responseStatus'] = responseStatus;
    return data;
  }
}
