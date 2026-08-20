class AppDataConstants {
  static const List<String> genderOptions = ['Homme', 'Femme'];
  static const List<String> yesNoOptions = ['Non', 'Oui'];

  static const List<String> hubOptions = [
    'KIVU IMPACT CENTER',
    '10000 Codeurs',
    'Tek Komea',
    'GDG On Campus ESTI',
    'GDG RATOMA',
    'GDG Ouaga',
    'GDG Yamoussoukro',
    'GDG CLOUD ABIDJAN',
    'GDG on Campus UCB',
    'WTM Kivu',
    'ITN Hub',
    'GDG Yaoundé',
    'Yekola Now',
    'Devcreed',
    'GDG LOMÉ',
    'Club Statistique de Université Lumière de Bujumbura (ULBU)',
    'WTM Ngaoundéré',
    'Autre / Non affilié',
  ];

  static const Map<String, String> countryFlags = {
    'Afrique du Sud': '🇿🇦',
    'Algérie': '🇩🇿',
    'Angola': '🇦🇴',
    'Bénin': '🇧🇯',
    'Botswana': '🇧🇼',
    'Burkina Faso': '🇧🇫',
    'Burundi': '🇧🇮',
    'Cabo Verde': '🇨🇻',
    'Cameroun': '🇨🇲',
    'Comores': '🇰🇲',
    'Congo-Brazzaville': '🇨🇬',
    'Congo-Kinshasa': '🇨🇩',
    'Côte d\'Ivoire': '🇨🇮',
    'Djibouti': '🇩🇯',
    'Égypte': '🇪🇬',
    'Érythrée': '🇪🇷',
    'Eswatini': '🇸🇿',
    'Éthiopie': '🇪🇹',
    'Gabon': '🇬🇦',
    'Gambie': '🇬🇲',
    'Ghana': '🇬🇭',
    'Guinée': '🇬🇳',
    'Guinée-Bissau': '🇬🇼',
    'Guinée équatoriale': '🇬🇶',
    'Kenya': '🇰🇪',
    'Lesotho': '🇱🇸',
    'Libéria': '🇱🇷',
    'Libye': '🇱🇾',
    'Madagascar': '🇲🇬',
    'Malawi': '🇲🇼',
    'Mali': '🇲🇱',
    'Maroc': '🇲🇦',
    'Maurice': '🇲🇺',
    'Mauritanie': '🇲🇷',
    'Mozambique': '🇲🇿',
    'Namibie': '🇳🇦',
    'Niger': '🇳🇪',
    'Nigéria': '🇳🇬',
    'Ouganda': '🇺🇬',
    'République centrafricaine': '🇨🇫',
    'Rwanda': '🇷🇼',
    'Sao Tomé-et-Principe': '🇸🇹',
    'Sénégal': '🇸🇳',
    'Seychelles': '🇸🇨',
    'Sierra Leone': '🇸🇱',
    'Somalie': '🇸🇴',
    'Soudan': '🇸🇩',
    'Soudan du Sud': '🇸🇸',
    'Tanzanie': '🇹🇿',
    'Tchad': '🇹🇩',
    'Togo': '🇹🇬',
    'Tunisie': '🇹🇳',
    'Zambie': '🇿🇲',
    'Zimbabwe': '🇿🇼',
  };

  /// Liste de tous les pays africains avec leur émoji de drapeau en préfixe
  static const List<String> africanCountries = [
    '🇿🇦 Afrique du Sud',
    '🇩🇿 Algérie',
    '🇦🇴 Angola',
    '🇧🇯 Bénin',
    '🇧🇼 Botswana',
    '🇧🇫 Burkina Faso',
    '🇧🇮 Burundi',
    '🇨🇻 Cabo Verde',
    '🇨🇲 Cameroun',
    '🇰🇲 Comores',
    '🇨🇬 Congo-Brazzaville',
    '🇨🇩 Congo-Kinshasa',
    '🇨🇮 Côte d\'Ivoire',
    '🇩🇯 Djibouti',
    '🇪🇬 Égypte',
    '🇪🇷 Érythrée',
    '🇸🇿 Eswatini',
    '🇪🇹 Éthiopie',
    '🇬🇦 Gabon',
    '🇬🇲 Gambie',
    '🇬🇭 Ghana',
    '🇬🇳 Guinée',
    '🇬🇼 Guinée-Bissau',
    '🇬🇶 Guinée équatoriale',
    '🇰🇪 Kenya',
    '🇱🇸 Lesotho',
    '🇱🇷 Libéria',
    '🇱🇾 Libye',
    '🇲🇬 Madagascar',
    '🇲🇼 Malawi',
    '🇲🇱 Mali',
    '🇲🇦 Maroc',
    '🇲🇺 Maurice',
    '🇲🇷 Mauritanie',
    '🇲🇿 Mozambique',
    '🇳🇦 Namibie',
    '🇳🇪 Niger',
    '🇳🇬 Nigéria',
    '🇺🇬 Ouganda',
    '🇨🇫 République centrafricaine',
    '🇷🇼 Rwanda',
    '🇸🇹 Sao Tomé-et-Principe',
    '🇸🇳 Sénégal',
    '🇸🇨 Seychelles',
    '🇸🇱 Sierra Leone',
    '🇸🇴 Somalie',
    '🇸🇩 Soudan',
    '🇸🇸 Soudan du Sud',
    '🇹🇿 Tanzanie',
    '🇹🇩 Tchad',
    '🇹🇬 Togo',
    '🇹🇳 Tunisie',
    '🇿🇲 Zambie',
    '🇿🇼 Zimbabwe',
  ];

  /// Récupère le drapeau emoji correspondant à un pays (avec ou sans drapeau déjà présent)
  static String getFlag(String? countryName) {
    if (countryName == null || countryName.trim().isEmpty) return '';

    // Si le nom contient déjà un drapeau emoji (caractères régionaux ou map lookup)
    for (final entry in countryFlags.entries) {
      if (countryName.contains(entry.key) || countryName.contains(entry.value)) {
        return entry.value;
      }
    }
    return '';
  }

  /// Nettoie le nom du pays en retirant l'émoji du drapeau si présent
  static String cleanCountryName(String? countryName) {
    if (countryName == null || countryName.trim().isEmpty) return '';
    var cleaned = countryName.trim();
    for (final flag in countryFlags.values) {
      cleaned = cleaned.replaceAll(flag, '').trim();
    }
    return cleaned;
  }

  /// Formate un nom de pays pour toujours inclure son drapeau (ex: "🇨🇩 Congo-Kinshasa" ou "Congo-Kinshasa 🇨🇩" si [flagAtEnd] est vrai)
  static String formatWithFlag(String? countryName, {bool flagAtEnd = false}) {
    if (countryName == null || countryName.trim().isEmpty) return '';
    final cleaned = cleanCountryName(countryName);
    final flag = getFlag(countryName);
    if (flag.isNotEmpty) {
      return flagAtEnd ? '$cleaned $flag' : '$flag $cleaned';
    }
    return cleaned;
  }

  /// Trouve l'élément correspondant dans [africanCountries]
  static String? matchCountryWithFlag(String? countryName) {
    if (countryName == null || countryName.trim().isEmpty) return null;
    final cleaned = cleanCountryName(countryName).toLowerCase();
    for (final country in africanCountries) {
      if (cleanCountryName(country).toLowerCase() == cleaned ||
          country.toLowerCase().contains(cleaned)) {
        return country;
      }
    }
    return countryName;
  }
}
