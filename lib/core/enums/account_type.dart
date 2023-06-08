enum AccountType {
  sepa,
  bacs,
  creditCard,
  none;

  int toInt() {
    switch (this) {
      case AccountType.sepa:
        return 0;
      case AccountType.bacs:
        return 1;
      case AccountType.creditCard:
        return 2;
      case AccountType.none:
        return 3;
    }
  }

  static AccountType fromString(String value) {
    switch (value) {
      case 'SEPA':
        return AccountType.sepa;
      case 'BACS':
        return AccountType.bacs;
      case 'CreditCard':
        return AccountType.creditCard;
      default:
        return AccountType.none;
    }
  }

  static AccountType fromInt(int value) {
    switch (value) {
      case 0:
        return AccountType.sepa;
      case 1:
        return AccountType.bacs;
      case 2:
        return AccountType.creditCard;
      default:
        return AccountType.none;
    }
  }
}
