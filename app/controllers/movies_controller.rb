class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    @all_ratings = Movie.ratings
    @sort_by = params[:sort_by]
    @checked_ratings = params[:ratings] ? params[:ratings] : {}
    selected_ratings = @checked_ratings.keys

    # redirect if session has sort_by or ratings settings but params don't
    if ! params[:sort_by] and session[:sort_by] then
      redirect = true
      sort_by = session[:sort_by]
    else
      sort_by = params[:sort_by]
    end
    if ! params[:ratings] and session[:ratings] then
      redirect = true
      ratings = session[:ratings]
    else
      ratings = params[:ratings]
    end

    if redirect then
      flash.keep
      redirect_to movies_path :sort_by => sort_by, :ratings => ratings
    end

    if params[:sort_by] then
      session[:sort_by] = params[:sort_by]
    end
    if params[:ratings] then
      session[:ratings] = params[:ratings]
    end

    @movies = Movie.find_all_by_rating(selected_ratings, {:order => @sort_by})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
