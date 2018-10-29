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

Sub SaveWorksheetsAsUnicodeTextWithOptions(indexPrefix As Boolean)
    Dim folderPath As String
    Dim inputWb As Excel.Workbook
    Dim tmpWb As Excel.Workbook
    Dim ws As Excel.Worksheet
    Dim index As Integer

    Set inputWb = Application.ActiveWorkbook
    If inputWb Is Nothing Then
        MsgBox Prompt:="No active workbook can be used", Buttons:=vbExclamation + vbOKOnly
        Exit Sub
    End If
    folderPath = GetFolder()
    If folderPath <> "" Then
        index = 1
        For Each ws In inputWb.Worksheets
            ws.Copy
            Set tmpWb = Application.ActiveWorkbook
            With tmpWb
                .SaveAs Filename:=folderPath & "\" & Format(index, "00") & "-" & ws.Name & ".txt", FileFormat:=xlUnicodeText
                .Close SaveChanges:=False
            End With
            index = index + 1
        Next
    End If
End Sub

Sub SaveWorksheetsAsUnicodeText()
    SaveWorksheetsAsUnicodeTextWithOptions indexPrefix:=False
End Sub

Sub SaveWorksheetsAsUnicodeTextIncludeIndexPrefix()
    SaveWorksheetsAsUnicodeTextWithOptions indexPrefix:=True
End Sub
```

Previous work, not tidied up, filename `Operation.vbs`, last modified on 2009-06-30 11‎:01
```vb
Option Explicit

' This will do a look up when two values are equal, similar to VLookup in Excel
' srcSheet: The look up table
' srcCColIdx: The index of column-being-look-up in the look up table
' srcVTFColIdx: The index of column in which matching value should be returned
' tarSheet: The target table that is going to be look up
' tarCColIdx: The index of column-to-look-up in the target table
' tarFColIdx: The index of column in which the returned value should be filled
Private Sub doEqualLookup(srcSheet As Worksheet, srcCColIdx As Integer, _
                          srcVTFColIdx As Integer, tarSheet As Worksheet, _
                          tarCColIdx As Integer, tarFColIdx As Integer)
    Dim numOfSrcRow As Long
    Dim numOfTarRow As Long
    Dim srcIdx As Long
    Dim tarIdx As Long
    
    ' Find last row index
    numOfSrcRow = Query.findLastRowIdx(srcSheet)
    numOfTarRow = Query.findLastRowIdx(tarSheet)
    ' Start main loop
    For tarIdx = 2 To numOfTarRow
        For srcIdx = 2 To numOfSrcRow
            If UCase(srcSheet.Cells(srcIdx, srcCColIdx).Value) = _
                UCase(tarSheet.Cells(tarIdx, tarCColIdx).Value) Then
                tarSheet.Cells(tarIdx, tarFColIdx).Value = _
                    srcSheet.Cells(srcIdx, srcVTFColIdx).Value
                Exit For
            End If
        Next
    Next
End Sub

' This will do a look up when the target value contains the keyword specified
' in the look up table, similar to VLookup in Excel
' srcSheet: The look up table
' srcCColIdx: The index of column which contains the keyword in the look up table
' srcVTFColIdx: The index of column in which matching value should be returned
' tarSheet: The target table that is going to be look up
' tarCColIdx: The index of column-to-look-up for keyword in the target table
' tarFColIdx: The index of column in which the returned value should be filled
Private Sub doKeywordLookup(srcSheet As Worksheet, srcCColIdx As Integer, _
                            srcVTFColIdx As Integer, tarSheet As Worksheet, _
                            tarCColIdx As Integer, tarFColIdx As Integer)
    Dim numOfSrcRow As Long
    Dim numOfTarRow As Long
    Dim srcIdx As Long
    Dim tarIdx As Long

    ' Find last row index
    numOfSrcRow = Query.findLastRowIdx(srcSheet)
    numOfTarRow = Query.findLastRowIdx(tarSheet)
    ' Start main loop
    For tarIdx = 2 To numOfTarRow
        For srcIdx = 2 To numOfSrcRow
            If InStr(1, tarSheet.Cells(tarIdx, tarCColIdx).Value, _
                srcSheet.Cells(srcIdx, srcCColIdx).Value, vbTextCompare) > 0 Then
                tarSheet.Cells(tarIdx, tarFColIdx).Value = _
                    srcSheet.Cells(srcIdx, srcVTFColIdx).Value
                Exit For
            End If
        Next
    Next
End Sub

' This swaps all the rows after row index "fromRowIdx"
' that contains "cellValue" in column "columnIdx"
' to the row starting from "fromRowIdx"-th row
' Return: The index of the row after the row which
' contains "cellValue" in column "columnIdx"
Private Function moveRowToTop(ByVal columnIdx As Integer, _
                              ByVal cellValue As String, _
                              ByVal fromRowIdx As Integer) As Long
    Dim i As Long
    Dim startRowIdx As Long
    Dim lastRowIdx As Long

    startRowIdx = fromRowIdx()
    lastRowIdx = findLastRowIdx()

    For i = startRowIdx To lastRowIdx
        If Cells(i, columnIdx).Value = cellValue Then
            If i <> fromRowIdx Then
                Rows(i).Cut
                Rows(fromRowIdx).Insert Shift:=xlDown
            End If
            fromRowIdx = fromRowIdx + 1
        End If
    Next
    moveRowToTop = fromRowIdx
