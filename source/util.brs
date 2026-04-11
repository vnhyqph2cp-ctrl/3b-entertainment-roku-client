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

' TMDB Backend helper functions
' Uses a backend service to fetch TMDB data (keeps API key secure on server)
function TMDBGetPopularMovies(backendUrl as string, page = 1 as integer) as object
    if backendUrl = invalid or backendUrl = "" then
        return invalid
    end if
    
    ' Call backend service endpoint for popular movies
    url = backendUrl + "/popular?page=" + page.ToStr()
    response = HttpGet(url)
    
    if response = "" then return invalid
    
    json = ParseJson(response)
    return json
end function

function TMDBGetImageUrl(posterPath as string, size = "w500" as string) as string
    if posterPath = invalid or posterPath = "" then return ""
    return "https://image.tmdb.org/t/p/" + size + posterPath
end function
