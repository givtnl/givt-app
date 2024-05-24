class EditAllowanceSuccessUIModel {
  const EditAllowanceSuccessUIModel(
      {this.amountWithCurrencySymbol,
      this.onClickButton,
      this.isMultipleChildren = false});

  final String? amountWithCurrencySymbol;
  final void Function()? onClickButton;
  final bool isMultipleChildren;
}
