class FunDialogUIModel {
  FunDialogUIModel({
    this.title,
    this.description,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.showCloseButton = true,
  });

  final String? title;
  final String? description;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final bool showCloseButton;
}
