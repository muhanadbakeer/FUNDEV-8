import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  Locale? selectedLocale;
  bool _loadedOnce = false;

  final List<_LangItem> languages = [
    _LangItem('العربية', 'ar', '🇸🇦'),
    _LangItem('English', 'en', '🇺🇸'),
    _LangItem('Español', 'es', '🇪🇸'),
    _LangItem('Français', 'fr', '🇫🇷'),
    _LangItem('Deutsch', 'de', '🇩🇪'),
    _LangItem('Italiano', 'it', '🇮🇹'),
    _LangItem('Türkçe', 'tr', '🇹🇷'),
    _LangItem('Русский', 'ru', '🇷🇺'),
    _LangItem('简体中文', 'zh', '🇨🇳'),
    _LangItem('日本語', 'ja', '🇯🇵'),
    _LangItem('한국어', 'ko', '🇰🇷'),
    _LangItem('Português', 'pt', '🇵🇹'),
    _LangItem('Bahasa Indonesia', 'id', '🇮🇩'),
    _LangItem('Bahasa Melayu', 'ms', '🇲🇾'),
    _LangItem('हिंदी', 'hi', '🇮🇳'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ أول مرة فقط: خذ اللغة الحالية من EasyLocalization
    if (!_loadedOnce) {
      selectedLocale = context.locale;
      _loadedOnce = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = selectedLocale ?? context.locale;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text('language.title'.tr()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: languages.length,
              itemBuilder: (context, i) {
                final item = languages[i];
                final isSelected = current.languageCode == item.code;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      selectedLocale = Locale(item.code);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(item.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  final chosen = selectedLocale ?? context.locale;
                  await context.setLocale(chosen);
                  if (mounted) Navigator.pop(context);
                },
                child: Text(
                  'apply'.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangItem {
  final String name;
  final String code;
  final String flag;
  _LangItem(this.name, this.code, this.flag);
}
