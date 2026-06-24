import 'package:lingo_cross_app/features/notifications/data/device_repository.dart';

/// Test'lerde ağ'a gitmeyen sahte cihaz repository'si.
class FakeDeviceRepository implements DeviceRepository {
  final List<String> registered = [];
  final List<String> unregistered = [];
  bool failRegister = false;
  bool failUnregister = false;

  @override
  Future<void> register({
    required String token,
    String platform = 'ios',
  }) async {
    if (failRegister) throw Exception('register failed');
    registered.add(token);
  }

  @override
  Future<void> unregister(String token) async {
    if (failUnregister) throw Exception('unregister failed');
    unregistered.add(token);
  }
}
