import '../../domain/entities/question_item_entity.dart';
import '../../domain/entities/test_quiz_entity.dart';

class MockTestsData {
  static final TestQuizEntity sampleDartQuiz = TestQuizEntity(
    id: 'quiz_dart_01',
    title: "Test d'Expertise Dart : Niveau Intermédiaire à Avancé",
    description:
        "Évaluez vos compétences approfondies sur le langage Dart : collections, typage, asynchronisme, isolats et gestion de mémoire.",
    totalDurationMinutes: 20,
    totalPoints: 200,
    availabilityStartGmt: DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      12,
      0,
    ),
    availabilityEndGmt: DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      14,
      0,
    ),
    status: 'active',
    questions: const [
      QuestionItemEntity(
        id: 'q1',
        title:
            "Quel est le type de collection qui garantit l'unicité de ses éléments et n'autorise pas les doublons en Dart ?",
        type: 'choice',
        level: 2,
        modules: [1],
        points: 10,
        options: ['List', 'Set', 'Map', 'Queue'],
        correctAnswers: [1],
      ),
      QuestionItemEntity(
        id: 'q2',
        title:
            "Quelle est la différence fondamentale entre les mots-clés const et final en Dart ?",
        type: 'choice',
        level: 2,
        modules: [1],
        points: 10,
        options: [
          "const est une constante évaluée à la compilation, final est évalué à l'exécution",
          "final permet la modification, const rend la valeur strictement immuable",
          "const s'applique uniquement aux primitives, final aux objets complexes",
          "Il n'y a aucune différence technique entre const et final",
        ],
        correctAnswers: [0],
      ),
      QuestionItemEntity(
        id: 'q3',
        title:
            "Quel type de constructeur permet d'implémenter un Singleton ou d'extraire une instance déjà instanciée depuis un cache ?",
        type: 'choice',
        level: 3,
        modules: [1, 2],
        points: 10,
        options: [
          'Constructeur factory',
          'Constructeur static',
          'Constructeur const',
          'Constructeur nommé classique',
        ],
        correctAnswers: [0],
      ),
      QuestionItemEntity(
        id: 'q4',
        title:
            "Quel mécanisme Dart permet de réaliser des calculs lourds en arrière-plan sans bloquer la boucle d'événements (Event Loop) du thread principal UI ?",
        type: 'choice',
        level: 3,
        modules: [2],
        points: 10,
        options: [
          'Les Futures',
          'Les Isolates',
          'Les Streams',
          'Les Microtasks',
        ],
        correctAnswers: [1],
      ),
      QuestionItemEntity(
        id: 'q5',
        title:
            "Expliquez brièvement le concept du Sound Null Safety en Dart et son impact sur la compilation.",
        type: 'text',
        level: 3,
        modules: [2],
        points: 20,
        expectedText:
            "Le Sound Null Safety garantit par la compilation qu'une variable non-nullable ne pourra jamais contenir null à l'exécution, permettant des optimisations de performances et l'élimination des NullPointerExceptions.",
      ),
    ],
  );
}
