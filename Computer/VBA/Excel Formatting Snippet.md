Previous work, not tidied up, filename `Formatting 0.2.vbs`, last modified on 2009-07-10 13‎:52
```vb
Option Explicit

Private Enum ColorIndex
    Black = 1
    White = 2
    Red = 3
    BrightGreen = 4
    Blue = 5
    Yellow = 6
    Pink = 7
    LightBlue = 8
    Lime = 35
    LightOrange = 45
End Enum

' This changes the border to full border for the selected cells
Private Sub borderFull(target As Range)
    target.Borders(xlDiagonalDown).LineStyle = xlNone
    target.Borders(xlDiagonalUp).LineStyle = xlNone
    With target.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With target.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With target.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With target.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With target.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With target.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
End Sub

' This changes the selected font to bold font
Private Sub fontBold(target As Range)
    target.Interior.Pattern = xlSolid
End Sub

' This normalizes the font format for the selected cells
Private Sub fontNormalize(target As Range)
    With target.Font
        .Name = "Arial"
        .Size = 10
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
    End With
End Sub

' This changes the target cells background color
Private Sub fillColor(target As Range, color As ColorIndex)
    With target.Interior
        .ColorIndex = color
    End With
End Sub
```
