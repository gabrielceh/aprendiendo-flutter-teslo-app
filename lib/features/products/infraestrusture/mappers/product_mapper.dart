import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/auth/infraestructure/infraestructure.dart';
import 'package:teslo_app/features/products/infraestrusture/models/product_response.dart';

import '../../domain/domain.dart';

class ProductMapper {


  static jsonToEntity( ProductResponse json ) => Product(
    id: json.id, 
    title: json.title, 
    price: double.parse( json.price.toString() ), 
    description: json.description, 
    slug: json.slug, 
    stock: json.stock, 
    sizes: List<String>.from( json.sizes.map( (String size) => size )  ), 
    gender: json.gender, 
    tags: List<String>.from( json.tags.map( (String tag) => tag )  ),
    images: List<String>.from(
      json.images.map( 
        (image) => image.startsWith('http')
          ? image
          : '${ Environment.apiUrl }/files/product/$image',
      )
    ), 
    user: json.user != null ? UserMapper.userJsonToEntity( json.user! ) : null,
  );


}