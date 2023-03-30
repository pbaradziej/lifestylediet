part of 'routing_cubit.dart';

enum RoutingStatus {
  loading,
  loaded,
  addingProduct,
}

class RoutingState extends Equatable {
  final RoutingStatus status;
  final String meal;
  final String currentDate;
  final Key key;

  RoutingState({
    required this.status,
    this.currentDate = '',
    this.meal = '',
  }) : key = UniqueKey();

  RoutingState copyWith({
    RoutingStatus? status,
    String? currentDate,
    String? meal,
  }) {
    return RoutingState(
      status: status ?? this.status,
      currentDate: currentDate ?? this.currentDate,
      meal: meal ?? this.meal,
    );
  }

  @override
  List<Object> get props => <Object>[
        status,
        meal,
        currentDate,
        key,
      ];
}
