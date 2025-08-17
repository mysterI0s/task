import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required String description,
    required String category,
    required double price,
    double? discountPercentage,
    double? rating,
    int? stock,
    List<String>? tags,
    String? brand,
    String? sku,
    double? weight,
    ProductDimensions? dimensions,
    String? warrantyInformation,
    String? shippingInformation,
    String? availabilityStatus,
    List<ProductReview>? reviews,
    String? returnPolicy,
    int? minimumOrderQuantity,
    ProductMeta? meta,
    List<String>? images,
    String? thumbnail,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class ProductDimensions with _$ProductDimensions {
  const factory ProductDimensions({
    required double width,
    required double height,
    required double depth,
  }) = _ProductDimensions;

  factory ProductDimensions.fromJson(Map<String, dynamic> json) =>
      _$ProductDimensionsFromJson(json);
}

@freezed
class ProductReview with _$ProductReview {
  const factory ProductReview({
    required int rating,
    required String comment,
    required DateTime date,
    required String reviewerName,
    required String reviewerEmail,
  }) = _ProductReview;

  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);
}

@freezed
class ProductMeta with _$ProductMeta {
  const factory ProductMeta({
    required DateTime createdAt,
    required DateTime updatedAt,
    required String barcode,
    required String qrCode,
  }) = _ProductMeta;

  factory ProductMeta.fromJson(Map<String, dynamic> json) =>
      _$ProductMetaFromJson(json);
}

@freezed
class ProductsResponse with _$ProductsResponse {
  const factory ProductsResponse({
    required List<Product> products,
    int? total,
    int? skip,
    int? limit,
  }) = _ProductsResponse;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);
}
