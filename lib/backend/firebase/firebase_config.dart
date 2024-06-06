import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyD3g_UKD_3PI3WY4XdJENKmnqkGuWibpus",
            authDomain: "cupcake-shop-oiy2u1.firebaseapp.com",
            projectId: "cupcake-shop-oiy2u1",
            storageBucket: "cupcake-shop-oiy2u1.appspot.com",
            messagingSenderId: "1076968160065",
            appId: "1:1076968160065:web:886f485d527434a8203fc0"));
  } else {
    await Firebase.initializeApp();
  }
}
