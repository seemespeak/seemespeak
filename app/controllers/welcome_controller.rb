class WelcomeController < ApplicationController

  def index
    flash[:notice] = t(:upload_success) if params[:upload] == "success"
    @random_entry = Entry.search(random: Random.rand(1..10000)).first
  end

end
