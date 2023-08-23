import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class ChildItem extends StatelessWidget {
  const ChildItem({
    required this.name,
    required this.total,
    required this.currencySymbol,
    required this.pending,
    super.key,
  });

  final String name;
  final double total;
  final double pending;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.childItemBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        width: double.infinity,
        height: pending != 0 ? 100 : 75,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 5,
                  left: 20,
                  right: 20,
                  bottom: pending != 0 ? 0 : 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            //TODO: POEditor
                            'Total available:',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            '$currencySymbol ${total.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (pending != 0)
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.childItemPendingBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                width: double.infinity,
                height: 25,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      //TODO: POEditor
                      'Pending approval:',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '$currencySymbol ${pending.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
