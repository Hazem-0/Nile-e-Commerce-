import 'package:cx_final_project/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

final options = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.refresh,
  hitCacheOnErrorExcept: [401, 403],
  maxStale: const Duration(days: 28),
  priority: CachePriority.high,
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  allowPostMethod: false,
);

class ProductServices {
  Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

  Future<List<Product>> getProducts({required String path}) async {
    Response respond = await dio.get(path);
    try {
      List<Product> products =
          (respond.data as List).map((item) => Product.fromJson(item)).toList();
      // print("done ...${products}");
      // print("here............ ${respond.data}");
      return products;
    } catch (e) {
      print(respond);
      throw Exception('Failed to fetch products');
    }
  }

  Future<List> getCategories({required String path}) async {
    Response respond = await dio.get(path);
    try {
      List categories = respond.data;

      // print("done ...${categories}");
      // print("here............ ${respond.data}");
      return categories;
    } catch (e) {
      print(respond);
      throw Exception('Failed to fetch products');
    }
  }
}
