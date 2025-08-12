import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/presentation/providers/providers.dart';
import 'package:teslo_app/features/shared/shared.dart';
import 'package:teslo_app/features/products/domain/domain.dart';

import '../products_repository_provider.dart';


// ! 3 - StateNotifierProvider
final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  
  // final createUpdateProductCallback = ref.watch(productsRepositoryProvider).createUpdateProduct;
  final createUpdateProductCallback = ref.watch(productsProvider.notifier).createrOrUpdateProduct;

  return ProductFormNotifier(
    product: product,
    onSubmitCallback: createUpdateProductCallback,
  );
});


// ! 1 - State

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  const ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.pure(),
    this.slug = const Slug.pure(),
    this.price = const Price.pure(),
    this.sizes = const [],
    this.gender = '',
    this.inStock = const Stock.pure(),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }){
    return ProductFormState(
      isFormValid : isFormValid ?? this.isFormValid,
      id : id ?? this.id,
      title : title ?? this.title,
      slug : slug ?? this.slug,
      price : price ?? this.price,
      sizes : sizes ?? this.sizes,
      gender : gender ?? this.gender,
      inStock : inStock ?? this.inStock,
      description : description ?? this.description,
      tags : tags ?? this.tags,
      images : images ?? this.images,
    );
  }
}


// ! 2 - StateNotifier
class ProductFormNotifier extends StateNotifier<ProductFormState> {

  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }):super(
    // le asginamos los valores iniciales del producto al formulario
    ProductFormState(
      id: product.id,
      title: Title.dirty(value:product.title),
      slug: Slug.dirty(value:product.slug),
      price: Price.dirty(value:product.price),
      inStock: Stock.dirty(value:product.stock),
      sizes: product.sizes,
      gender: product.gender,
      description: product.description,
      tags: product.tags.join(','),
      images: product.images,
    )
  );

  Future<bool> onFormSubmit() async {
    _tochedEveryField();
    if(!state.isFormValid) return false;

    if(onSubmitCallback == null) return false;

    final productLike = {
      'id': (state.id == 'new') ? null : state.id,  
      'title': state.title.value,
      'slug': state.slug.value,
      'price': state.price.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'description': state.description,
      'tags': state.tags.split(','),
      'images': state.images.map(
        (image) => image.replaceAll('${Environment.apiUrl}/files/product/', '')
      ).toList(),
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
      
    }
  }

  void _tochedEveryField(){
    state = state.copyWith(
      isFormValid: Formz.validate([
        state.title, 
        state.slug, 
        state.price, 
        state.inStock, 
      ]),
    );
  }

  void onTitleChanged(String value) {
    final newTitle = Title.dirty(value: value);
    state = state.copyWith(
      title: newTitle,
      // solo los campos que tienen validacion con Formz
      isFormValid: Formz.validate([
        newTitle, 
        state.slug, 
        state.price, 
        state.inStock, 
      ]),
    );
  }
 
  void onSlugChanged(String value) {
    final newSlug = Slug.dirty(value: value);
    state = state.copyWith(
      slug: newSlug,
      // solo los campos que tienen validacion con Formz
      isFormValid: Formz.validate([
        state.title, 
        newSlug, 
        state.price, 
        state.inStock, 
      ]),
    );
  }
  
  void onPriceChanged(double value) {
    final newPrice = Price.dirty(value: value);
    state = state.copyWith(
      price: newPrice,
      // solo los campos que tienen validacion con Formz
      isFormValid: Formz.validate([
        state.title, 
        state.slug, 
        newPrice, 
        state.inStock, 
      ]),
    );
  }
  
  void onStockChanged(int value) {
    final newStock = Stock.dirty(value: value);
    state = state.copyWith(
      inStock: newStock,
      // solo los campos que tienen validacion con Formz
      isFormValid: Formz.validate([
        state.title, 
        state.slug, 
        state.price, 
        newStock, 
      ]),
    );
  }
  
  void onSizesChanged(List<String> sizes) {
    state = state.copyWith(
      sizes: sizes,
    );
  }
  
  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender,
    );
  }
  
  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description,
    );
  }
  
  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags,
    );
  }



}