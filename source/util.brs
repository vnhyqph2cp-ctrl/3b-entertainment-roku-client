' util.brs (safe helpers)

function SafeStr(v as dynamic) as string
    if v = invalid then return ""
    return v.ToStr()
end function

function HttpGet(url as string, timeoutMs = 8000 as integer) as string
    if url = invalid or url = "" then return ""

    xfer = CreateObject("roUrlTransfer")
    xfer.SetUrl(url)
    xfer.SetRequest("GET")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.InitClientCertificates()
    xfer.EnableEncodings(true)
    xfer.SetTimeout(timeoutMs)

    rsp = xfer.GetToString()
    if rsp = invalid then return ""
    return rsp
end function

' TMDB API helper functions
function TMDBGetPopularMovies(apiKey as string, page = 1 as integer) as object
    if apiKey = invalid or apiKey = "" or apiKey = "YOUR_TMDB_API_KEY_HERE" then
        return invalid
    end if
    
    url = "https://api.themoviedb.org/3/movie/popular?api_key=" + apiKey + "&page=" + page.ToStr()
    response = HttpGet(url)
    
    if response = "" then return invalid
    
    json = ParseJson(response)
    return json
end function

function TMDBGetImageUrl(posterPath as string, size = "w500" as string) as string
    if posterPath = invalid or posterPath = "" then return ""
    return "https://image.tmdb.org/t/p/" + size + posterPath
end function
