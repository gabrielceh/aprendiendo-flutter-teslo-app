import 'package:teslo_app/features/products/domain/domain.dart';

abstract class ProductsDataSource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductByID(String id);

  Future<List<Product>> searchProductsByTerm(String term);

  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);

}