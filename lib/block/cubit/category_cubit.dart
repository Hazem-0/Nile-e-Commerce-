import 'package:cx_final_project/block/cubit_state/category_states.dart';
import 'package:cx_final_project/info/api_constants.dart';
import 'package:cx_final_project/models/product_model.dart';
import 'package:cx_final_project/services/news_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  CategoryCubit() : super(CategoryInitial());
  Map<String, bool> selectedCategory = {
    'electroincs': false,
    'jewelery': false,
    'men\'s clothing': false,
    'women\'s clothing': false
  };
  // String? selectedCategory;
  Future<void> selecCategory(String category) async {
    emit(ProductsLoading());

    try {
      late List<Product> futureProducts;
      futureProducts = await ProductServices().getProducts(
          path: ApiConstant.baseUrl +
              ApiConstant.productEndpoint +
              "/category/" +
              "${category}");
      // selectedCategory[category]=true;
      // log('got here ');

      emit(
        CategorySelected(
          selectedCtegory: category,
          futureProducts: futureProducts,
        ),
      );
    } catch (e) {
      emit(CategoryNotFound());
    }
  }

  void fetchCategories() async {
    emit(CategoryLoading());
    selectedCategory.updateAll((key, value) => false);

    try {
      late List category;
      category = await ProductServices().getCategories(
          path: ApiConstant.baseUrl + ApiConstant.categoryEndpoint);
      // print("doneeeeeeeeee");
      emit(CategoriesFetched(category: category));
    } catch (e) {
      // print(e);
      emit(CategoryNotFound());
    }
  }
}
