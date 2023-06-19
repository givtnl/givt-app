import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:iban/iban.dart';

typedef OnPaymentChanged = void Function(int selected);

class PaymentSystemTab extends StatefulWidget {
  const PaymentSystemTab({
    required this.bankAccount,
    required this.ibanNumber,
    required this.sortCode,
    required this.onPaymentChanged,
    super.key,
  });

  final TextEditingController bankAccount;
  final TextEditingController ibanNumber;
  final TextEditingController sortCode;
  final OnPaymentChanged onPaymentChanged;

  @override
  State<PaymentSystemTab> createState() => _PaymentSystemTabState();
}

class _PaymentSystemTabState extends State<PaymentSystemTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }
      setState(() {
        widget.onPaymentChanged(_tabController.index);
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.givtLightGreen,
          tabs: const [
            Tab(
              height: 30,
              icon: Icon(
                Icons.euro,
                color: AppTheme.givtBlue,
                size: 20,
              ),
            ),
            Tab(
              height: 30,
              icon: Icon(
                Icons.currency_pound_rounded,
                color: AppTheme.givtBlue,
                size: 20,
              ),
            ),
          ],
        ),
        IndexedStack(
          index: _currentIndex,
          children: [
            Column(
              children: [
                _buildTextFormField(
                  hintText: locals.ibanPlaceHolder,
                  controller: widget.ibanNumber,
                  validator: (value) {
                    if (_currentIndex == 1) {
                      return null;
                    }
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!isValid(value)) {
                      return '';
                    }
                    return null;
                  },
                )
              ],
            ),
            Column(
              children: [
                _buildTextFormField(
                  hintText: locals.sortCodePlaceholder,
                  controller: widget.sortCode,
                  validator: (value) {
                    if (_currentIndex == 0) {
                      return null;
                    }
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!Util.ukSortCodeRegEx.hasMatch(value)) {
                      return '';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: locals.bankAccountNumberPlaceholder,
                  controller: widget.bankAccount,
                  validator: (value) {
                    if (_currentIndex == 0) {
                      return null;
                    }
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (value.length != 8) {
                      return '';
                    }
                    return null;
                  },
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        onChanged: (value) => setState(() {}),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          errorStyle: const TextStyle(
            height: 0,
          ),
        ),
      ),
    );
  }
}
