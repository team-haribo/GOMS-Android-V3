import 'package:freezed_annotation/freezed_annotation.dart';

part 'direction_state.freezed.dart';

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

@freezed
abstract class DirectionState with _$DirectionState {
  const factory DirectionState({
    @Default(DirectionStatus.initial) DirectionStatus status,
    @Default('') String departure,
    @Default('') String destination,
    @Default(<RouteOption>[]) List<RouteOption> routeOptions,
    @Default(0) int selectedRouteIndex,
    String? errorMessage,
  }) = _DirectionState;

  factory DirectionState.initial() => const DirectionState();
}
