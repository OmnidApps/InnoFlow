import 'package:flutter/foundation.dart';
import '../data/models/usecase.dart';
import '../data/usecase_repository.dart';

class UsecaseService extends ChangeNotifier {
  final UsecaseRepository _usecaseRepository;

  List<Usecase> _usecases = [];
  bool _isLoading = false;
  String? _error;

  UsecaseService({required UsecaseRepository repository})
      : _usecaseRepository = repository;

  List<Usecase> get usecases => _usecases;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUsecases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usecases = await _usecaseRepository.getAll();
      _isLoading = false;
    } catch (e) {
      _error = 'Failed to fetch usecases: $e';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> createUsecase(Usecase usecase) async {
    try {
      await _usecaseRepository.insert(usecase);
      _usecases.add(usecase);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create usecase: $e';
      notifyListeners();
    }
  }

  Future<void> updateUsecase(Usecase usecase) async {
    try {
      await _usecaseRepository.update(usecase);
      final index = _usecases.indexWhere((u) => u.id == usecase.id);
      if (index != -1) {
        _usecases[index] = usecase;
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update usecase: $e';
      notifyListeners();
    }
  }

  Future<void> executeUsecase(int? id) async {
    try {
      final usecase = await _usecaseRepository.getById(id!);
      if (usecase != null) {
        // Execute the usecase logic here
        print('Executing usecase: ${usecase.name}');
      } else {
        _error = 'Usecase not found';
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to execute usecase: $e';
      notifyListeners();
    }
  }

  Future<void> deleteUsecase(Usecase usecase) async {
    try {
      await _usecaseRepository.delete(usecase.id!);
      _usecases.removeWhere((u) => u.id == usecase.id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete usecase: $e';
      notifyListeners();
    }
  }

}