// esta se encargará de notificar al router cuando haya cambios en el estado de auth

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';

final goRouterNotifierProvider = Provider((ref){
  final authNotifier = ref.read(authProvider.notifier);

  return GoRouterNotifier(authNotifier);
});


class GoRouterNotifier extends ChangeNotifier{

  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authNotifier){
    _authNotifier.addListener((state){
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    // notificamos al router que haya cambios en el estado de auth
    notifyListeners();
  }

}