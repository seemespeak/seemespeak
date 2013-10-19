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

    random_boolean = [true, false]
    random_tag     = ["insult"]
    random_flag    = ["insult"]
    random_dialect = ["Hamburg", "Freiburg", "Berlin"]

    EntrySeed.words.each do |word|
      entry_hash = { 
      	             :transcription => word, 
                     :tags          => random_tag.sample, 
                     :flags         => random_flag.sample, 
                     :reviewed      => random_boolean.sample, 
                     :language      => "EN", 
                     :dialect       => random_dialect.sample
                   }
      entry = Entry.new(entry_hash)
      entry.index
    end
  end
  
end