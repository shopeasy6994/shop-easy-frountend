class PaginatedResponse<T> {
  final int total;
  final int page;
  final int limit;
  final bool hasNextPage;
  final List<T> data;

  PaginatedResponse({
    required this.total,
    required this.page,
    required this.limit,
    required this.hasNextPage,
    required this.data,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PaginatedResponse<T>(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    );
  }
}
