class ReviewsController < ApplicationController
  before_action :authenticate

  # GET /reviews
  # GET /reviews.json
  def index
    @entries = Entry.search(:reviewed => false)
  end

# # GET /reviews/1
# # GET /reviews/1.json
def show
  @entry = Entry.get(params[:id])
  
  respond_to do |format|
    format.html { render action: "show" }
    format.js   { render "show.html.js" }
  end
end

# marks entry as 'moderated'.
def mark_as_moderated

  entry = Entry.get(params[:id])

  entry.reviewed = true
  
  if entry.index
    redirect_to reviews_path, :notice => "Video has been successfully marked as 'modereated'."
  else
    redirect_to reviews_path, :alert => "Video could not been marked as 'modereated'."
  end
end

private

  # authenticate via http basic.
  def authenticate
    user = AdminSettings[:user]
    pass = AdminSettings[:password]
    authenticate_or_request_with_http_basic do |username, password|
      username == user && password == pass
    end 
  end

end
