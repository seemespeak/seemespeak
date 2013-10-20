module TranslationHelper
  MAPPING = {
    "DGS" => "de",
    "ASL" => "en",
    "BSL" => "en"
  }

  # translate a word to the current locale using a sing language symbol as input
  def sign_translate(word, sign_language)
    translator.translate(word, from: MAPPING[sign_language], to: I18n.locale)
  end

  def translator
    BingTranslator.new('seemespeak', 'jZBvTNnFypYWLO9McTfQPdQd6FojYfF6jHwQLiFYlN8=')
  end
end
