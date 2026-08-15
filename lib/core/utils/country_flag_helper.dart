class CountryFlagHelper {
  static const Map<String, String> _countryFlagMap = {
    'bénin': '🇧🇯',
    'benin': '🇧🇯',
    'burkina faso': '🇧🇫',
    'burkina': '🇧🇫',
    'cameroun': '🇨🇲',
    'cameroon': '🇨🇲',
    'république du congo': '🇨🇬',
    'congo': '🇨🇬',
    'congo brazzaville': '🇨🇬',
    'congo brazza': '🇨🇬',
    'congo-brazza': '🇨🇬',
    'congo-brazzaville': '🇨🇬',
    'république démocratique du congo': '🇨🇩',
    'rdc': '🇨🇩',
    'congo kinshasa': '🇨🇩',
    'congo-kinshasa': '🇨🇩',
    'côte d\'ivoire': '🇨🇮',
    'cote d\'ivoire': '🇨🇮',
    'ivory coast': '🇨🇮',
    'madagascar': '🇲🇬',
    'guinée': '🇬🇳',
    'guinee': '🇬🇳',
    'togo': '🇹🇬',
    'sénégal': '🇸🇳',
    'senegal': '🇸🇳',
    'gabon': '🇬🇦',
    'mali': '🇲🇱',
    'niger': '🇳🇪',
    'tchad': '🇹🇩',
    'chad': '🇹🇩',
    'rwanda': '🇷🇼',
    'burundi': '🇧🇮',
    'centrafrique': '🇨🇫',
    'république centrafricaine': '🇨🇫',
    'france': '🇫🇷',
    'haïti': '🇭🇹',
    'haiti': '🇭🇹',
  };

  /// Returns the emoji flag corresponding to the country name.
  static String getFlag(String? countryName) {
    if (countryName == null || countryName.trim().isEmpty) return '';
    final key = countryName.trim().toLowerCase();
    return _countryFlagMap[key] ?? '🌍';
  }
}
