import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<Either<Failure, RecipesResponse>> getRecipes({
    int limit = 20,
    int skip = 0,
    String? search,
  });

  Future<Either<Failure, Recipe>> getRecipe(int id);

  Future<Either<Failure, RecipesResponse>> searchRecipes({
    required String query,
    int limit = 20,
    int skip = 0,
  });

  Future<Either<Failure, List<String>>> getRecipeTags();
}
