import 'package:fcm_statenotifier/pages/token_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TokenController extends StateNotifier<TokenState> {
  TokenController() : super(const TokenState(token: ''));

  Future<void> getToken () async {
    final messaging = FirebaseMessaging.instance;

    try {
      final gotToken = await messaging.getToken();
      state = state.copyWith(token: gotToken);
    } catch (e) {
      print(e);
    }
  }

}