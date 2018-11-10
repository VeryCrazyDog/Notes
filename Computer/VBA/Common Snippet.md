Previous work, not tidied up, filename `Common.vbs`, last modified on 2009-10-21 16:37
```vb
' Return: True if path is a directory, otherwise false
Private Function directoryExist(path As String) As Boolean
    directoryExist = False
    On Error GoTo ErrorHandler
    directoryExist = ((GetAttr(path) Mod vbDirectory) = 0)
    exit function
ErrorHandler:
End Function

' This returns the minimum of the two arguments
Private Function min(value1 As Integer, value2 As Integer) As Integer
    If value1 > value2 Then
        min = value2
    Else
        min = value1
    End If
End Function

' This returns the maximum of the two arguments
Private Function max(value1 As Integer, value2 As Integer) As Integer
    If value1 > value2 Then
        max = value1
    Else
        max = value2
    End If
End Function

' This gets a word in a string from position "startingPos"
' This is similiar to sscanf(value+startingPos, "%s", output) in C
Private Function getWord(ByVal value As String, _
                         Optional startingPos As Integer = 1) As String
    Dim spacePos As Integer
    Dim tabPos As Integer

	getWord = ""
    value = Mid(value, startingPos)
    value = LTrim(value)
    spacePos = InStr(1, value, " ")
    tabPos = InStr(1, value, vbTab)

    If spacePos = 0 And tabPos = 0 Then
        getWord = value
    ElseIf spacePos = 0 Or tabPos = 0 Then
        getWord = Left(value, max(spacePos, tabPos) - 1)
    Else
        getWord = Left(value, min(spacePos, tabPos) - 1)
    End If
End Function

' This obtains the file name given a path
Public Function GetFileName(ByVal path As String) As String
    GetFileName = path
    If path <> "" Then
        Dim i As Integer
        
        For i = Strings.Len(path) To 0 Step -1
            Dim ch As String
            
            ch = Strings.Mid(path, i, 1)
            If (((ch = "\") Or (ch = "/")) Or (ch = ":")) Then
                GetFileName = Strings.Mid(path, i + 1)
                Exit For
            End If
        Next
    End If
End Function

' This get the parent path given a path to a file
Public Function GetParentPath(ByVal path As String) As String
    GetParentPath = path
    If path <> "" Then
        Dim i As Integer
        
        For i = Strings.Len(path) To 0 Step -1
            Dim ch As String
            
            ch = Strings.Mid(path, i, 1)
            If (((ch = "\") Or (ch = "/")) Or (ch = ":")) Then
                GetParentPath = Strings.Left(path, i)
                Exit For
            End If
        Next
    End If
End Function

' This extracts a string starting with "startStr"
' and end with any strings in "endStr"
' from the source
' Return: Empty string if "startStr" is not found
'         all string after "startStr" if all strings
'         in "endStr" are not found
Private Function extractString(source As String, startStr As String, endStr() As String) As String
    Dim startIdx As Integer
    Dim endIdx As Integer
    Dim i As Integer
    
    startIdx = InStr(1, source, startStr)
    If startIdx > 0 Then
        startIdx = startIdx + Strings.Len(startStr)
        endIdx = 0
        For i = 0 To UBound(endStr)
            Dim strIdx As Integer
            
            If endStr(i) <> "" Then
                strIdx = InStr(startIdx, source, endStr(i))
                If strIdx > 0 And (strIdx < endIdx Or endIdx = 0) Then
                    endIdx = strIdx
                End If
            End If
        Next
        If endIdx > 0 And endIdx > startIdx Then
            extractString = Trim(Mid(source, startIdx, endIdx - startIdx))
        Else
            extractString = Trim(Mid(source, startIdx))
        End If
    Else
        extractString = ""
    End If
End Function
```
