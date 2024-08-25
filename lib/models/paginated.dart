// ignore_for_file: must_be_immutable

import 'package:tugela/models/api_response.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/pagination.dart';

class Paginated<T> extends BaseModel {
  List<T>? data;
  Pagination? pagination;

  Paginated({this.data, this.pagination});

  bool get isEmpty => (data ?? []).isEmpty;

  bool get isNotEmpty => (data ?? []).isNotEmpty;

  int get length => (data ?? []).length;

  void append(ApiResponse<List<T>>? response) {
    if (response == null) return;
    if (data != null) {
      data?.addAll(response.data ?? []);
    } else {
      data = response.data ?? [];
    }
    if (response.pagination != null) pagination = response.pagination;
  }

  bool get canLoadMore {
    return pagination?.next != null;
  }

  void clear() {
    data = null;
    pagination = null;
  }

  @override
  List<Object?> get props => [data, pagination];

  Map<String, dynamic> toJson() {
    return {
      "data": (data ?? []).map((e) => e.toString()).toList(),
      "pagination": pagination?.toJson(),
    };
  }
}

class PaginatedOptions extends BaseModel {
  final bool refresh;
  final bool loadMore;
  final bool keepCount;
  const PaginatedOptions({
    this.keepCount = false,
    this.loadMore = false,
    this.refresh = true,
  });

  @override
  List<Object?> get props => [keepCount, loadMore, refresh];
}
