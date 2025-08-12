import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/infraestrusture/mappers/product_mapper.dart';

import '../errors/product_errors.dart';
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
        'ngrok-skip-browser-warning': 'true', // solo para develop y usar ngrok para el cel

      },
    ),
  );

  Product _fromJsonToProduct(Map<String, dynamic> json) {
    final productResponse = ProductResponse.fromJson(json);
    return ProductMapper.jsonToEntity(productResponse);
  }


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async{
    try {
      final String? productId = productLike['id'];
      String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/products' : '/products/$productId';
      productLike.remove('id');

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(
          method: method,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final product = _fromJsonToProduct(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductByID(String id)async {
    try {
      final response = await dio.get('/products/$id');
      return _fromJsonToProduct(response.data);
      
    }on DioException catch (e) {
      if(e.response?.statusCode == 404) throw ProductNotFoundError();
      throw Exception();
    }
     catch (e) {
      throw Exception();
    }
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