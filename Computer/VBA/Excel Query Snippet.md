Previous work, not tidied up, filename `Query 0.4.vbs`, last modified on 2010-10-18 11‎:27
```vb
Option Explicit

' This returns the workbook with workbookName
' If no such workbook is found, it returns Nothing
Private Function getWorkbook(workbookName As String) As Workbook
    Dim i As Integer
    
    Set getWorkbook = Nothing
    For i = 1 To Workbooks.Count
        If Workbooks(i).Name = workbookName Then
            Set getWorkbook = Workbooks(i)
            Exit For
        End If
    Next
End Function

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

' This returns the last cell in a row which contains data
Private Function findLastCellIdxInRow(rowIdx As Long) As Integer
    If WorksheetFunction.CountA(Rows(rowIdx)) > 0 Then
        findLastCellIdxInRow = Cells(rowIdx, 256).End(xlToLeft).Column
    Else
        findLastCellIdxInRow = 0
    End If
End Function

' This returns the last cell in a column which contains data
Private Function findLastCellIdxInCol(columnIdx As Integer) As Long
    If WorksheetFunction.CountA(Columns(columnIdx)) > 0 Then
        findLastCellIdxInCol = Cells(65536, columnIdx).End(xlUp).Row
    Else
        findLastCellIdxInCol = 0
    End If
End Function

' This returns the row index with the first occurance
' of "value" in column "columnIdx"
' Remark: This may return incorrect result if the some rows or columns are hidden
Private Function findFirstRowIdxInCol(ByVal columnIdx As Integer, value As String) As Long
    findFirstRowIdxInCol = 0
    
    If WorksheetFunction.CountA(Columns(columnIdx)) > 0 Then
        Dim result As Range

        If columnIdx = 1 Then
            Set result = Columns.Find(value, Cells(65536, 256), , , xlByColumns)
        Else
            Set result = Columns.Find(value, Cells(65536, columnIdx - 1), , , xlByColumns)
        End If
        If result Is Nothing = False Then
            If result.Column = columnIdx Then
                findFirstRowIdxInCol = result.Row
            End If
        End If
    End If
End Function

' This returns the column index with the first occurance
' of "value" in column "rowIdx"
' Remark: This may return incorrect result if the some rows or columns are hidden
Private Function findFirstColIdxInRow(ByVal rowIdx As Integer, value As String) As Long
    findFirstColIdxInRow = 0

    If WorksheetFunction.CountA(Rows(rowIdx)) > 0 Then
        Dim result As Range

        If rowIdx = 1 Then
            Set result = Columns.Find(value, Cells(65536, 256), , , xlByRows)
        Else
            Set result = Columns.Find(value, Cells(rowIdx - 1, 256), , , xlByRows)
        End If
        If result Is Nothing = False Then
            If result.Row = rowIdx Then
                findFirstColIdxInRow = result.Column
            End If
        End If
    End If
End Function

' This returns the index of the last row which contains data
' Remark: This may return incorrect result if the some rows or columns are hidden
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

' This returns the index of the last column which contains data
' Remark: This may return incorrect result if the some rows or columns are hidden
Private Function findLastColumnIdx(Optional sheetToFind As Worksheet = Nothing) As Integer
    If sheetToFind Is Nothing Then
        Set sheetToFind = Application.ActiveSheet
    End If
    If WorksheetFunction.CountA(sheetToFind.Cells) > 0 Then
        'Search for any entry, by searching backwards by Rows.
        findLastColumnIdx = sheetToFind.Cells.Find(What:="*", After:=[A1], _
                                SearchOrder:=xlByColumns, _
                                SearchDirection:=xlPrevious).Column
    Else
        findLastColumnIdx = 0
    End If
End Function

' This checks if all the values in column with index "columnIdx"
' are unique or not
' Return: Empty string if all values are unique,
' otherwise returns the first non-unique value
Private Function isUnique(columnIdx As Integer) As String
    Dim lastIdx As Long
    Dim i As Long
    Dim j As Long

    isUnique = ""
    lastIdx = findLastCellIdxInCol(columnIdx)
    For i = 1 To lastIdx
        If Trim(Cells(i, columnIdx)) <> "" Then
            For j = i + 1 To lastIdx
                If Trim(Cells(j, columnIdx)) <> "" Then
                    If Trim(Cells(j, columnIdx)) = Trim(Cells(i, columnIdx)) Then
                        isUnique = Trim(Cells(j, columnIdx))
                        Exit Function
                    End If
                End If
            Next
        End If
    Next
End Function

' This compares two rows, and return true if they are the same
Private Function rowCompare(stNameA As String, stNameB As String, _
                            rowIdxA As Long, rowIdxB As Long) As Boolean
    Dim i As Integer

    rowCompare = True
    For i = 1 To Columns.Count
        On Error GoTo ErrorHandler
        If Worksheets(stNameA).Cells(rowIdxA, i).Formula <> _
           Worksheets(stNameB).Cells(rowIdxB, i).Formula Then
            rowCompare = False
ExitForLoop:
            Exit For
        End If
NextItem:
        On Error GoTo 0
    Next
    On Error GoTo 0
    Exit Function
ErrorHandler:
    On Error GoTo 0
    If Worksheets(stNameA).Cells(rowIdxA, i).value <> _
       Worksheets(stNameB).Cells(rowIdxB, i).value Then
        rowCompare = False
        GoTo ExitForLoop
    End If
    GoTo NextItem
End Function

Public Function isBackgroundColor(target As Range, color As ColorIndex) As Boolean
    isBackgroundColor = False
    With target.Interior
        If Not IsNull(.ColorIndex) Then
            isBackgroundColor = (.ColorIndex = color)
        End If
    End With
End Function

Private Function myColumns(columnName As String) As Range
    Dim searchResult As Range
    
    Set myColumns = Nothing
    Set searchResult = Rows(1).Find(columnName, Cells(1, 1), , , xlByColumns)
    If searchResult Is Nothing = False Then
        If searchResult.Row = 1 Then
            Set myColumns = Columns(searchResult.Column)
        End If
    End If
End Function
```
