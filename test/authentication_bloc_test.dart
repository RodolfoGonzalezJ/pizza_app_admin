import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pizza_app_admin/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeMyUser extends Fake implements MyUser {}

void main() {
  late AuthenticationBloc authenticationBloc;
  late MockUserRepository mockUserRepository;
  late StreamController<MyUser?> userStreamController;

  final authenticatedUser = FakeMyUser(); // Simula un usuario autenticado.

  setUpAll(() {
    registerFallbackValue(FakeMyUser());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    userStreamController = StreamController<MyUser?>();
    when(() => mockUserRepository.user)
        .thenAnswer((_) => userStreamController.stream);

    authenticationBloc = AuthenticationBloc(userRepository: mockUserRepository);
  });

  tearDown(() {
    userStreamController.close();
    authenticationBloc.close();
  });

  group('AuthenticationBloc Tests', () {
    test('Initial state is AuthenticationState.unknown()', () {
      expect(authenticationBloc.state, const AuthenticationState.unknown());
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationState.authenticated] when a user is authenticated',
      build: () => authenticationBloc,
      act: (bloc) {
        userStreamController.add(authenticatedUser);
      },
      expect: () => [
        AuthenticationState.authenticated(authenticatedUser),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits [AuthenticationState.unauthenticated] when no user is present',
      build: () => authenticationBloc,
      act: (bloc) {
        userStreamController.add(null);
      },
      expect: () => [
        const AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'does not emit new states when the same user remains authenticated',
      build: () => authenticationBloc,
      seed: () => AuthenticationState.authenticated(authenticatedUser),
      act: (bloc) {
        userStreamController.add(authenticatedUser);
      },
      expect: () => [],
    );

    test('closes userSubscription on bloc close', () async {
      await authenticationBloc.close();
      expect(userStreamController.hasListener, isFalse);
    });
  });
}
