class VideosController < ApplicationController
  include TorqueBox::Messaging::Backgroundable

  always_background :background_method

  def index
    self.class.background_method(rand(100000))
  end

  def self.background_method(int)
    20.times do
      sleep 1
      Rails.logger.debug("background #{int}!!")
    end
  end

  def new
  end
end
