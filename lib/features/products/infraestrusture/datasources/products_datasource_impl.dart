import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/infraestrusture/mappers/product_mapper.dart';

import '../models/product_response.dart';

class ProductsDataSourceImpl extends ProductsDataSource {

  late final Dio dio;
  final String accessToken; 

  ProductsDataSourceImpl({
    required this.accessToken,
  }): dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    ),
  );

  Product _fromJsonToProduct(Map<String, dynamic> json) {
    final productResponse = ProductResponse.fromJson(json);
    return ProductMapper.jsonToEntity(productResponse);
  }


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async{
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductByID(String id)async {
    // TODO: implement getProductByID
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async{
    final response = await dio.get<List>('/products?limit=$limit&offset=$offset');

    final List<Product> products = [];
    for(final product in response.data ?? []){
      products.add( _fromJsonToProduct(product) );
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term)async {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }

}