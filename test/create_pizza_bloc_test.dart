import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/create_pizza_bloc/create_pizza_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

class MockPizzaRepo extends Mock implements PizzaRepo {}

class FakePizza extends Fake implements Pizza {}

void main() {
  late CreatePizzaBloc createPizzaBloc;
  late MockPizzaRepo mockPizzaRepo;

  setUp(() {
    mockPizzaRepo = MockPizzaRepo();
    createPizzaBloc = CreatePizzaBloc(mockPizzaRepo);
    registerFallbackValue(FakePizza());
  });

  group('CreatePizzaBloc Tests', () {
    test('Initial state is CreatePizzaInitial', () {
      expect(createPizzaBloc.state, CreatePizzaInitial());
    });

    blocTest<CreatePizzaBloc, CreatePizzaState>(
      'emits [CreatePizzaLoading, CreatePizzaSuccess] when pizza is created successfully',
      build: () {
        when(() => mockPizzaRepo.createPizzas(any())).thenAnswer((_) async {});
        return createPizzaBloc;
      },
      act: (bloc) => bloc.add(CreatePizza(FakePizza())),
      expect: () => [CreatePizzaLoading(), CreatePizzaSuccess()],
      verify: (_) {
        verify(() => mockPizzaRepo.createPizzas(any())).called(1);
      },
    );

    blocTest<CreatePizzaBloc, CreatePizzaState>(
      'emits [CreatePizzaLoading, CreatePizzaFailure] when creating pizza fails',
      build: () {
        when(() => mockPizzaRepo.createPizzas(any()))
            .thenThrow(Exception('Error'));
        return createPizzaBloc;
      },
      act: (bloc) => bloc.add(CreatePizza(FakePizza())),
      expect: () => [CreatePizzaLoading(), CreatePizzaFailure()],
      verify: (_) {
        verify(() => mockPizzaRepo.createPizzas(any())).called(1);
      },
    );
  });
}
