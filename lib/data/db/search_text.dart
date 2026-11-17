/// Search key for names: lower-case, Vietnamese diacritics removed and `đ`
/// → `d`, whitespace collapsed — so "ruong" finds "Ruộng Nhà Ông Tư".
/// Stored in `measurements.name_lower`; queries are folded the same way.
String foldForSearch(String input) {
  final lower = input.toLowerCase().trim();
  final out = StringBuffer();
  var lastWasSpace = false;
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    if (ch.trim().isEmpty) {
      if (!lastWasSpace && out.isNotEmpty) out.write(' ');
      lastWasSpace = true;
      continue;
    }
    lastWasSpace = false;
    out.write(_fold[ch] ?? ch);
  }
  return out.toString();
}

final Map<String, String> _fold = () {
  const groups = {
    'a': 'àáảãạăằắẳẵặâầấẩẫậ',
    'e': 'èéẻẽẹêềếểễệ',
    'i': 'ìíỉĩị',
    'o': 'òóỏõọôồốổỗộơờớởỡợ',
    'u': 'ùúủũụưừứửữự',
    'y': 'ỳýỷỹỵ',
    'd': 'đ',
  };
  return {
    for (final e in groups.entries)
      for (final c in e.value.split('')) c: e.key,
  };
}();
