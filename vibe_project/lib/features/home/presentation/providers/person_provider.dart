import 'package:flutter/material.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/get_recommended_people.dart';
import '../../domain/usecases/follow_person.dart';
import '../../core/errors/failures.dart';

class PersonProvider extends ChangeNotifier {
  final GetRecommendedPeople getRecommendedPeople;
  final FollowPerson followPerson;
  
  PersonProvider({
    required this.getRecommendedPeople,
    required this.followPerson,
  });

  List<Person> _people = [];
  bool _isLoading = false;
  String? _error;
  Set<String> _followingIds = {};

  List<Person> get people => _people;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRecommendedPeople() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getRecommendedPeople(NoParams());
    
    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (people) {
        _people = people;
        _followingIds = people.where((p) => p.isFollowing).map((p) => p.id).toSet();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> followPerson(String personId) async {
    final result = await followPerson(FollowPersonParams(personId: personId));
    
    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) {
        _followingIds.add(personId);
        _people = _people.map((person) {
          if (person.id == personId) {
            return person.copyWith(isFollowing: true);
          }
          return person;
        }).toList();
        notifyListeners();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case NetworkFailure:
        return 'No internet connection';
      default:
        return 'Unexpected error occurred';
    }
  }

  bool isFollowing(String personId) {
    return _followingIds.contains(personId);
  }

  void refresh() {
    fetchRecommendedPeople();
  }
}
