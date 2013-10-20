class ReviewsController < ApplicationController
  before_action :authenticate

  # GET /reviews
  # GET /reviews.json
  def index
    @entries = Entry.get("kDFk_kTQRgqBB2DEFhkQuA")
  end

# # GET /reviews/1
# # GET /reviews/1.json
# def show
# end

# # GET /reviews/new
# def new
#   @review = Review.new
# end

# # GET /reviews/1/edit
# def edit
# end

# # POST /reviews
# # POST /reviews.json
# def create
#   @review = Review.new(review_params)

#   respond_to do |format|
#     if @review.save
#       format.html { redirect_to @review, notice: 'Review was successfully created.' }
#       format.json { render action: 'show', status: :created, location: @review }
#     else
#       format.html { render action: 'new' }
#       format.json { render json: @review.errors, status: :unprocessable_entity }
#     end
#   end
# end

# # PATCH/PUT /reviews/1
# # PATCH/PUT /reviews/1.json
# def update
#   respond_to do |format|
#     if @review.update(review_params)
#       format.html { redirect_to @review, notice: 'Review was successfully updated.' }
#       format.json { head :no_content }
#     else
#       format.html { render action: 'edit' }
#       format.json { render json: @review.errors, status: :unprocessable_entity }
#     end
#   end
# end

# # DELETE /reviews/1
# # DELETE /reviews/1.json
# def destroy
#   @review.destroy
#   respond_to do |format|
#     format.html { redirect_to reviews_url }
#     format.json { head :no_content }
#   end
# end

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
