Save all worksheets in active workbook to CSV format 
```vb
Option Explicit

Function GetFolder() As String
    Dim dialog As FileDialog

    Set dialog = Application.FileDialog(msoFileDialogFolderPicker)
    With dialog
        .Title = "Select a Folder"
        .AllowMultiSelect = False
        .InitialFileName = Application.DefaultFilePath
        If .Show <> -1 Then
            GetFolder = ""
        Else
            GetFolder = .SelectedItems(1)
        End If
    End With
    Set dialog = Nothing
End Function

Sub SaveWorksheetsAsCsv()
    Dim folderPath As String
    Dim wb As Excel.Workbook
    Dim ws As Excel.Worksheet
    
    Set wb = Application.ActiveWorkbook
    If wb Is Nothing Then
        MsgBox Prompt:="No active workbook can be used", Buttons:=vbExclamation + vbOKOnly
        Exit Sub
    End If
    folderPath = GetFolder()
    If folderPath <> "" Then
        For Each ws In wb.Worksheets
            ws.Copy
            ActiveWorkbook.SaveAs Filename:=folderPath & "\" & ws.Name & ".csv", FileFormat:=xlCSV
            ActiveWorkbook.Close SaveChanges:=False
        Next
    End If

End Sub
```
