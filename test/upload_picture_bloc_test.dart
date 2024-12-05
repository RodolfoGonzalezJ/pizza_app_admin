import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

class MockPizzaRepo extends Mock implements PizzaRepo {}

void main() {
  late UploadPictureBloc uploadPictureBloc;
  late MockPizzaRepo mockPizzaRepo;

  var testFile = Uint8List(10); // Simulación de un archivo.
  const testName = 'test_image.png';
  const testUrl = 'https://example.com/test_image.png';

  setUp(() {
    mockPizzaRepo = MockPizzaRepo();
    uploadPictureBloc = UploadPictureBloc(mockPizzaRepo);
  });

  group('UploadPictureBloc Tests', () {
    test('Initial state is UploadPictureLoading', () {
      expect(uploadPictureBloc.state, UploadPictureLoading());
    });

    blocTest<UploadPictureBloc, UploadPictureState>(
      'emits [UploadPictureSuccess] when image upload is successful',
      build: () {
        when(() => mockPizzaRepo.sendImage(testFile, testName))
            .thenAnswer((_) async => testUrl);
        return uploadPictureBloc;
      },
      act: (bloc) => bloc.add(UploadPicture(testFile, testName)),
      expect: () => [UploadPictureSuccess(testUrl)],
      verify: (_) {
        verify(() => mockPizzaRepo.sendImage(testFile, testName)).called(1);
      },
    );

    blocTest<UploadPictureBloc, UploadPictureState>(
      'emits [UploadPictureFailure] when image upload fails',
      build: () {
        when(() => mockPizzaRepo.sendImage(testFile, testName))
            .thenThrow(Exception('Upload failed'));
        return uploadPictureBloc;
      },
      act: (bloc) => bloc.add(UploadPicture(testFile, testName)),
      expect: () => [UploadPictureFailure()],
      verify: (_) {
        verify(() => mockPizzaRepo.sendImage(testFile, testName)).called(1);
      },
    );
  });
}
