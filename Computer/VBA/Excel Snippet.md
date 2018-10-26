Save all worksheets in active workbook to format *Unicode Text*
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

Sub SaveWorksheetsAsUnicodeText()
    Dim folderPath As String
    Dim inputWb As Excel.Workbook
    Dim tmpWb as Excel.Workbook
    Dim ws As Excel.Worksheet

    Set inputWb = Application.ActiveWorkbook
    If inputWb Is Nothing Then
        MsgBox Prompt:="No active workbook can be used", Buttons:=vbExclamation + vbOKOnly
        Exit Sub
    End If
    folderPath = GetFolder()
    If folderPath <> "" Then
        For Each ws In inputWb.Worksheets
            ws.Copy
            Set tmpWb = Application.ActiveWorkbook
            With tmpWb
                .SaveAs Filename:=folderPath & "\" & ws.Name & ".txt", FileFormat:=xlUnicodeText
                .Close SaveChanges:=False
            End With
        Next
    End If
End Sub
```
