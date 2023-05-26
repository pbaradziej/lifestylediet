import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'routing_state.dart';

class RoutingCubit extends Cubit<RoutingState> {
  RoutingCubit() : super(RoutingState(status: RoutingStatus.loaded));

  void showLoadingScreen() {
    _emitRoutingState(status: RoutingStatus.loading);
  }

  void showHomeScreen() {
    _emitRoutingState(status: RoutingStatus.loaded);
  }

  void showAdderScreen(final String meal, final String currentDate) {
    _emitRoutingState(
      status: RoutingStatus.addingProduct,
      currentDate: currentDate,
      meal: meal,
    );
  }

  void _emitRoutingState({
    required final RoutingStatus status,
    final String currentDate = '',
    final String meal = '',
  }) {
    final RoutingState state = RoutingState(
      status: status,
      currentDate: currentDate,
      meal: meal,
    );
    emit(state);
  }
}
