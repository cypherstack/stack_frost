import 'package:stackfrost/dto/ordinals/inscription_data.dart';
import 'package:stackfrost/dto/ordinals/litescribe_responseart';

class AddressInscriptionResponse
    extends LitescribeResponse<AddressInscriptionResponse> {
  final int status;
  final String message;
  final AddressInscriptionResult result;

  AddressInscriptionResponse({
    required this.status,
    required this.message,
    required this.result,
  });

  factory AddressInscriptionResponse.fromJson(Map<String, dynamic> json) {
    return AddressInscriptionResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      result: AddressInscriptionResult.fromJson(
          json['result'] as Map<String, dynamic>),
    );
  }
}

class AddressInscriptionResult {
  final List<InscriptionData> list;
  final int total;

  AddressInscriptionResult({
    required this.list,
    required this.total,
  });

  factory AddressInscriptionResult.fromJson(Map<String, dynamic> json) {
    return AddressInscriptionResult(
      list: (json['list'] as List)
          .map((item) => InscriptionData.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }
}
