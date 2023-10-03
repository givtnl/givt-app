import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/utils/utils.dart';

class ExternalDonationItem extends StatelessWidget {
  const ExternalDonationItem({
    required this.title,
    required this.amount,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final String title;
  final double amount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final countryCode = context.read<AuthCubit>().state.user.country;
    return Card(
      elevation: 5,
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                '${Util.getCurrencySymbol(countryCode: countryCode)} $amount',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          _buildMenuItemButton(
            backgroundColor: AppTheme.givtYellow,
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit,
            ),
          ),
          _buildMenuItemButton(
            backgroundColor: AppTheme.givtOrange,
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete,
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemButton({
    required Color backgroundColor,
    required VoidCallback onPressed,
    required Icon icon,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: isLast
            ? const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              )
            : null,
      ),
      height: 60,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.white,
      ),
    );
  }
}
