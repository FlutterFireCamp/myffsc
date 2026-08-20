import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myffsc/features/announcements/announcements.dart';

class MockGetAnnouncementsUseCase extends Mock implements GetAnnouncementsUseCase {}

void main() {
  late MockGetAnnouncementsUseCase mockGetAnnouncementsUseCase;
  late AnnouncementsBloc announcementsBloc;

  setUpAll(() {
    registerFallbackValue(const GetAnnouncementsParams());
  });

  setUp(() {
    mockGetAnnouncementsUseCase = MockGetAnnouncementsUseCase();
    announcementsBloc = AnnouncementsBloc(
      getAnnouncementsUseCase: mockGetAnnouncementsUseCase,
    );
  });

  tearDown(() {
    announcementsBloc.close();
  });

  const tAnnouncement = AnnouncementItem(
    id: 'ann_1',
    type: AnnouncementType.urgent,
    targetRole: TargetRole.all,
    title: 'Hackathon ce samedi !',
    description: 'Préparez vos équipes pour le rendu de projet',
    date: '2026-08-18',
  );

  const tResult = PaginatedAnnouncementsResult(
    items: [tAnnouncement],
    lastDocument: null,
    hasMore: false,
  );

  group('AnnouncementsBloc Tests', () {
    blocTest<AnnouncementsBloc, AnnouncementsState>(
      'emits [AnnouncementsLoadingState, AnnouncementsLoadedState] on FetchAnnouncementsEvent',
      build: () {
        when(() => mockGetAnnouncementsUseCase(any()))
            .thenAnswer((_) async => const Right(tResult));
        return announcementsBloc;
      },
      act: (bloc) => bloc.add(const FetchAnnouncementsEvent()),
      expect: () => [
        isA<AnnouncementsLoadingState>(),
        isA<AnnouncementsLoadedState>().having(
          (s) => s.announcements.length,
          'announcements.length',
          1,
        ).having(
          (s) => s.hasMore,
          'hasMore',
          false,
        ),
      ],
    );
  });
}
