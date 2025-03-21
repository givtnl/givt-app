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
  });
  final String type;
  final int index;
  final bool isSelected;
}
