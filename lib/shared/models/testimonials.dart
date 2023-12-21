enum Testinomials {
  testimonial1(
    'assets/images/testimonial1.png',
  ),
  testimonial2(
    'assets/images/testimonial2.png',
  ),
  testimonial3(
    'assets/images/testimonial3.png',
  ),
  testimonial4(
    'assets/images/testimonial4.png',
  );

  const Testinomials(
    this.image,
  );

  final String image;

  static List<Testinomials> summary = [
    Testinomials.testimonial1,
    Testinomials.testimonial2,
    Testinomials.testimonial3,
  ];

  static List<Testinomials> yearlyOverview = [
    Testinomials.testimonial4,
  ];
}
