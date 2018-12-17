class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action :is_admin?, except: [:index, :show]

  def index
    if (params[:category].blank? && params[:term].blank?)
      @books = Book.paginate(page: params[:page], per_page: 15).all.order("created_at DESC")
    end
    if params[:category]
      @category_id = Category.find_by(name: params[:category]).id
      @books = Book.paginate(page: params[:page], per_page: 15).where(category_id: @category_id).order("created_at DESC")
    end
    if params[:term]
      @books = Book.paginate(page: params[:page], per_page: 15).title_like(params[:term])
    end
  end

  def new
    @book = current_user.books.build
    @categories = Category.all.map{|c| [c.name, c.id]}
  end

  def show
    if @book.reviews.blank?
      @average_review = 0
    else
      @average_review = @book.reviews.average(:rating).round(2)
    end
  end

  def create
    @book = current_user.books.build(book_params)
    @book.category_id = params[:category_id]
    if @book.save
      flash[:success] = "Successfully"
      redirect_to root_path
    else
      flash[:danger] = "We're sorry. Something wrong, you should try again"
      render "new"
    end
  end

  def edit
    @categories = Category.all.map{|c| [c.name, c.id]}
  end

  def update
    @book.category_id = params[:category_id]
    if @book.update(book_params)
      flash[:success] = "Successfully"
      redirect_to book_path(@book)
    else
      flash[:danger] = "We're sorry. Something wrong, you should try again"
      render "edit"
    end
  end

  def destroy
    if @book.destroy
      flash[:success] = "Successfully"
      redirect_to root_path
    else
      flash[:danger] = "We're sorry. Something wrong, you should try again"
      redirect_to root_path
    end
  end

  private

    def book_params
      params.require(:book).permit(:title, :description, :author, :category_id, :book_img)
    end

    def find_book
      @book = Book.find_by(id: params[:id])
      unless @book
        flash[:danger] = "We can't find this book, you should try later"
        redirect_to root_path
      end
    end
end
