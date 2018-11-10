Previous work, not tidied up, filename `File.vbs`, last modified on 2009-03-23 15:11
```vb
' This class represents a file for reading and writing
Option Explicit

' Instance variables
Private filePath As String
Private fileID As Integer
Private mode As String

' Constructor of the class
Private Sub Class_Initialize()
    filePath = ""
    fileID = 0
    mode = ""
End Sub

' This returns the path of the file
Public Property Get path() As String
    path = filePath
End Property

' This sets the path of the file
Public Property Let path(value As String)
    filePath = value
End Property

' This returns true if the file exists
Public Function isExist() As Boolean
    isExist = (Dir(filePath) <> "")
End Function

' This opens the file for reading
Public Sub openRead()
    If isExist() Then
        fileID = FreeFile
        mode = "r"
        Open filePath For Input As #fileID
    End If
End Sub

' This opens the file for writing
Public Sub openWrite()
    If Not isExist() Then
        fileID = FreeFile
        mode = "w"
        Open filePath For Output As #fileID
    End If
End Sub

' For read mode, this reads a line from the file
Public Function readLine() As String
    Line Input #fileID, readLine
End Function

' For write mode, This writes the "value" to the file as a line
Public Sub writeLine(value As String)
    Print #fileID, value
End Sub

' For read mode, this returns true if it is the end of the file
Public Function isEndOfFile() As Boolean
    isEndOfFile = EOF(fileID)
End Function

' This closes the file
Public Sub closeFile()
    Close #fileID
    fileID = 0
    mode = ""
End Sub

' This deletes the file
Public Sub deleteFile()
    Kill filePath
End Sub
```
