import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../domain/entities/product.dart';

part 'product_api_service.g.dart';

@RestApi()
abstract class ProductApiService {
  factory ProductApiService(Dio dio) = _ProductApiService;

  @GET('/products')
  Future<ProductsResponse> getProducts({
    @Query('limit') int limit = 20,
    @Query('skip') int skip = 0,
    @Query('select') String? select,
    @Query('sortBy') String? sortBy,
    @Query('order') String? order,
  });

  @GET('/products/{id}')
  Future<Product> getProduct(@Path('id') int id);

  @GET('/products/categories')
  Future<List<String>> getCategories();

  @GET('/products/search')
  Future<ProductsResponse> searchProducts({
    @Query('q') required String query,
    @Query('limit') int limit = 20,
    @Query('skip') int skip = 0,
  });

  @GET('/products/category/{category}')
  Future<ProductsResponse> getProductsByCategory({
    @Path('category') required String category,
    @Query('limit') int limit = 20,
    @Query('skip') int skip = 0,
  });
}
