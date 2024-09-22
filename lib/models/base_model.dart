import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  const BaseModel();

  @override
  List<Object?> get props => [];
}

String idFromJson(dynamic json) {
  if (json is Map) return json['id'];
  return json.toString();
}
