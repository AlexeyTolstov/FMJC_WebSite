import 'package:latlong2/latlong.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  String? _userId;
  LatLng? _userLatLng;

  String? get userId => _userId;
  LatLng? get userLatLng => _userLatLng;

  set userId(String? id) => _userId = id;
  set userLatLng(LatLng? latLng) => _userLatLng = latLng;
}
