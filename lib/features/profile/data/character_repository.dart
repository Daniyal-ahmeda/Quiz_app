import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/features/profile/data/models/character_model.dart';
import 'package:quiz_app/features/auth/data/auth_service.dart';
import 'package:quiz_app/core/services/service_locator.dart';

class CharacterRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // We access AuthService lazily or pass it in.
  // Using locator directly here.
  AuthService? get _authService {
    try {
      return locator<AuthService>();
    } catch (e) {
      return null;
    }
  }

  Character? _character;
  bool _isLoading = false;

  Character? get character => _character;
  bool get isLoading => _isLoading;

  Future<void> fetchCharacter() async {
    final user = _authService?.user;
    if (user == null) {
      _character = null;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        // Handle potential parsing errors if fields are missing
        try {
          _character = Character.fromJson(doc.data()!);
        } catch (e) {
          if (kDebugMode) print("Error parsing character data: $e");
        }
      } else {
        _character = null;
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching character: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCharacter(Character character) async {
    final user = _authService?.user;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Ensure we explicitly set the ID to the user's UID if convenient,
      // or just trust the ID passed in.
      // For a 1:1 mapping, doc(user.uid) is best.

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(character.toJson());
      _character = character;
    } catch (e) {
      if (kDebugMode) print("Error saving character: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