End Function

' This deletes the rows that contains empty value in column "columnIdx"
Private Sub deleteIfEmpty(ByVal columnIdx As Integer)
    Dim i As Long
    Dim lastRowIdx As Long

    i = 1
    lastRowIdx = findLastRowIdx
    Do While i <= lastRowIdx
        If Trim(Cells(i, columnIdx)) = "" Then
            Rows(i).Delete
            lastRowIdx = lastRowIdx - 1
        Else
            i = i + 1
        End If
    Loop
End Sub

' This highlights the rows in which the value in "compColIdxA" equals
' the value in "compColIdxB" in worksheet "sheetNameA"
' and the first match in "sheetNameB" to green, all rows that have no match
' in worksheet "sheetNameA" to orange
Private Sub highlightIfCellDiff(sheetNameA As String, _
                                sheetNameB As String, _
                                compColIdxA As String, _
                                compColIdxB As String, _
                                firstRowIdxA As Long, _
                                firstRowIdxB As Long, _
                                lastRowIdxA As Long, _
                                lastRowIdxB As Long, _
                                Optional displayProgress As Boolean = True, _
                                Optional screenUpdating As Boolean = False)
    Dim lastColIdxA As Integer
    Dim lastColIdxB As Integer
    Dim curIdxA As Long
    Dim curIdxB As Long
    Dim prevStatusBar As Variant
    Dim prevScreenUpdating As Boolean

    ' Display progress if required
    If displayProgress Then
        prevStatusBar = Application.StatusBar
        Application.StatusBar = 0
    End If
    ' Update screen if required
    prevScreenUpdating = Application.screenUpdating
    Application.screenUpdating = screenUpdating

    ' Find the last column index
    Sheets(sheetNameA).Select
    lastColIdxA = findLastColumnIdx()
    Sheets(sheetNameB).Select
    lastColIdxB = findLastColumnIdx()

    ' Main loop
    For curIdxA = firstRowIdxA To lastRowIdxA
        Call backgroundOrange(Sheets(sheetNameA). _
             Range(Cells(curIdxA, 1), Cells(curIdxA, lastColIdxA)))
        For curIdxB = firstRowIdxB To lastRowIdxB
            Sheets(sheetNameB).Select
            If Sheets(sheetNameA).Cells(curIdxA, compColIdxA) = _
               Sheets(sheetNameB).Cells(curIdxB, compColIdxB) Then
                Call backgroundGreen(Sheets(sheetNameA). _
                     Range(Cells(curIdxA, 1), Cells(curIdxA, lastColIdxA)))
                Call backgroundGreen(Sheets(sheetNameB). _
                     Range(Cells(curIdxB, 1), Cells(curIdxB, lastColIdxB)))
                Exit For
            End If
            If displayProgress Then
                Application.StatusBar = Application.StatusBar + 1
            End If
        Next
    Next
    
    ' Restore original setting
    If displayProgress Then
        Application.StatusBar = prevStatusBar
    End If
    Application.screenUpdating = prevScreenUpdating
End Sub

' This highlights the rows that appeared in worksheet "sheetNameA"
' and the first match in "sheetNameB" to green
Private Sub highlightIfRowDiff(sheetNameA As String, _
                               sheetNameB As String, _
                               firstRowIdxA As Long, _
                               firstRowIdxB As Long, _
                               lastRowIdxA As Long, _
                               lastRowIdxB As Long, _
                               Optional displayProgress As Boolean = True, _
                               Optional screenUpdating As Boolean = False)
    Dim lastColIdxA As Integer
    Dim lastColIdxB As Integer
    Dim curIdxA As Long
    Dim curIdxB As Long
    Dim prevStatusBar As Variant
    Dim prevScreenUpdating As Boolean

    ' Display progress if required
    If displayProgress Then
        prevStatusBar = Application.StatusBar
        Application.StatusBar = 0
    End If
    ' Update screen if required
    prevScreenUpdating = Application.screenUpdating
    Application.screenUpdating = screenUpdating

    ' Find the last column index
    Worksheets(sheetNameA).Activate
    lastColIdxA = findLastColumnIdx()
    Worksheets(sheetNameB).Activate
    lastColIdxB = findLastColumnIdx()

    ' Main Loop
    For curIdxA = firstRowIdxA To lastRowIdxA
        For curIdxB = firstRowIdxB To lastRowIdxB
            If rowCompare(sheetNameA, sheetNameB, curIdxA, curIdxB) Then
                Call backgroundGreen(Worksheets(sheetNameA).Rows(curIdxA))
                Call backgroundGreen(Worksheets(sheetNameB).Rows(curIdxB))
                Exit For
            End If
        Next
        If displayProgress Then
            Application.StatusBar = Application.StatusBar + 1
        End If
    Next

    ' Restore original setting
    If displayProgress Then
        Application.StatusBar = prevStatusBar
    End If
    Application.screenUpdating = prevScreenUpdating
End Sub
```
