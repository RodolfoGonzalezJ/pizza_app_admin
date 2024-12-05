import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pizza_app_admin/src/modules/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late SignInBloc signInBloc;
  late MockUserRepository mockUserRepository;

  const testEmail = 'test@example.com';
  const testPassword = 'Password123_';

  setUp(() {
    mockUserRepository = MockUserRepository();
    signInBloc = SignInBloc(mockUserRepository);
  });

  group('SignInBloc Tests', () {
    test('Initial state is SignInInitial', () {
      expect(signInBloc.state, SignInInitial());
    });

    blocTest<SignInBloc, SignInState>(
      'emits [SignInProcess, SignInSuccess] when signIn is successful',
      build: () {
        when(() => mockUserRepository.signIn(testEmail, testPassword))
            .thenAnswer((_) async {});
        return signInBloc;
      },
      act: (bloc) => bloc.add(const SignInRequired(testEmail, testPassword)),
      expect: () => [SignInProcess(), SignInSuccess()],
      verify: (_) {
        verify(() => mockUserRepository.signIn(testEmail, testPassword))
            .called(1);
      },
    );

    blocTest<SignInBloc, SignInState>(
      'emits [SignInProcess, SignInFailure] when signIn fails',
      build: () {
        when(() => mockUserRepository.signIn(testEmail, testPassword))
            .thenThrow(Exception('Login failed'));
        return signInBloc;
      },
      act: (bloc) => bloc.add(const SignInRequired(testEmail, testPassword)),
      expect: () => [SignInProcess(), SignInFailure()],
      verify: (_) {
        verify(() => mockUserRepository.signIn(testEmail, testPassword))
            .called(1);
      },
    );

    blocTest<SignInBloc, SignInState>(
      'emits [SignOutSuccess] when signOut is successful',
      build: () {
        when(() => mockUserRepository.logOut()).thenAnswer((_) async {});
        return signInBloc;
      },
      act: (bloc) => bloc.add(SignOutRequired()),
      expect: () => [SignOutSuccess()],
      verify: (_) {
        verify(() => mockUserRepository.logOut()).called(1);
      },
    );
  });
}
