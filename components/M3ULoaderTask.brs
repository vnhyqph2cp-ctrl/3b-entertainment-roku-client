' Uses source/util.brs HttpGet()

sub init()
    m.top.items = []
    m.top.error = ""
end sub

sub main()
    url = m.top.url
    if url = invalid or url = "" then
        m.top.error = "Missing M3U URL"
        return
    end if

    data = HttpGet(url)
    if data = "" then
        m.top.error = "Empty response (check URL / network)"
        return
    end if

    m.top.items = parseM3U(data)
end sub

function parseM3U(text as string) as object
    items = []
    lines = text.split(chr(10))

    lastTitle = ""
    for each rawLine in lines
        line = rawLine.trim()
        if line = "" then
            ' skip
        else if left(line, 7) = "#EXTINF"
            ' crude title parse: after comma
            commaPos = instr(1, line, ",")
            if commaPos > 0
                lastTitle = mid(line, commaPos + 1)
            else
                lastTitle = "Channel"
            end if
        else if left(line, 1) = "#"
            ' ignore other tags
        else
            ' URL line
            if lastTitle = "" then lastTitle = "Channel"
            items.push({
                title: lastTitle
                url: line
            })
            lastTitle = ""
        end if
    end for

    return items
end function
