class EntrySeed


  # some words
  def self.words
    %w[
        homelikeness
        nontractable
        remediate
        diffusibly
        brawnier
        perilune
        teaching
        cartularies
        mesothelia
        discharge
        indifferentist
        carbene
        disapprobation
        autopsical
        pyridine
        raspings
        suharto
        fleuron
        nucleolar
        instructorless
        combings
        schematism
        pratincolous
        formalised
        botchiest
        pip
        clangorous
        unautistic
        cockcrow
        conformation
        prohibition
        unvolitional
        nonsuccessful
        egesta
        desai
        squilgeeing
        indestructible
        cobbett
        unperused
        stethoscoped
        unelaborate
        tomography
        haole
        mispropose
        staglike
        reweaken
        unmusical
        ostium
        neritic
    ]
  end


  # seed entries
  def self.seed_entries
    puts ""
    puts "----------------------------------------------------------------------------------------"
    puts "------------------------------------ Creating Seed Entries -----------------------------"
    puts "----------------------------------------------------------------------------------------"

    random_boolean  = [true, false].sample
    random_flag     = Entry::ALLOWED_FLAGS.sample
    random_language = Entry::ALLOWED_LANGUAGES.sample
    random_dialect  = ["Hamburg", "Freiburg", "Berlin"].sample

    EntrySeed.words.each do |word|
      entry_hash = { 
      	             :transcription => word, 
                     :flags         => [random_flag], 
                     :reviewed      => true, 
                     :language      => random_language, 
                     :dialect       => random_dialect
                   }
      entry = Entry.new(entry_hash)
      entry.index
    end
  end
  
end
