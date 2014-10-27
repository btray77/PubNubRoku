REM *************************************************
REM ** (C) 2012-2014 Brad Traynham 
REM ** ALL RIGHTS RESERVED.  MIT Licnese
REM *************************************************

sub Main()
    'obj = {}
    'obj.text = "hello world!!!"
    'obj.text2 = "hello world!fdgdf"
    request = PubNub("Your Publish Key", "Your Subscribe Key")
    'req = request.publish("chat", obj)
    'if isbool(req) and req = false
    '    print "NO!"
    'else
    '    print req
    'end if
    
    g = GetGlobals()
    
    g.chatWindow = CreateObject("roTextScreen")
    g.chatWindow.SetTitle("Chat Room")
    g.chatWindow.Show()
    
    prec = request.presence("chat")
    
    print prec
    
    for each id in prec["uuids"]
        print id
    endfor
    
    print prec["occupancy"]
    
    subscr = request.subscribe("chat", printResult)
end sub

Function printResult(result)
    g = GetGlobals()
    for each item in result
        g.chatWindow.AddText(item["user"] + ":" + item["message"])
    endfor
end Function

Function GetGlobals() As Object
    if m.Globals = invalid then m.Globals = {}
    Return m.Globals
End Function