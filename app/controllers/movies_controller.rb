class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    redirect = false
    
    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif
      redirect = true
      @ratings = session[:ratings]
    end
    
    if params[:category]
      @category = params[:category]
      session[:category] = params[:category]
    elsif
      redirect = true
      @category = session[:category]
    end

    if redirect
      flash.keep
    end

#    if !@ratings and params[:commit] == "Refresh"
#        @ratings = Hash.new
#        @all_ratings.each do |rating|
#          @ratings[rating] = 0
#    end
    if !@ratings and params[:commit] != "Refresh"
      @ratings = Hash.new
      @all_ratings.each do |rating|
         @ratings[rating] = 1
       end
    end
    
    if @category and @ratings
      @movies = Movie.where(:rating => @ratings.keys).order(@category)
    elsif @ratings
      @movies = Movie.where(:rating => @ratings.keys)
    elsif @category
      @movies = Movie.order(@category)
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
