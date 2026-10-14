package tj

var language string

func SetLanguage(lang string) {
	language = lang
}

func Language() string {
	return language
}

func IsLanguageOpen(langs []string) bool {
	for _, openLang := range langs {
		if language == openLang {
			return true
		}
	}
	return false
}
