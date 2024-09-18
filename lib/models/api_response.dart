// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models.dart';
import 'package:tugela/models/pagination.dart';

part 'api_response.g.dart';

typedef ObjectCreator<S> = S? Function(Map<String, dynamic> json);
typedef ListCreator<S> = S? Function(List<dynamic> json);

class ApiResponse<T> extends Equatable {
  T? data;
  String? name;
  Pagination? pagination;
  ApiError? error;

  ApiResponse({
    this.data,
    this.name,
    this.error,
  });

  ApiResponse.fromJson(dynamic json, ObjectCreator<T> creator) {
    error = json['error'] != null ? ApiError.fromJson(json['error']) : null;
    data = json['data'] != null ? creator(json['data']) : null;
    if (kDebugMode &&
        error != null &&
        (error?.statusCode != 200 && error?.statusCode != 401)) {
      log("${error?.toJson()}");
    }
  }

  String? _extractQuery<Q>(String? url, String key) {
    if (url == null) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasQuery) return null;
    return uri.queryParameters[key];
  }

  ApiResponse.fromJsonList(
    dynamic json,
    ListCreator<T> creator, {
    bool paginated = true,
  }) {
    error = json['error'] != null ? ApiError.fromJson(json['error']) : null;
    final jsonData = json['data'];
    if (jsonData != null) {
      if (paginated) {
        final results = jsonData['results'];
        data = results != null ? creator(results) : null;
        pagination = Pagination(
          count: jsonData['count'],
          previous:
              int.tryParse(_extractQuery(jsonData['previous'], 'page') ?? ""),
          next: int.tryParse(_extractQuery(jsonData['next'], 'page') ?? ""),
        );
      } else {
        data = jsonData != null ? creator(jsonData) : null;
      }
    }
    if (kDebugMode &&
        error != null &&
        (error?.statusCode != 200 && error?.statusCode != 401)) {
      log("${error?.toJson()}");
    }
  }

  ApiResponse.value(dynamic json, {String? key}) {
    error = json['error'] != null ? ApiError.fromJson(json['error']) : null;
    data = key == null ? json['data'] : json['data']?[key];
    if (kDebugMode &&
        error != null &&
        (error?.statusCode != 200 && error?.statusCode != 401)) {
      log("${error?.toJson()}");
    }
  }

  ApiResponse.successful(Response response) {
    final json = response.data;
    if (json is Map) {
      error = json['error'] != null ? ApiError.fromJson(json['error']) : null;
    }
    data = ((response.statusCode ?? 0) >= 200 &&
        (response.statusCode ?? 0) < 400) as T?;
  }

  @override
  List<Object?> get props => [
        data,
        name,
        pagination,
      ];
}

@JsonSerializable()
class ApiError extends Equatable {
  int? statusCode;
  String? message;
  @JsonKey(fromJson: _errorFromJson)
  Map<String, dynamic>? details;

  ApiError({this.details, this.message, this.statusCode});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  String? forKey(String key) {
    return (details?[key] as List?)?.join('\n');
  }

  @override
  List<Object?> get props => [statusCode, message, details];
}

Map<String, dynamic>? _errorFromJson(dynamic v) {
  if (v is List) return v.asMap().map((k, v) => MapEntry(k.toString(), v));
  return v;
}
