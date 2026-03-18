import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/map/models/map_coordinate.dart';

part 'direction_state.freezed.dart';

class RouteStep {
  final String title;
  final String description;
  final int distanceMeters;
  final int durationSeconds;
  final int type;

  const RouteStep({
    required this.title,
    required this.description,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.type,
  });
}

class RouteOption {
  final String label;
  final int minutes;
  final int meters;
  final int taxiFare;
  final int tollFare;
  final List<MapCoordinate> path;
  final List<RouteStep> steps;

  const RouteOption({
    required this.label,
    required this.minutes,
    required this.meters,
    required this.taxiFare,
    required this.tollFare,
    this.path = const <MapCoordinate>[],
    this.steps = const <RouteStep>[],
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

