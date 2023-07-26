import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/widgets/dropdown_year_menu.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class DownloadYearOverviewSheet extends StatefulWidget {
  const DownloadYearOverviewSheet(
      {required this.state, required this.givtbloc, super.key});
  final GivtState state;
  final GivtBloc givtbloc;
  @override
  State<DownloadYearOverviewSheet> createState() =>
      _DownloadYearOverviewSheetState();
}

class _DownloadYearOverviewSheetState extends State<DownloadYearOverviewSheet> {
  String _overviewYearController = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);
    final user = context.read<AuthCubit>().state.user;

    return Column(
      children: [
        _buildAnnualOverviewHeader(
          email: user.email,
          text: locals.downloadYearOverviewByChoice,
        ),
        YearOfDonationsDropdown(
          donationYears: _getYears(widget.state),
          selectedYear:
              _getYears(widget.state).contains(_overviewYearController)
                  ? _overviewYearController
                  : _getYears(widget.state).first,
          onYearChanged: (String? newValue) {
            setState(() {
              _overviewYearController = newValue!;
            });
          },
        ),
        const Spacer(),
        Image.asset(
          'assets/images/givy_money.png',
          height: size.height * 0.2,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            widget.givtbloc.add(
              GivtDownloadOverviewByYear(
                year: _getYears(widget.state).contains(_overviewYearController)
                    ? _overviewYearController
                    : _getYears(widget.state).first,
                guid: user.guid,
              ),
            );
            context.pop();
          },
          child: Text(locals.send),
        )
      ],
    );
  }

  Widget _buildAnnualOverviewHeader(
      {required String text, required String email}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          color: AppTheme.givtBlue,
          fontWeight: FontWeight.normal,
        ),
        children: <TextSpan>[
          TextSpan(
            text: ' $email',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getYears(GivtState state) {
    final givts = state.givts;
    if (givts.isEmpty) {
      return [];
    } else {
      return givts
          .map((donation) {
            final year = donation.timeStamp!.year.toString();
            return year;
          })
          .toSet()
          .toList();
    }
  }
}
