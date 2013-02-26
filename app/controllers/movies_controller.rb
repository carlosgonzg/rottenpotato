class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@sort = {}
    puts params[:release_sort] 
    if(params[:release_sort] != nil) then
		@hilite = {:r=>"hilite",:t=>"none"}
		@sort[:t] = "asc"
		if(params[:release_sort] == "asc") then
			@sort[:r] = "desc"
			@movies = Movie.order("release_date").all
		else
			@sort[:r] = "asc"
			@movies = Movie.order("release_date DESC").all
		end
    elsif(params[:title_sort] != nil) then
		@hilite = {:r=>"none",:t=>"hilite"}
		@sort[:r] = "asc"
		if(params[:title_sort] == "asc") then
			@sort[:t] = "desc"
			@movies = Movie.order("title").all
		else
			@sort[:t] = "asc"
			@movies = Movie.order("title DESC").all
		end		
    else
		@hilite = {:r=>"none",:t=>"none"}
 		@sort[:t] = "asc"
		@sort[:r] = "asc"
        @movies = Movie.all
    end
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
