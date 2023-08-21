import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateChildPage extends StatefulWidget {
  const CreateChildPage({super.key});

  @override
  State<CreateChildPage> createState() => _CreateChildPageState();
}

class _CreateChildPageState extends State<CreateChildPage> {
  void _showDataPickerDialog() {
    final today = DateTime.now();
    final maximumDate = today;
    final minimumDate = DateTime(today.year - 18);
    var currentDate = _selectedDate;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.35,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 60),
                child: CupertinoDatePicker(
                  initialDateTime: currentDate,
                  maximumDate: maximumDate,
                  minimumDate: minimumDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    currentDate = newDate;
                  },
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: TextButton(
                  //TODO
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppTheme.sliderIndicatorFilled,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    _selectedDate = currentDate;
                    _dateOfBirthController.text =
                        _dateFormatter.format(_selectedDate);
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _dateOfBirthController = TextEditingController();
  final _dateFormatter = DateFormat('MM-dd-yyyy');
  var _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final locals = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 35),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: size.height * 0.035,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: size.height * 0.82,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      //TODO
                      child: Text(
                        'Please enter some information about your child',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppTheme.sliderIndicatorFilled),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      maxLength: 20,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppTheme.sliderIndicatorFilled),
                      decoration: InputDecoration(
                        //TODO:
                        label: const Text('First Name'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.inputFieldBorderEnabled,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.inputFieldBorderSelected,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _dateOfBirthController,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppTheme.sliderIndicatorFilled),
                      decoration: InputDecoration(
                        //TODO
                        label: const Text('Date of birth'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.inputFieldBorderEnabled,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.inputFieldBorderSelected,
                          ),
                        ),
                      ),
                      onTap: _showDataPickerDialog,
                      showCursor: true,
                      readOnly: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppTheme.sliderIndicatorFilled),
                      decoration: InputDecoration(
                        //TODO:
                        label: const Text('Giving allowance'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.inputFieldBorderEnabled,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.inputFieldBorderSelected,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          decimalDigits: 2,
                        )
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {},
                  //TODO
                  child: Text(
                    'Create child profile',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
