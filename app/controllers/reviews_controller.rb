class ReviewsController < ApplicationController
  before_action :authenticate
  before_action :set_entry, only: [:show, :edit, :update, :destroy, :mark_as_moderated]

  # GET /reviews
  # GET /reviews.json
  def index
    @entries = Entry.search(:reviewed => false, :from => (params[:from] || 0), :ignored_flags => [])
  end

  # # GET /reviews/1
  # # GET /reviews/1.json
  def show
    respond_to do |format|
      format.html { render action: "show" }
      format.js   { render "show.html.js" }
    end
  end

  def edit
  end

  def update
  end

  def update
    @entry.attributes = @entry.attributes.merge(params[:entry])
    @entry.index
    respond_to do |format|
      if [@entry.valid?, @entry.copyright.valid?].all?
        format.html { redirect_to reviews_path, notice: 'Entry was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to reviews_path }
    end
  end

  # marks entry as 'moderated'.
  def mark_as_moderated
    @entry.reviewed = true

    if @entry.index
      redirect_to reviews_path, :notice => "Video has been successfully marked as 'moderated'."
    else
      redirect_to reviews_path, :alert => "Video could not been marked as 'moderated'."
    end
  end

  private

  def set_entry
    @entry = Entry.get(params[:id])
  end

  # authenticate via http basic.
  def authenticate
    user = AdminSettings[:user]
    pass = AdminSettings[:password]
    authenticate_or_request_with_http_basic do |username, password|
      username == user && password == pass
    end
  end

end
