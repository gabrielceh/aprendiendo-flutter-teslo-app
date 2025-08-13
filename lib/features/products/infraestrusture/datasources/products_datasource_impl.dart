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

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;// obtenemos el nombre del archivo + extension
      final FormData data =  FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName), // 'file' nombre del campo que pide el backend
      });
      final response = await dio.post('/files/product', data: data);

      return response.data['image'];

    } catch (e) {
      throw Exception();
    }
  }

  Future <List<String>> _uploadImages(List<String> photos) async {
    final photosToUpload = photos.where((photo)=> photo.contains('/data')).toList();
    final photosToIgnore = photos.where((photo)=> !photo.contains('/data')).toList();

    // crear futures para cada imagen
    final List<Future<String>> uploadJob = photosToUpload.map((e) => _uploadFile(e)).toList();

    // Ejecuta todas las tareas de la lista en paralelo (no espera que una termine antes de iniciar la siguiente).
    // Devuelve un solo Future que se completa cuando todas las tareas terminan.
    // Ese Future final resuelve en una lista con los resultados en el mismo orden que la lista original.
    final newImages = await Future.wait(uploadJob);

    return [...newImages, ...photosToIgnore];
  }


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async{
    try {
      final String? productId = productLike['id'];
      String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/products' : '/products/$productId';
      productLike.remove('id');

      productLike['images'] = await _uploadImages(productLike['images']);

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