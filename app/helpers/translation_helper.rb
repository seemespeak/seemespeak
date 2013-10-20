module TranslationHelper
  MAPPING = {
    "DGS" => :de,
    "ASL" => :en,
    "BSL" => :en
  }

  # translate a word to the current locale using a sing language symbol as input
  def sign_translate(entry)
    sign_language = entry.language
    phrase = entry.transcription
    translate_to = MAPPING[sign_language]
    if translate_to != I18n.locale
      translated = translator.translate(phrase, from: MAPPING[sign_language], to: I18n.locale)
      (phrase + " (#{translated})").html_safe
    else
      phrase.html_safe
    end
  end

  def translator
    BingTranslator.new('seemespeak', 'jZBvTNnFypYWLO9McTfQPdQd6FojYfF6jHwQLiFYlN8=')
  end
end
