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
