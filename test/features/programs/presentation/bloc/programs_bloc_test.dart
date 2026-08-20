import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myffsc/features/programs/programs.dart';

class MockGetUpcomingProgramsUseCase extends Mock implements GetUpcomingProgramsUseCase {}

void main() {
  late MockGetUpcomingProgramsUseCase mockGetUpcomingProgramsUseCase;
  late ProgramsBloc programsBloc;

  setUpAll(() {
    registerFallbackValue(const GetUpcomingProgramsParams());
  });

  setUp(() {
    mockGetUpcomingProgramsUseCase = MockGetUpcomingProgramsUseCase();
    programsBloc = ProgramsBloc(
      getUpcomingProgramsUseCase: mockGetUpcomingProgramsUseCase,
    );
  });

  tearDown(() {
    programsBloc.close();
  });

  const tProgram = ProgramItem(
    id: 'prog_1',
    type: ProgramType.session,
    title: 'State Management avec BLoC',
    description: 'Comprendre les événements et états',
    date: '2026-08-18',
    time: '18h00',
    sessionUrl: 'https://meet.google.com/abc-def-ghi',
  );

  group('ProgramsBloc Tests', () {
    blocTest<ProgramsBloc, ProgramsState>(
      'emits [ProgramsLoadingState, ProgramsLoadedState] when programs are fetched successfully',
      build: () {
        when(() => mockGetUpcomingProgramsUseCase(any()))
            .thenAnswer((_) async => const Right([tProgram]));
        return programsBloc;
      },
      act: (bloc) => bloc.add(const FetchProgramsEvent()),
      expect: () => [
        isA<ProgramsLoadingState>(),
        isA<ProgramsLoadedState>().having(
          (s) => s.programs.length,
          'programs.length',
          1,
        ),
      ],
    );
  });
}
