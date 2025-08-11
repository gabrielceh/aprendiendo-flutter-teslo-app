import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_app/features/products/domain/domain.dart';
import 'package:teslo_app/features/products/infraestrusture/infraestructure.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref){
  // llamamos al provider que contiene el token
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productsRep = ProductsRepositoryImpl( ProductsDataSourceImpl(accessToken: accessToken) );

  return productsRep;
});