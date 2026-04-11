sub init()
    m.nav = m.top.findNode("nav")
    m.contentHost = m.top.findNode("contentHost")

    ' Put your M3U URL here (or set m3uUrl from elsewhere later)
    if m.top.m3uUrl = invalid or m.top.m3uUrl = "" then
        ' EXAMPLE PLACEHOLDER (change this to your real playlist URL)
                m.top.m3uUrl = GetM3UUrl()  ' From source/config.brs
    end if
    
    ' Get TMDB backend URL from config
    m.tmdbBackendUrl = GetTMDBBackendUrl()

    buildNav()
    m.nav.observeField("itemSelected", "onNavSelected")

    showView("load")
end sub

sub buildNav()
    items = CreateObject("roSGNode", "ContentNode")

    addNav(items, "Load Zone", "load")
    addNav(items, "Live TV", "live")
    addNav(items, "Guide", "guide")
    addNav(items, "Movies", "movies")
    addNav(items, "Settings", "settings")

    m.nav.content = items
    m.nav.itemSelected = 0
end sub

sub addNav(parent as object, title as string, id as string)
    n = CreateObject("roSGNode", "ContentNode")
    n.title = title
    n.id = id
    parent.appendChild(n)
end sub

sub onNavSelected()
    idx = m.nav.itemSelected
    if idx < 0 then return

    node = m.nav.content.getChild(idx)
    if node = invalid then return

    showView(node.id)
end sub

sub clearHost()
    if m.contentHost.getChildCount() > 0
        m.contentHost.removeChildrenIndex(0, m.contentHost.getChildCount())
    end if
end sub

sub showView(viewId as string)
    clearHost()

    view = invalid

    if viewId = "load"
        view = CreateObject("roSGNode", "LoadZoneView")
    else if viewId = "live"
        view = CreateObject("roSGNode", "ChannelsView")
        view.m3uUrl = m.top.m3uUrl
    else if viewId = "guide"
        view = CreateObject("roSGNode", "GuideView")
    else if viewId = "movies"
        view = CreateObject("roSGNode", "MovieView")
        view.tmdbBackendUrl = m.tmdbBackendUrl
    else if viewId = "settings"
        view = CreateObject("roSGNode", "SettingsScene")
    else
        view = CreateObject("roSGNode", "LoadZoneView")
    end if

    m.contentHost.appendChild(view)
end sub
