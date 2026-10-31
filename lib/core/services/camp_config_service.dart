import 'dart:async';
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service gérant la configuration globale et l'état d'avancement du camp
/// (ex: fin du camp, bascule vers la vérification des certificats).
class CampConfigService {
  final FirebaseFirestore _firestore;

  bool _isCampEnded = false;
  StreamController<bool>? _controller;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  CampConfigService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Indique immédiatement si le camp est officiellement terminé (valeur en cache).
  bool get isCampEnded => _isCampEnded;

  /// Flux en temps réel signalant si le camp est terminé.
  Stream<bool> get isCampEndedStream {
    _controller ??= StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _controller!.stream;
  }

  void _startListening() {
    try {
      dev.log(
        'Démarrage de l\'écoute en temps réel de config/camp-settings...',
        name: 'CAMP_CONFIG_SERVICE',
      );
      _subscription = _firestore
          .collection('config')
          .doc('camp-settings')
          .snapshots()
          .listen(
        (docSnap) {
          final isEnded = _extractIsCampEnded(docSnap);
          _isCampEnded = isEnded;
          dev.log(
            'Mise à jour config/camp-settings -> isCampEnded = $isEnded',
            name: 'CAMP_CONFIG_SERVICE',
          );
          if (_controller != null && !_controller!.isClosed) {
            _controller!.add(isEnded);
          }
        },
        onError: (e) {
          dev.log(
            'Erreur écoute config/camp-settings (fallback: $_isCampEnded)',
            name: 'CAMP_CONFIG_SERVICE',
            error: e,
          );
          if (_controller != null && !_controller!.isClosed) {
            _controller!.add(_isCampEnded);
          }
        },
      );
    } catch (e) {
      dev.log(
        'Impossible de souscrire aux snapshots de config/camp-settings',
        name: 'CAMP_CONFIG_SERVICE',
        error: e,
      );
    }
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Récupération ponctuelle de la configuration du camp.
  Future<bool> checkIsCampEnded() async {
    try {
      final docSnap =
          await _firestore.collection('config').doc('camp-settings').get();
      _isCampEnded = _extractIsCampEnded(docSnap);
      if (_controller != null && !_controller!.isClosed) {
        _controller!.add(_isCampEnded);
      }
      return _isCampEnded;
    } catch (e) {
      dev.log(
        'Erreur checkIsCampEnded (fallback: $_isCampEnded)',
        name: 'CAMP_CONFIG_SERVICE',
        error: e,
      );
      return _isCampEnded;
    }
  }

  bool _extractIsCampEnded(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    if (!docSnap.exists || docSnap.data() == null) return false;
    final data = docSnap.data()!;
    return data['isCampEnded'] == true ||
        data['campEnded'] == true ||
        data['isEnded'] == true;
  }

  void dispose() {
    _stopListening();
    _controller?.close();
    _controller = null;
  }
}
