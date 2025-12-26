sub init()
    print "MainScene init"

    m.host = m.top.findNode("host")
    m.nav  = m.top.findNode("nav")

    if m.host = invalid then print "HOST INVALID"
    if m.nav = invalid then print "NAV INVALID"

    m.nav.observeField("itemSelected", "onSelect")
    m.nav.setFocus(true)
end sub

sub onSelect()
    print "NAV CLICKED"

    m.host.removeChildrenIndex(0, m.host.getChildCount())

    test = CreateObject("roSGNode", "ChannelsView")
    if test = invalid then
        print "FAILED TO CREATE ChannelsView"
        return
    end if

    m.host.appendChild(test)
    print "ChannelsView appended"
end sub
