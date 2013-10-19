class WelcomeController < ApplicationController

  def index
    @random_entry = Entry.search(random: Random.rand(1..10000)).first
  end

end
