import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_app/features/products/domain/domain.dart';
import 'products_repository_provider.dart';

// con el .family se espera un valor a la hora de utilizar el provider
// como esperamos un productID, ese valor se coloca en el provider y en este caso como String
// ! 3 - StateNotifierProvider
final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
    productsRepository: productsRepository, 
    productId: productId
  );
}
);


// ! 1 - state

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  const ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ProductState(
      id : id ?? this.id,
      product : product ?? this.product,
      isLoading : isLoading ?? this.isLoading,
      isSaving : isSaving ?? this.isSaving, 
    );
  }
}

// ! 2 - notifier

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;


  ProductNotifier({
    required this.productsRepository,
    required String productId,
  }) : super(ProductState(id: productId)){
    loadProduct();
  }

  Product _newEmptyProduct(){
    return Product(
      id: 'new',
      title: '',
      slug: '',
      price: 0.0,
      stock: 0,
      sizes: const [],
      gender: 'men',
      description: '',
      tags: [],
      images: const [],
    );
  }

  Future<void> loadProduct() async {
    try {
      if(state.id == 'new') {
        state = state.copyWith(
          product: _newEmptyProduct(),
          isLoading: false,
        );

        return ;
      }

      final product = await productsRepository.getProductByID(state.id);

      state = state.copyWith(
        product: product,
        isLoading: false,
      );

    } catch (e) {
      print('Error: $e');
    }
  }
}