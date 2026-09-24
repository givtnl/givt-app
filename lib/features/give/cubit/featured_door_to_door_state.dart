part of 'featured_door_to_door_cubit.dart';

class FeaturedDoorToDoorState extends Equatable {
  const FeaturedDoorToDoorState({
    this.featured,
  });

  const FeaturedDoorToDoorState.hidden() : featured = null;

  const FeaturedDoorToDoorState.loaded(FeaturedCollectGroup this.featured);

  final FeaturedCollectGroup? featured;

  bool get isVisible => featured != null;

  @override
  List<Object?> get props => [featured];
}
