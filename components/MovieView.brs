sub init()
    m.statusLabel = m.top.findNode("statusLabel")
    m.movieGrid = m.top.findNode("movieGrid")
    
    ' Observe API key field
    m.top.observeField("tmdbApiKey", "onApiKeySet")
end sub

sub onApiKeySet()
    apiKey = m.top.tmdbApiKey
    if apiKey <> invalid and apiKey <> "" and apiKey <> "YOUR_TMDB_API_KEY_HERE"
        loadMovies()
    else
        m.statusLabel.text = "TMDB API key not configured. Please set up config.brs"
    end if
end sub

sub loadMovies()
    m.statusLabel.text = "Fetching popular movies from TMDB..."
    
    ' Get API key
    apiKey = m.top.tmdbApiKey
    
    ' Fetch popular movies from TMDB
    moviesData = TMDBGetPopularMovies(apiKey, 1)
    
    if moviesData = invalid or moviesData.results = invalid
        m.statusLabel.text = "Failed to load movies. Check your API key."
        return
    end if
    
    ' Create content node for grid
    content = CreateObject("roSGNode", "ContentNode")
    
    ' Add movies to content
    for each movie in moviesData.results
        item = content.createChild("ContentNode")
        item.title = movie.title
        
        ' Set poster URL if available
        if movie.poster_path <> invalid and movie.poster_path <> ""
            item.hdPosterUrl = TMDBGetImageUrl(movie.poster_path, "w500")
            item.sdPosterUrl = TMDBGetImageUrl(movie.poster_path, "w342")
        end if
        
        ' Store additional metadata
        if movie.overview <> invalid
            item.description = movie.overview
        end if
        
        if movie.release_date <> invalid
            item.releaseDate = movie.release_date
        end if
        
        if movie.vote_average <> invalid
            item.starRating = movie.vote_average * 10 ' Convert to 0-100 scale
        end if
    end for
    
    ' Set content to grid
    m.movieGrid.content = content
    m.movieGrid.visible = true
    
    ' Update status
    movieCount = moviesData.results.count()
    m.statusLabel.text = "Showing " + movieCount.toStr() + " popular movies"
end sub
