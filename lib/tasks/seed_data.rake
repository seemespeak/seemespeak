require 'entry_seed'

namespace :seed do
  task :entries => :environment do
    EntrySeed.seed_entries
  end
end