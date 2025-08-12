import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/products/domain/domain.dart';

import 'products_repository_provider.dart';

// ! 3 - crear el StateNotifierProvider
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: productsRepository);
});

// ! 1 - crear el State

class ProductsState{
  final bool isLoading;
  final bool isLastPage;
  final int limit;
  final int offset;
  final List<Product> products;

  ProductsState({
    this.isLoading = false,
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLoading,
    bool? isLastPage,
    int? limit,
    int? offset,
    List<Product>? products,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading, 
      isLastPage: isLastPage ?? this.isLastPage, 
      limit: limit ?? this.limit, 
      offset: offset ?? this.offset, 
      products: products ?? this.products, 
    );
  }
}

// ! 2 - crear el Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({
    required  this.productsRepository
  }):super(ProductsState()){
    loadNextPage();
  }

    Future<bool> createrOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateProduct(productLike);
      final isProductInList = state.products.any((prod)=> prod.id == product.id);
      if(!isProductInList){
        state = state.copyWith(
          products: [product, ...state.products],
        );
        return true;
      }
      state = state.copyWith(
        products: state.products.map((el)=> el.id == product.id ? product : el).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<void> loadNextPage() async {
    if(state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);
    final products = await productsRepository.getProductsByPage(limit: state.limit,offset: state.offset);

    if(products.isEmpty){
      state = state.copyWith(
        isLoading: false,
        isLastPage: true
      );
      return;
    }


    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );

  }

}