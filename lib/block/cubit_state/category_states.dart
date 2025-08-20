import 'package:cx_final_project/models/product_model.dart';

abstract class CategoryStates {}

class CategoryInitial extends CategoryStates {}

class CategorySelected extends CategoryStates {
  final String selectedCtegory;
  final List<Product> futureProducts;

  CategorySelected(
      {required this.futureProducts, required this.selectedCtegory});
}

class CategoryNotFound extends CategoryStates {}

class CategoryLoading extends CategoryStates {}

class CategoriesFetched extends CategoryStates {
  final List category;

  CategoriesFetched({required this.category});
}

class ProductsLoading extends CategoryStates {}
