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
    sorting_parameters = params[:sort] || session[:sort]
    @all_ratings = possible_ratings
    @ratings_selected = params[:ratings] || session[:ratings] || Hash.empty
    if @ratings_selected == {}
      @selected_ratings = Hash[@all_ratings.collect {|x| [x,x]}]
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = sorting_parameters
      flash.keep
      redirect_to :sort => sorting_parameters, :ratings => @ratings_selected and return
    end
    
    if params[:ratings] != session[:ratings] and @ratings_selected != {}
      session[:sort] = sorting_parameters
      session[:ratings] = @ratings_selected
      flash.keep
      redirect_to :sort => sorting_parameters, :ratings => @ratings_selected and return
    end
    
    if params[:ratings].present?
      @movies = Movie.where(rating: @ratings_selected.keys).order(sorting_parameters)
    else
      @movies = Movie.order(params[:sort])
    end
    
  end
  
  def possible_ratings
    ['G','PG','PG-13','R']
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
