part of 'iris_bloc.dart';

@immutable

sealed class HomeState {}



class HomeInitial extends HomeState {}

class HomeLoading  extends HomeState {}

class HomeLoadedWithData  extends HomeState {
  final Map<String, dynamic> userData;


  HomeLoadedWithData(this.userData);
}
class HomeLoadedWithoutData  extends HomeState {
  final Map<String, dynamic> userData;

  HomeLoadedWithoutData(this.userData);
}


class HomeError  extends HomeState {
  final String error;
  HomeError(this.error);
}
