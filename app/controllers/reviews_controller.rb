class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :find_book
  before_action :find_review, only: [:edit, :update, :destroy]

  def new
    @review = Review.new
  end

  def create
    if review_params[:comment].blank?
      flash[:danger] = "Comment shouldn't be blank"
      redirect_to new_book_review_path(@book)
      return
    end
    if (review_params[:rating].to_i < 1 or review_params[:rating].to_i > 5)
      flash[:danger] = "Rating should minimum is one star and maximum is five star"
      redirect_to new_book_review_path(@book)
      return
    end
    @review = Review.new(review_params)
    @review.book_id = @book.id
    @review.user_id = current_user.id
    if @review.save
      flash[:success] = "Successfully"
      redirect_to book_path(@book)
    else
      flash[:danger] = "We're sorry. Something wrong, you should try again"
      render "new"
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:success] = "Successfully"
      redirect_to book_path(@book)
    else
      flash[:danger] = "We're sorry. Something wrong, you should try again"
      render "edit"
    end
  end

  def destroy
    if @review.destroy
      flash[:success] = "Successfully"
      redirect_to book_path(@book)
    else
      flash[:danger] = "We're sorry. Something wrong, you should try again"
      redirect_to book_path(@book)
    end
  end

  private

    def review_params
      params.require(:review).permit(:rating, :comment)
    end

    def find_book
      @book = Book.find_by(id: params[:book_id])
      unless @book
        flash[:danger] = "We can't find this book, you should try later"
        redirect_to root_path
      end
    end

    def find_review
      @review = Review.find_by(id: params[:id])
      unless @book
        flash[:danger] = "We can't find this review, you should try later"
        redirect_to book_path(@book)
      end
    end

    def is_current_user_review?
      unless @review.user_id == current_user.id
        flash[:danger] = "Oops!! You don't have privilege to to this action"
        redirect_to book_path(@book)
      end
    end
end
