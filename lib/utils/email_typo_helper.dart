/// Suggests a common-provider correction for a likely email typo.
///
/// The typed address is never rewritten by this helper. Callers decide
/// whether to show the suggestion and whether the user applies it.
class EmailTypoHelper {
  const EmailTypoHelper._();

  static const _allMarkets = <String>[
    'gmail.com',
    'googlemail.com',
    'outlook.com',
    'hotmail.com',
    'live.com',
    'icloud.com',
    'me.com',
    'yahoo.com',
  ];

  static const _us = <String>['aol.com', 'msn.com'];

  static const _uk = <String>[
    'hotmail.co.uk',
    'live.co.uk',
    'yahoo.co.uk',
    'btinternet.com',
  ];

  static const _nl = <String>[
    'hotmail.nl',
    'live.nl',
    'ziggo.nl',
    'kpnmail.nl',
  ];

  static const _de = <String>[
    'web.de',
    'gmx.de',
    'gmx.net',
    't-online.de',
    'hotmail.de',
  ];

  static const _be = <String>[
    'hotmail.be',
    'live.be',
    'skynet.be',
    'telenet.be',
  ];

  /// Returns `local@suggestedDomain` when [email] looks like a typo of a
  /// common provider, or null when there is nothing useful to suggest.
  ///
  /// [countryCode] adds that market's domains on top of the shared list.
  /// Unknown or empty codes use the shared list only.
  ///
  /// While the field is focused, pass `allowPrefixMatches: false` so an
  /// unfinished prefix such as `gmail.co` stays quiet. On blur, pass true.
  static String? suggestEmail(
    String email, {
    String? countryCode,
    bool allowPrefixMatches = false,
  }) {
    final trimmed = email.trim();
    final at = trimmed.indexOf('@');
    if (at <= 0 || at != trimmed.lastIndexOf('@') || at == trimmed.length - 1) {
      return null;
    }

    final rawLocal = trimmed.substring(0, at);
    final rawDomain = trimmed.substring(at + 1);
    final local = _cleanLocal(rawLocal);
    final domain = _cleanDomain(rawDomain);
    if (local.isEmpty || domain.isEmpty || domain.contains(' ')) {
      return null;
    }

    final candidates = _domainsFor(countryCode);
    final syntaxChanged =
        '$local@$domain'.toLowerCase() != trimmed.toLowerCase();
    if (syntaxChanged && candidates.contains(domain)) {
      return _unlessSame(trimmed, '$local@$domain');
    }
    if (candidates.contains(domain)) {
      return null;
    }

    String? best;
    var bestDistance = 1 << 30;
    var tie = false;
    for (final candidate in candidates) {
      final distance = _levenshtein(domain, candidate);
      if (!_withinThreshold(domain, candidate, distance)) {
        continue;
      }
      if (distance < bestDistance) {
        bestDistance = distance;
        best = candidate;
        tie = false;
      } else if (distance == bestDistance) {
        tie = true;
      }
    }

    if (best == null || tie) {
      return null;
    }
    if (!allowPrefixMatches && best.startsWith(domain)) {
      return null;
    }
    return _unlessSame(trimmed, '$local@$best');
  }

  static List<String> _domainsFor(String? countryCode) {
    final extra = switch (countryCode?.toUpperCase()) {
      'US' => _us,
      'GB' || 'JE' || 'GG' => _uk,
      'NL' => _nl,
      'DE' => _de,
      'BE' => _be,
      _ => const <String>[],
    };
    return <String>[..._allMarkets, ...extra];
  }

  static String _cleanLocal(String local) {
    var value = local.trim();
    while (value.endsWith('.')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  static String _cleanDomain(String domain) {
    var value = domain.trim().toLowerCase();
    while (value.startsWith('.')) {
      value = value.substring(1);
    }
    while (value.endsWith('.')) {
      value = value.substring(0, value.length - 1);
    }
    while (value.contains('..')) {
      value = value.replaceAll('..', '.');
    }
    return value;
  }

  static bool _withinThreshold(String typed, String candidate, int distance) {
    if (distance <= 0) {
      return false;
    }
    final shorter = typed.length < candidate.length
        ? typed.length
        : candidate.length;
    if (distance == 1) {
      return shorter >= 4;
    }
    if (distance == 2) {
      return shorter >= 6;
    }
    return false;
  }

  static String? _unlessSame(String original, String suggestion) {
    if (suggestion.toLowerCase() == original.toLowerCase()) {
      return null;
    }
    return suggestion;
  }

  static int _levenshtein(String a, String b) {
    if (a == b) {
      return 0;
    }
    if (a.isEmpty) {
      return b.length;
    }
    if (b.isEmpty) {
      return a.length;
    }

    var previous = List<int>.generate(b.length + 1, (index) => index);
    var current = List<int>.filled(b.length + 1, 0);
    for (var i = 1; i <= a.length; i++) {
      current[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        final insert = current[j - 1] + 1;
        final delete = previous[j] + 1;
        final replace = previous[j - 1] + cost;
        var best = insert < delete ? insert : delete;
        if (replace < best) {
          best = replace;
        }
        current[j] = best;
      }
      final swap = previous;
      previous = current;
      current = swap;
    }
    return previous[b.length];
  }
}
