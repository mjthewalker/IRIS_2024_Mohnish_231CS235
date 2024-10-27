import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'iris_states.dart';
part 'iris_events.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  HomeBloc() : super(HomeInitial()){
    on<LoadData> (_LoadData);
  }
  void _LoadData(LoadData event, Emitter<HomeState> emit) async{
    emit (HomeLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        final Map<String,dynamic> userData = snapshot.data() as Map<String,dynamic>;
        if (userData['hostelInfo']==null){
          emit(HomeLoadedWithoutData(userData));

        }
        else{
          emit(HomeLoadedWithData(userData));
        }

      } else {
        emit(HomeError("User data not found"));
      }
    } catch (e) {
      emit(HomeError("Failed to load user data"));
    }

  }




  }



