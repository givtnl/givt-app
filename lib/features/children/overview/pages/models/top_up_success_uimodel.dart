class TopUpSuccessUIModel {
  const TopUpSuccessUIModel({
    this.amountWithCurrencySymbol,
    this.onClickButton,
  });

  final String? amountWithCurrencySymbol;
  final void Function()? onClickButton;
}
