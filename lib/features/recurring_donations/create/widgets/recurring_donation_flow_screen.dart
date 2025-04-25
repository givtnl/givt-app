import 'package:flutter/material.dart';
import 'package:givt_app/features/recurring_donations/create/widgets/line_pager_indicator.dart';
import 'package:intl/intl.dart';

class RecurringDonationFlowScreen extends StatefulWidget {
  const RecurringDonationFlowScreen({super.key});

  Route<dynamic> toRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (_) => this,
    );
  }

  @override
  State<RecurringDonationFlowScreen> createState() =>
      _RecurringDonationFlowScreenState();
}

class _RecurringDonationFlowScreenState
    extends State<RecurringDonationFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Set amount screen state
  String _selectedFrequency = 'Monthly';
  String _amount = '\$50';

  // Set duration screen state
  int _selectedEndOption = 0;
  final List<String> _endOptions = [
    'When I decide',
    'After a number of donations',
    'On a specific date',
  ];
  String _startDate = '25 April 2025';
  int? _numberOfDonations;
  String? _endDate;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Submit the recurring donation
      Navigator.of(context).pop();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _getPageTitle(),
          style: const TextStyle(
            fontFamily: 'Rouna',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF005231),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF005231)),
          onPressed: _previousPage,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF005231)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: LinePagerIndicator(
              currentPage: _currentPage,
              pageCount: 3, // Amount, Duration, Confirm
            ),
          ),

          // Main content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildAmountPage(),
                _buildDurationPage(),
                _buildConfirmPage(),
              ],
            ),
          ),

          // Continue button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF60DD9B),
                  foregroundColor: const Color(0xFF005231),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF006D42),
                ),
                child: Text(
                  _currentPage == 2 ? 'Confirm' : 'Continue',
                  style: const TextStyle(
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentPage) {
      case 0:
        return 'Set amount';
      case 1:
        return 'Set duration';
      case 2:
        return 'Confirm donation';
      default:
        return '';
    }
  }

  Widget _buildAmountPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Title
            const Text(
              'How often do you want to give, and how much?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rouna',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF004F50),
              ),
            ),

            const SizedBox(height: 32),

            // Frequency dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Donation frequency',
                  style: TextStyle(
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF00696A),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Show frequency dropdown
                    _showFrequencyPicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFF006D42), width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedFrequency,
                            style: const TextStyle(
                              fontFamily: 'Rouna',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF006D42),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF005231),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Amount input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Donation amount',
                  style: TextStyle(
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF00696A),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Show amount picker
                    _showAmountPicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFF006D42), width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _amount,
                            style: const TextStyle(
                              fontFamily: 'Rouna',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF006D42),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Title
            const Text(
              'How long would you like to schedule this donation for?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rouna',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF004F50),
              ),
            ),

            const SizedBox(height: 32),

            // Start date section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Starting on',
                  style: TextStyle(
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF00696A),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Date picker logic
                    _showDatePicker(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFF006D42), width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _startDate,
                            style: const TextStyle(
                              fontFamily: 'Rouna',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF006D42),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF005231),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // End options section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ends',
                  style: TextStyle(
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF00696A),
                  ),
                ),
                const SizedBox(height: 8),

                // Radio options
                for (int i = 0; i < _endOptions.length; i++)
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedEndOption = i;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFEEF2E4),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _endOptions[i],
                                  style: const TextStyle(
                                    fontFamily: 'Rouna',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF003920),
                                  ),
                                ),
                              ),
                              Icon(
                                _selectedEndOption == i
                                    ? Icons.circle
                                    : Icons.circle_outlined,
                                color: _selectedEndOption == i
                                    ? const Color(0xFF006D42)
                                    : const Color(0x80006D42), // 50% opacity
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (i == 1 && _selectedEndOption == 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF006D42),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF006D42),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _numberOfDonations = int.tryParse(value);
                                });
                              }
                            },
                          ),
                        ),
                      if (i == 2 && _selectedEndOption == 2)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            onTap: () {
                              // Show date picker for end date
                              _showDatePicker(false);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF006D42),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _endDate ?? 'Select date',
                                      style: TextStyle(
                                        fontFamily: 'Rouna',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: _endDate != null
                                            ? const Color(0xFF006D42)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF005231),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Title
            const Text(
              'Please confirm your recurring donation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rouna',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF004F50),
              ),
            ),

            const SizedBox(height: 32),

            // Donation summary
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2E4),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Amount row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount',
                        style: TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                      Text(
                        _amount,
                        style: const TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Frequency row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Frequency',
                        style: TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                      Text(
                        _selectedFrequency,
                        style: const TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Starting date row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Starting',
                        style: TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                      Text(
                        _startDate,
                        style: const TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Ending row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ends',
                        style: TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                      Text(
                        _getEndingText(),
                        style: const TextStyle(
                          fontFamily: 'Rouna',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF003920),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recipient info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF40C181)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4E3DB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.home_outlined,
                            size: 32,
                            color: Color(0xFF006D42),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'St. Mary\'s Church',
                              style: TextStyle(
                                fontFamily: 'Rouna',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF003920),
                              ),
                            ),
                            Text(
                              'Local church community fund',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF006D42),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getEndingText() {
    switch (_selectedEndOption) {
      case 0:
        return 'When I decide';
      case 1:
        return 'After ${_numberOfDonations ?? "..."} donations';
      case 2:
        return _endDate ?? 'Select a date';
      default:
        return '';
    }
  }

  void _showFrequencyPicker() {
    final frequencies = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...frequencies.map(
                (frequency) => ListTile(
                  title: Text(
                    frequency,
                    style: const TextStyle(
                      fontFamily: 'Rouna',
                      fontSize: 16,
                      color: Color(0xFF003920),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedFrequency = frequency;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAmountPicker() {
    // Simple dialog for amount input
    showDialog(
      context: context,
      builder: (context) {
        String tempAmount = _amount.replaceAll('\$', '');

        return AlertDialog(
          title: const Text('Enter donation amount'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: tempAmount),
            onChanged: (value) {
              tempAmount = value;
            },
            decoration: const InputDecoration(
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (tempAmount.isNotEmpty) {
                  setState(() {
                    _amount = '\$' + tempAmount;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showDatePicker(bool isStartDate) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        final formattedDate = DateFormat('d MMMM yyyy').format(pickedDate);
        setState(() {
          if (isStartDate) {
            _startDate = formattedDate;
          } else {
            _endDate = formattedDate;
          }
        });
      }
    });
  }
}
