require 'entry_seed'

namespace :seed do
  desc "seed entries to the database"
  task :entries => :environment do
    EntrySeed.seed_entries
  end
end
