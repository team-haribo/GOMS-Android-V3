class RouteOption {
  final String label;
  final int minutes;
  final int meters;
  final int calories;

  const RouteOption({
    required this.label,
    required this.minutes,
    required this.meters,
    required this.calories,
  });
}

enum DirectionStatus { initial, loading, success, failure }

class DirectionState {
  final DirectionStatus status;
  final String departure;
  final String destination;
  final List<RouteOption> routeOptions;
  final int selectedRouteIndex;
  final String? errorMessage;

  const DirectionState({
    this.status = DirectionStatus.initial,
    this.departure = '',
    this.destination = '',
    this.routeOptions = const [],
    this.selectedRouteIndex = 0,
    this.errorMessage,
  });

  factory DirectionState.initial() => const DirectionState();

  DirectionState copyWith({
    DirectionStatus? status,
    String? departure,
    String? destination,
    List<RouteOption>? routeOptions,
    int? selectedRouteIndex,
    String? errorMessage,
  }) {
    return DirectionState(
      status: status ?? this.status,
      departure: departure ?? this.departure,
      destination: destination ?? this.destination,
      routeOptions: routeOptions ?? this.routeOptions,
      selectedRouteIndex: selectedRouteIndex ?? this.selectedRouteIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
