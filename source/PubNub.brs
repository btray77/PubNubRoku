REM *************************************************
REM ** (C) 2012-2014 Brad Traynham 
REM ** ALL RIGHTS RESERVED.  MIT Licnese
REM *************************************************

REM ******************************************************
REM JSON output
REM ******************************************************
Function SimpleJSONBuilder( jsonArray As Object ) As String
    Return SimpleJSONAssociativeArray( jsonArray )
End Function


Function SimpleJSONAssociativeArray( jsonArray As Object ) As String
    jsonString = "{"
    
    For Each key in jsonArray
        jsonString = jsonString + Chr(34) + key + Chr(34) + ":"
        value = jsonArray[ key ]
        If Type( value ) = "roString" Then
            jsonString = jsonString + Chr(34) + value + Chr(34)
        Else If Type( value ) = "roInt" Or Type( value ) = "roFloat" Then
            jsonString = jsonString + value.ToStr()
        Else If Type( value ) = "roBoolean" Then
            jsonString = jsonString + IIf( value, "true", "false" )
        Else If Type( value ) = "roArray" Then
            jsonString = jsonString + SimpleJSONArray( value )
        Else If Type( value ) = "roAssociativeArray" Then
            jsonString = jsonString + SimpleJSONBuilder( value )
        End If
        jsonString = jsonString + ","
    Next
    If Right( jsonString, 1 ) = "," Then
        jsonString = Left( jsonString, Len( jsonString ) - 1 )
    End If
    
    jsonString = jsonString + "}"
    Return jsonString
End Function


Function SimpleJSONArray( jsonArray As Object ) As String
    jsonString = "["
    
    For Each value in jsonArray
        If Type( value ) = "roString" Then
            jsonString = jsonString + Chr(34) + value + Chr(34)
        Else If Type( value ) = "roInt" Or Type( value ) = "roFloat" Then
            jsonString = jsonString + value.ToStr()
        Else If Type( value ) = "roBoolean" Then
            jsonString = jsonString + IIf( value, "true", "false" )
        Else If Type( value ) = "roArray" Then
            jsonString = jsonString + SimpleJSONArray( value )
        Else If Type( value ) = "roAssociativeArray" Then
            jsonString = jsonString + SimpleJSONAssociativeArray( value )
        End If
        jsonString = jsonString + ","
    Next
    If Right( jsonString, 1 ) = "," Then
        jsonString = Left( jsonString, Len( jsonString ) - 1 )
    End If
    
    jsonString = jsonString + "]"
    Return jsonString
End Function

