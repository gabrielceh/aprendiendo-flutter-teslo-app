import 'package:teslo_app/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDataSource dataSource;

  ProductsRepositoryImpl(this.dataSource);
  
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return dataSource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductByID(String id) {
    return dataSource.getProductByID(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return dataSource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    return dataSource.searchProductsByTerm(term);
  }

}