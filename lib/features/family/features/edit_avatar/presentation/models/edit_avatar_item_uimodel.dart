sealed class EditAvatarItemUIModel {
  const EditAvatarItemUIModel();
}

class LockedItem extends EditAvatarItemUIModel {
  const LockedItem();
}

class UnlockedItem extends EditAvatarItemUIModel {
  const UnlockedItem({
    required this.type,
    required this.index,
    this.isSelected = false,
    this.isEasterEgg = false,
  });
  final String type;
  final int index;
  final bool isSelected;
  final bool isEasterEgg;
}
