Previous work, not tidied up, filename `Combine Script 0.2.xls`, last modified on 2010-10-12 14:19
```vb
Option Explicit

' This returns the worksheet with worksheetName
' If no such workbook is found, it returns Nothing
Private Function getWorksheet(worksheetName As String, Optional bookToFind As Workbook = Nothing) As Worksheet
    Dim i As Integer

    Set getWorksheet = Nothing
    If bookToFind Is Nothing Then
        Set bookToFind = Application.ActiveWorkbook
    End If
    For i = 1 To bookToFind.Worksheets.Count
        If bookToFind.Worksheets(i).Name = worksheetName Then
            Set getWorksheet = bookToFind.Worksheets(i)
            Exit For
        End If
    Next
End Function

' This returns the index of the last row which contains data
Private Function findLastRowIdx(Optional sheetToFind As Worksheet = Nothing) As Long
    If sheetToFind Is Nothing Then
        Set sheetToFind = Application.ActiveSheet
    End If
    If WorksheetFunction.CountA(sheetToFind.Cells) > 0 Then
        'Search for any entry, by searching backwards by Rows.
        findLastRowIdx = sheetToFind.Cells.Find(What:="*", After:=[A1], _
                              SearchOrder:=xlByRows, _
                              SearchDirection:=xlPrevious).Row
    Else
        findLastRowIdx = 0
    End If
End Function

Private Function appendWorksheet(srcWS As Worksheet, trgWS As Worksheet, startRowIdx As Long) As Boolean
    Dim srcLastRowIdx As Long
    Dim trgLastRowIdx As Long
    Dim srcAdjLastRowIdx As Long

    appendWorksheet = True
    srcLastRowIdx = findLastRowIdx(srcWS)
    If srcLastRowIdx >= startRowIdx Then
        trgLastRowIdx = findLastRowIdx(trgWS)
        If trgLastRowIdx < trgWS.Rows.Count Then
            srcAdjLastRowIdx = WorksheetFunction.Min(srcLastRowIdx, WorksheetFunction.Max(startRowIdx + trgWS.Rows.Count - trgLastRowIdx - 1, startRowIdx))
            srcWS.Range(srcWS.Rows(startRowIdx), srcWS.Rows(srcAdjLastRowIdx)).Copy
            Call trgWS.Rows(trgLastRowIdx + 1).Insert(xlDown)
            ' Indicate overflow happens
            appendWorksheet = (srcAdjLastRowIdx = srcLastRowIdx)
        End If
    End If
End Function

Public Sub CombineWorkbooks()
    Const FILTER As String = "Excel Files (*.xls),*.xls,All Files (*.*),*.*"
    Const FILTER_INDEX = 1
    Const DIALOG_TITLE As String = "Select File(s) to Open"
    Dim fileNames As Variant
    Dim i As Integer
    Dim j As Integer
    Dim masterWB As Workbook
    Dim overflowList As String

    fileNames = Application.GetOpenFilename(FILTER, FILTER_INDEX, DIALOG_TITLE, , True)
    If IsArray(fileNames) Then
        Application.SheetsInNewWorkbook = 1
        Set masterWB = Application.Workbooks.Add

        For i = LBound(fileNames) To UBound(fileNames)
            Dim srcWB As Workbook

            Set srcWB = Application.Workbooks.Open(fileNames(i))
            For j = 1 To srcWB.Worksheets.Count
                Dim srcWS As Worksheet
                
                Set srcWS = srcWB.Worksheets(j)
                If Strings.LCase(srcWS.Name) <> "index" Then
                    Dim masterWS As Worksheet
                    
                    Set masterWS = getWorksheet(srcWS.Name, masterWB)
                    If masterWS Is Nothing = False Then
                        If appendWorksheet(srcWS, masterWS, 3) = False Then
                            overflowList = overflowList & masterWS.Name & vbNewLine
                        End If
                    Else
                        Call srcWS.Copy(, masterWB.Worksheets(masterWB.Worksheets.Count))
                    End If
                End If
            Next
            Application.CutCopyMode = False 'To prevent annoying prompt
            srcWB.Close (False)
        Next
        masterWB.Worksheets(1).Delete
        masterWB.Worksheets(1).Select
        If overflowList <> "" Then
            Call MsgBox("The follow worksheets has overflow:" + vbNewLine + overflowList, vbExclamation, "Warning")
        End If
    End If
End Sub

Public Sub FastCombineWorkbooks()
    Const FILTER As String = "Excel Files (*.xls),*.xls,All Files (*.*),*.*"
    Const FILTER_INDEX = 1
    Const DIALOG_TITLE As String = "Select File(s) to Open"
    Dim fileNames As Variant
    Dim i As Integer
    Dim j As Integer
    Dim masterWB As Workbook
    Dim overflowList As String

    fileNames = Application.GetOpenFilename(FILTER, FILTER_INDEX, DIALOG_TITLE, , True)
    If IsArray(fileNames) Then
        overflowList = ""
        Set masterWB = Application.Workbooks.Open(fileNames(LBound(fileNames)))

        For i = LBound(fileNames) + 1 To UBound(fileNames)
            Dim srcWB As Workbook

            Set srcWB = Application.Workbooks.Open(fileNames(i))
            For j = 1 To masterWB.Worksheets.Count
                Dim masterWS As Worksheet
                
                Set masterWS = masterWB.Worksheets(j)
                If Strings.LCase(masterWS.Name) <> "index" Then
                    Dim srcWS As Worksheet
                    
                    Set srcWS = getWorksheet(masterWS.Name, srcWB)
                    If srcWS Is Nothing = False Then
                        If appendWorksheet(srcWS, masterWS, 3) = False Then
                            overflowList = overflowList & masterWS.Name & vbNewLine
                        End If
                    End If
                End If
            Next
            Application.CutCopyMode = False 'To prevent annoying prompt
            srcWB.Close (False)
        Next
        If overflowList <> "" Then
            Call MsgBox("The follow worksheets has overflow:" + vbNewLine + overflowList, vbExclamation, "Warning")
        End If
    End If
End Sub
```
