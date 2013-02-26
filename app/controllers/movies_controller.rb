class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@sort = {}
	@all_ratings = Movie.get_all_ratings
	filtered = "1 = 1"
	@ratingsHash = {}
	@all_ratings.each do |value|
		@ratingsHash[value] = false
	end
	
	if(params[:ratings] != nil) then
		ratings = params[:ratings]
		ratingsArray = []
		ratings.each do |rating|
			ratingsArray << rating[0]
		end
    	filtered = ["rating IN (?)",ratingsArray]
		ratingsArray.each do |ratArray|
			@ratingsHash[ratArray] = true
		end
	end
    if(params[:release_sort] != nil) then
		@hilite = {:r=>"hilite",:t=>"none"}
		@sort[:t] = "asc"
		if(params[:release_sort] == "asc") then
			@sort[:r] = "desc"
			@movies = Movie.find(:all,:order=>"release_date",:conditions => filtered)
		else
			@sort[:r] = "asc"
			@movies = Movie.find(:all,:order=>"release_date DESC",:conditions => filtered)
		end
    elsif(params[:title_sort] != nil) then
		@hilite = {:r=>"none",:t=>"hilite"}
		@sort[:r] = "asc"
		if(params[:title_sort] == "asc") then
			@sort[:t] = "desc"
			@movies = Movie.find(:all,:order=>"title",:conditions => filtered)
		else
			@sort[:t] = "asc"
			@movies = Movie.find(:all,:order=>"title DESC",:conditions => filtered)
		end		
    else
		@hilite = {:r=>"none",:t=>"none"}
 		@sort[:t] = "asc"
		@sort[:r] = "asc"
        @movies = Movie.find(:all,:conditions => filtered)
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