'******************************************************
'islist
'
'Determine if the given object supports the ifList interface
'******************************************************
Function islist(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifArray") = invalid return false
    return true
End Function


'******************************************************
'isint
'
'Determine if the given object supports the ifInt interface
'******************************************************
Function isint(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifInt") = invalid return false
    return true
End Function

'******************************************************
' validstr
'
' always return a valid string. if the argument is 
' invalid or not a string, return an empty string
'******************************************************
Function validstr(obj As Dynamic) As String
    if isnonemptystr(obj) return obj
    return ""
End Function 


'******************************************************
'isstr
'
'Determine if the given object supports the ifString interface
'******************************************************
Function isstr(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifString") = invalid return false
    return true
End Function


'******************************************************
'isnonemptystr
'
'Determine if the given object supports the ifString interface
'and returns a string of non zero length
'******************************************************
Function isnonemptystr(obj)
    if isnullorempty(obj) return false
    return true
End Function


'******************************************************
'isnullorempty
'
'Determine if the given object is invalid or supports
'the ifString interface and returns a string of non zero length
'******************************************************
Function isnullorempty(obj)
    if obj = invalid return true
    if not isstr(obj) return true
    if Len(obj) = 0 return true
    return false
End Function


'******************************************************
'isbool
'
'Determine if the given object supports the ifBoolean interface
'******************************************************
Function isbool(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifBoolean") = invalid return false
    return true
End Function


'******************************************************
'isfloat
'
'Determine if the given object supports the ifFloat interface
'******************************************************
Function isfloat(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifFloat") = invalid return false
    return true
End Function


'******************************************************
'strtobool
'
'Convert string to boolean safely. Don't crash
'Looks for certain string values
'******************************************************
Function strtobool(obj As dynamic) As Boolean
    if obj = invalid return false
    if type(obj) <> "roString" return false
    o = strTrim(obj)
    o = Lcase(o)
    if o = "true" return true
    if o = "t" return true
    if o = "y" return true
    if o = "1" return true
    return false
End Function


'******************************************************
'itostr
'
'Convert int to string. This is necessary because
'the builtin Stri(x) prepends whitespace
'******************************************************
Function itostr(i As Integer) As String
    str = Stri(i)
    return strTrim(str)
End Function

'******************************************************
'Trim a string
'******************************************************
Function strTrim(str As String) As String
    st=CreateObject("roString")
    st.SetString(str)
    return st.Trim()
End Function

'******************************************************
'Walk an AA and print it
'******************************************************
Sub PrintAA(aa as Object)
    print "---- AA ----"
    if aa = invalid
        print "invalid"
        return
    else
        cnt = 0
        for each e in aa
            PrintAny(0, e + ": ", aa[e])
            cnt = cnt + 1
        next
        if cnt = 0
            PrintAny(0, "Nothing from for each. Looks like :", aa)
        endif
    endif
    print "------------"
End Sub

'******************************************************
'Walk a list and print it
'******************************************************
Sub PrintList(list as Object)
    print "---- list ----"
    PrintAnyList(0, list)
    print "--------------"
End Sub


'******************************************************
'Print an associativearray
'******************************************************
Sub PrintAnyAA(depth As Integer, aa as Object)
    for each e in aa
        x = aa[e]
        PrintAny(depth, e + ": ", aa[e])
    next
End Sub


'******************************************************
'Print a list with indent depth
'******************************************************
Sub PrintAnyList(depth As Integer, list as Object)
    i = 0
    for each e in list
        PrintAny(depth, "List(" + itostr(i) + ")= ", e)
        i = i + 1
    next
End Sub

'******************************************************
'Print anything
'******************************************************
Sub PrintAny(depth As Integer, prefix As String, any As Dynamic)
    if depth >= 10
        print "**** TOO DEEP " + itostr(5)
        return
    endif
    prefix = string(depth*2," ") + prefix
    depth = depth + 1
    str = AnyToString(any)
    if str <> invalid
        print prefix + str
        return
    endif
    if type(any) = "roAssociativeArray"
        print prefix + "(assocarr)..."
        PrintAnyAA(depth, any)
        return
    endif
    if islist(any) = true
        print prefix + "(list of " + itostr(any.Count()) + ")..."
        PrintAnyList(depth, any)
        return
    endif

    print prefix + "?" + type(any) + "?"
End Sub

'******************************************************
'Print an object as a string for debugging. If it is 
'very long print the first 500 chars.
'******************************************************
Sub Dbg(pre As Dynamic, o=invalid As Dynamic)
    p = AnyToString(pre)
    if p = invalid p = ""
    if o = invalid o = ""
    s = AnyToString(o)
    if s = invalid s = "???: " + type(o)
    if Len(s) > 4000
        s = Left(s, 4000)
    endif
    print p + s
End Sub


'******************************************************
'Try to convert anything to a string. Only works on simple items.
'
'Test with this script...
'
'    s$ = "yo1"
'    ss = "yo2"
'    i% = 111
'    ii = 222
'    f! = 333.333
'    ff = 444.444
'    d# = 555.555
'    dd = 555.555
'    bb = true
'
'    so = CreateObject("roString")
'    so.SetString("strobj")
'    io = CreateObject("roInt")
'    io.SetInt(666)
'    tm = CreateObject("roTimespan")
'
'    Dbg("", s$ ) 'call the Dbg() function which calls AnyToString()
'    Dbg("", ss )
'    Dbg("", "yo3")
'    Dbg("", i% )
'    Dbg("", ii )
'    Dbg("", 2222 )
'    Dbg("", f! )
'    Dbg("", ff )
'    Dbg("", 3333.3333 )
'    Dbg("", d# )
'    Dbg("", dd )
'    Dbg("", so )
'    Dbg("", io )
'    Dbg("", bb )
'    Dbg("", true )
'    Dbg("", tm )
'
'try to convert an object to a string. return invalid if can't
'******************************************************
Function AnyToString(any As Dynamic) As dynamic
    if any = invalid return "invalid"
    if isstr(any) return any
    if isint(any) return itostr(any)
    if isbool(any)
        if any = true return "true"
        return "false"
    endif
    if isfloat(any) return Str(any)
    if type(any) = "roTimespan" return itostr(any.TotalMilliseconds()) + "ms"
    return invalid
End Function

REM ******************************************************
REM Implode array into string
REM ******************************************************
Function implode(glue, pieces)
    result = ""
    for each piece in pieces
        if result <> ""
            result = result + glue
        end if
        result = result + piece
    end for

    return result
end Function

REM ******************************************************
REM Performs Http.AsyncPostFromString() with a single timeout in seconds
REM To the outside world this appears as a synchronous API.
REM ******************************************************
Function http_request(url As String, seconds as Integer)
    timeout% = seconds * 1000
    obj = CreateObject("roUrlTransfer")
    obj.SetPort(CreateObject("roMessagePort"))
    obj.SetUrl(url)
    obj.AddHeader("V: 1", "Accept: */*")

    if (obj.AsyncGetToString())
        event = wait(timeout%, obj.GetPort())
        if type(event) = "roUrlEvent"
            return ParseJSON(event.GetString())
        else if event = invalid
            Dbg("AsyncPostFromString timeout")
            obj.AsyncCancel()
        else
            Dbg("AsyncPostFromString unknown event", event)
        endif
    endif
    
    return false
End Function

REM ******************************************************
REM PubNub Class
REM 
REM Usage
REM pubnub = PubNub({publishKey: "", subscribeKey: ""})
REM
REM pubnub.publish({channel: "", message: roObject})
REM
REM pubnub.subscribe({channel: "", callback: function})
REM   callback function gets first attribute as message
REM   message is run through JSONParse before handing over
REM ******************************************************
Function PubNub(publishKey as String, subscribeKey as String) as Object
    obj                =  CreateObject("roAssociativeArray")
    obj.publishKey     = publishKey
    obj.subscribeKey   = subscribeKey
    obj.url            = "http://roku.pubnub.com"
    
    ' Add Method Publish
    obj.publish        = pubnub_publish
    
    ' Add Method Subscribe
    obj.subscribe      = pubnub_subscribe
    
    ' Add Method Presense
    obj.presence       = pubnub_presence
    
    return obj
end Function

Function pubnub_publish(channel as String, message as Object)
    message = SimpleJSONBuilder(message) ' turn message into json

    param       = CreateObject("roArray", 8, false)
    urlt        = CreateObject("roUrlTransfer")
    param[0]    = m.url
    param[1]    = "publish"
    param[2]    = m.publishKey
    param[3]    = m.subscribeKey
    param[4]    = "0"
    param[5]    = channel
    param[6]    = "0"
    param[7]    = urlt.Escape(message)
    
    url = implode("/", param)
    
    return http_request(url, 310)
end Function

Function pubnub_subscribe(channel as String, callback)
    timeout = "0"
    while True
        param       = CreateObject("roArray", 6, false)
        param[0]    = m.url
        param[1]    = "subscribe"
        param[2]    = m.subscribeKey
        param[3]    = channel
        param[4]    = "0"
        param[5]    = timeout
        
        url = implode("/", param)
        
        send = http_request(url, 310)
        
        ' Check for error, if error exit
        if isbool(send) and send = false
            return false
        endif
        
        ' Set new timeout
        timeout = send[1]
        
        ' Send to callback
        callback(send[0])
    endwhile
end Function

Function pubnub_presence(channel as String)
    param       = CreateObject("roArray", 7, false)
    param[0]    = m.url
    param[1]    = "v2"
    param[2]    = "presence"
    param[3]    = "sub_key"
    param[4]    = m.subscribeKey
    param[5]    = "channel"
    param[6]    = channel
    
    url = implode("/", param)
    
    print url
    
    request = http_request(url, 2)
        
    ' Check for error, if error exit
    if isbool(request) and request = false
        return false
    endif
    
    return request
end Function