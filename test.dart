import 'package:flutter_test/flutter_test.dart';
import 'package:community_energy_optimizer/providers/auth_provider.dart';
import 'package:community_energy_optimizer/providers/energy_provider.dart';
import 'package:community_energy_optimizer/services/auth_service.dart';
import 'package:community_energy_optimizer/models/user_model.dart';

void main() {
  group('AuthProvider', () {
    final AuthService mockAuthService = AuthService();
    final AuthProvider authProvider = AuthProvider();

    test('Initial user should be null', () {
      expect(authProvider.user, null);
    });

    test('Login updates the user', () async {
      UserModel mockUser = UserModel(uid: '123', name: 'Test User', email: 'test@example.com', avatarUrl: '');
      await authProvider.login('test@example.com', 'password123');
      expect(authProvider.user?.uid, mockUser.uid);
    });
  });

  group('EnergyProvider', () {
    final EnergyProvider energyProvider = EnergyProvider();

    test('Initial usage data should be empty', () {
      expect(energyProvider.usageData, []);
    });

    test('Fetch usage data updates the list', () async {
      await energyProvider.fetchUsageData('userId');
      expect(energyProvider.usageData.isNotEmpty, true);
    });
  });
}
