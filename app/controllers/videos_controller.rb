class VideosController < ApplicationController
  include TorqueBox::Messaging::Backgroundable

  always_background :background_method

  def index
    @entries = Entry.search(:transcription => params[:transcription])
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(params[:entry])
    redirect_to videos_path
  end

  def self.background_method(int)
    20.times do
      sleep 1
      Rails.logger.debug("background #{int}!!")
    end
  end
end
