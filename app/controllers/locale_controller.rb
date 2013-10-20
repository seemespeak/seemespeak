class LocaleController < ApplicationController
  def change
    session[:locale] = params[:locale]
    redirect_to :back
  end
end
