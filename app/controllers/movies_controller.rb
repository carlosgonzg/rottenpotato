class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	#Setting Variables
	#session.clear
	#session[:ratings] = nil
	#session[:sort_t] = nil
	#session[:sort_r] = nil
	
	#Session load
	s_hash = {}
	if(session[:ratings]!=nil || session[:sort_t]!=nil || session[:sort_r]!=nil) then
		s_hash[:ratings] = (params[:ratings]==nil)? session[:ratings] : params[:ratings]
		s_hash[:title_sort] = (params[:title_sort] !=nil && session[:release_sort]!=nil) ? params[:title_sort] : session[:sort_t]
		s_hash[:release_sort] = (params[:release_sort] !=nil && session[:title_sort]!=nil) ? params[:release_sort] : session[:sort_r]
		session.delete(:ratings)
		session.delete(:sort_t)
		session.delete(:sort_r)
		if(session[:toggle] == nil) then
			session[:toggle] = true
			flash.keep
			redirect_to movies_path(s_hash)
		else
			session.delete(:toggle)
		end
	end
	
	#Setting Variables
	p_rating = (params[:ratings]==nil)? s_hash[:ratings] : params[:ratings]
	p_title_sort = (params[:title_sort]==nil)? s_hash[:title_sort] : params[:title_sort]
	p_release_sort = (params[:release_sort]==nil)? s_hash[:release_sort] : params[:release_sort]

	
	@all_ratings = Movie.get_all_ratings
	filtered = "1 = 1"
	@ratingsHash = {}
	@all_ratings.each do |value|
		@ratingsHash[value] = false
	end
	#Filtering by Rating
	if(p_rating != nil) then
		ratings = p_rating
		ratingsArray = []
		ratings.each do |rating|
			ratingsArray << rating[0]
		end
		filtered = ["rating IN (?)",ratingsArray]
		ratingsArray.each do |ratArray|
			@ratingsHash[ratArray] = true
		end
		session[:ratings] = p_rating
	end
	if(params[:commit].to_s == "Refresh" && p_rating == nil) then
		filtered = "1 = 1"
		@all_ratings.each do |value|
			@ratingsHash[value] = false
		end
	end
	#Sorting ASC by release_Date
	order = ""
	@hilite = {}

	if(p_release_sort != nil) then
		order += "release_date"
		@hilite[:r] = "hilite"
		session[:sort_r] = true
		session[:sort_t] = nil
	elsif(p_title_sort != nil) then
		order += "title"
		@hilite[:t] = "hilite"
		session[:sort_r] = nil
		session[:sort_t] = true
	end

	if(order=="") then
		@movies = Movie.find(:all,:conditions => filtered)
	else
		@movies = Movie.find(:all,:order=>order,:conditions => filtered)
	end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
	flash.keep
    redirect_to movies_path(:title_sort => session[:sort_t], :release_sort => session[:sort_r], :ratings => session[:ratings])
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
	flash.keep
    redirect_to movies_path(:title_sort => session[:sort_t], :release_sort => session[:sort_r], :ratings => session[:ratings])
  end

end
