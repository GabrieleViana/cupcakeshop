import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _favorite = (await secureStorage.getStringList('ff_favorite'))
              ?.map((path) => path.ref)
              .toList() ??
          _favorite;
    });
    await _safeInitAsync(() async {
      _cart = (await secureStorage.getStringList('ff_cart'))
              ?.map((path) => path.ref)
              .toList() ??
          _cart;
    });
    await _safeInitAsync(() async {
      _cartsum = await secureStorage.getDouble('ff_cartsum') ?? _cartsum;
    });
    await _safeInitAsync(() async {
      _isLiked = await secureStorage.getBool('ff_isLiked') ?? _isLiked;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  List<DocumentReference> _favorite = [];
  List<DocumentReference> get favorite => _favorite;
  set favorite(List<DocumentReference> _value) {
    _favorite = _value;
    secureStorage.setStringList(
        'ff_favorite', _value.map((x) => x.path).toList());
  }

  void deleteFavorite() {
    secureStorage.delete(key: 'ff_favorite');
  }

  void addToFavorite(DocumentReference _value) {
    _favorite.add(_value);
    secureStorage.setStringList(
        'ff_favorite', _favorite.map((x) => x.path).toList());
  }

  void removeFromFavorite(DocumentReference _value) {
    _favorite.remove(_value);
    secureStorage.setStringList(
        'ff_favorite', _favorite.map((x) => x.path).toList());
  }

  void removeAtIndexFromFavorite(int _index) {
    _favorite.removeAt(_index);
    secureStorage.setStringList(
        'ff_favorite', _favorite.map((x) => x.path).toList());
  }

  void updateFavoriteAtIndex(
    int _index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    _favorite[_index] = updateFn(_favorite[_index]);
    secureStorage.setStringList(
        'ff_favorite', _favorite.map((x) => x.path).toList());
  }

  void insertAtIndexInFavorite(int _index, DocumentReference _value) {
    _favorite.insert(_index, _value);
    secureStorage.setStringList(
        'ff_favorite', _favorite.map((x) => x.path).toList());
  }

  List<DocumentReference> _cart = [];
  List<DocumentReference> get cart => _cart;
  set cart(List<DocumentReference> _value) {
    _cart = _value;
    secureStorage.setStringList('ff_cart', _value.map((x) => x.path).toList());
  }

  void deleteCart() {
    secureStorage.delete(key: 'ff_cart');
  }

  void addToCart(DocumentReference _value) {
    _cart.add(_value);
    secureStorage.setStringList('ff_cart', _cart.map((x) => x.path).toList());
  }

  void removeFromCart(DocumentReference _value) {
    _cart.remove(_value);
    secureStorage.setStringList('ff_cart', _cart.map((x) => x.path).toList());
  }

  void removeAtIndexFromCart(int _index) {
    _cart.removeAt(_index);
    secureStorage.setStringList('ff_cart', _cart.map((x) => x.path).toList());
  }

  void updateCartAtIndex(
    int _index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    _cart[_index] = updateFn(_cart[_index]);
    secureStorage.setStringList('ff_cart', _cart.map((x) => x.path).toList());
  }

  void insertAtIndexInCart(int _index, DocumentReference _value) {
    _cart.insert(_index, _value);
    secureStorage.setStringList('ff_cart', _cart.map((x) => x.path).toList());
  }

  double _cartsum = 0.0;
  double get cartsum => _cartsum;
  set cartsum(double _value) {
    _cartsum = _value;
    secureStorage.setDouble('ff_cartsum', _value);
  }

  void deleteCartsum() {
    secureStorage.delete(key: 'ff_cartsum');
  }

  int _size = 0;
  int get size => _size;
  set size(int _value) {
    _size = _value;
  }

  bool _isLiked = false;
  bool get isLiked => _isLiked;
  set isLiked(bool _value) {
    _isLiked = _value;
    secureStorage.setBool('ff_isLiked', _value);
  }

  void deleteIsLiked() {
    secureStorage.delete(key: 'ff_isLiked');
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
