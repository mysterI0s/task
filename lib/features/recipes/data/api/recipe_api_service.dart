import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../domain/entities/recipe.dart';

part 'recipe_api_service.g.dart';

@RestApi()
abstract class RecipeApiService {
  factory RecipeApiService(Dio dio) = _RecipeApiService;

  @GET('/recipes')
  Future<RecipesResponse> getRecipes({
    @Query('limit') int limit = 20,
    @Query('skip') int skip = 0,
  });

  @GET('/recipes/{id}')
  Future<Recipe> getRecipe(@Path('id') int id);

  @GET('/recipes/search')
  Future<RecipesResponse> searchRecipes({
    @Query('q') required String query,
    @Query('limit') int limit = 20,
    @Query('skip') int skip = 0,
  });

  @GET('/recipes/tags')
  Future<List<String>> getRecipeTags();
}
