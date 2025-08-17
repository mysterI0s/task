// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      dimensions: json['dimensions'] == null
          ? null
          : ProductDimensions.fromJson(
              json['dimensions'] as Map<String, dynamic>),
      warrantyInformation: json['warrantyInformation'] as String?,
      shippingInformation: json['shippingInformation'] as String?,
      availabilityStatus: json['availabilityStatus'] as String?,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ProductReview.fromJson(e as Map<String, dynamic>))
          .toList(),
      returnPolicy: json['returnPolicy'] as String?,
      minimumOrderQuantity: (json['minimumOrderQuantity'] as num?)?.toInt(),
      meta: json['meta'] == null
          ? null
          : ProductMeta.fromJson(json['meta'] as Map<String, dynamic>),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      thumbnail: json['thumbnail'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      if (instance.discountPercentage case final value?)
        'discountPercentage': value,
      if (instance.rating case final value?) 'rating': value,
      if (instance.stock case final value?) 'stock': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.brand case final value?) 'brand': value,
      if (instance.sku case final value?) 'sku': value,
      if (instance.weight case final value?) 'weight': value,
      if (instance.dimensions?.toJson() case final value?) 'dimensions': value,
      if (instance.warrantyInformation case final value?)
        'warrantyInformation': value,
      if (instance.shippingInformation case final value?)
        'shippingInformation': value,
      if (instance.availabilityStatus case final value?)
        'availabilityStatus': value,
      if (instance.reviews?.map((e) => e.toJson()).toList() case final value?)
        'reviews': value,
      if (instance.returnPolicy case final value?) 'returnPolicy': value,
      if (instance.minimumOrderQuantity case final value?)
        'minimumOrderQuantity': value,
      if (instance.meta?.toJson() case final value?) 'meta': value,
      if (instance.images case final value?) 'images': value,
      if (instance.thumbnail case final value?) 'thumbnail': value,
    };

_$ProductDimensionsImpl _$$ProductDimensionsImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductDimensionsImpl(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductDimensionsImplToJson(
        _$ProductDimensionsImpl instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'depth': instance.depth,
    };

_$ProductReviewImpl _$$ProductReviewImplFromJson(Map<String, dynamic> json) =>
    _$ProductReviewImpl(
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      reviewerName: json['reviewerName'] as String,
      reviewerEmail: json['reviewerEmail'] as String,
    );

Map<String, dynamic> _$$ProductReviewImplToJson(_$ProductReviewImpl instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'comment': instance.comment,
      'date': instance.date.toIso8601String(),
      'reviewerName': instance.reviewerName,
      'reviewerEmail': instance.reviewerEmail,
    };

_$ProductMetaImpl _$$ProductMetaImplFromJson(Map<String, dynamic> json) =>
    _$ProductMetaImpl(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      barcode: json['barcode'] as String,
      qrCode: json['qrCode'] as String,
    );

Map<String, dynamic> _$$ProductMetaImplToJson(_$ProductMetaImpl instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'barcode': instance.barcode,
      'qrCode': instance.qrCode,
    };

_$ProductsResponseImpl _$$ProductsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductsResponseImpl(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      skip: (json['skip'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProductsResponseImplToJson(
        _$ProductsResponseImpl instance) =>
    <String, dynamic>{
      'products': instance.products.map((e) => e.toJson()).toList(),
      if (instance.total case final value?) 'total': value,
      if (instance.skip case final value?) 'skip': value,
      if (instance.limit case final value?) 'limit': value,
    };
