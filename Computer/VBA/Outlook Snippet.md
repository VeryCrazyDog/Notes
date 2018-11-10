Previous work, not tidied up, filename `Outlook Macro.vbs`, last modified on 2009-08-04 15:44
```vb
Option Explicit

Private Sub Application_ItemSend(ByVal Item As Object, Cancel As Boolean)
    If Strings.Trim(Item.Subject) = "" Then
        Cancel = True
        Call MsgBox("Please fill in the subject before sending.", _
            vbExclamation + vbSystemModal, "Missing Subject")
        Item.Display
    End If
End Sub

Private Function containFolder(parent As Outlook.Folders, folderName As String) As Boolean
    Dim i As Integer
    
    containFolder = False
    For i = 1 To parent.Count
        If parent.Item(i).Name = folderName Then
            containFolder = True
            Exit For
        End If
    Next
End Function

Public Sub doArchive()
    On Error GoTo ErrorHandler

    Dim ns As Outlook.NameSpace
    Const ARCHIVE_DATA_NAME As String = "Archive Folders"

    Set ns = Application.GetNamespace("MAPI")
    If containFolder(ns.Folders, ARCHIVE_DATA_NAME) = False Then
        Call MsgBox("'" & ARCHIVE_DATA_NAME & "' data file does not exist!", vbOKOnly + vbExclamation)
    Else
        Dim archiveDataFile As Outlook.MAPIFolder
        
        Set archiveDataFile = ns.Folders.Item(ARCHIVE_DATA_NAME)
        If archiveDataFile.DefaultItemType <> olMailItem Then
            Call MsgBox("'" & ARCHIVE_DATA_NAME & "' is not a mail folder!", vbOKOnly + vbExclamation)
        Else
            Dim answer As VbMsgBoxResult
            Dim selectedItem As Object
            
            answer = vbYes
            If Application.ActiveExplorer.Selection.Count >= 3 Then
                answer = MsgBox("Are you sure you want to archive " & _
                    Application.ActiveExplorer.Selection.Count & " mails?", _
                    vbQuestion + vbYesNoCancel)
            End If

            If answer = vbYes Then
                For Each selectedItem In Application.ActiveExplorer.Selection
                    If selectedItem.Class = olMail Then
                        Dim mail As Outlook.MailItem
                        Dim oldFolder As Outlook.MAPIFolder
                        Dim folderNames() As String
                        Dim i As Integer
                        Dim archiveFolder As Outlook.MAPIFolder
        
                        Set mail = selectedItem
                        Set oldFolder = mail.parent
                        folderNames = Strings.Split(oldFolder.FolderPath, "\")
                        If UBound(folderNames) >= 3 Then
                            Set archiveFolder = archiveDataFile
                            For i = 3 To UBound(folderNames)
                                If containFolder(archiveFolder.Folders, folderNames(i)) = False Then
                                    Call archiveFolder.Folders.Add(folderNames(i))
                                End If
                                Set archiveFolder = archiveFolder.Folders.Item(folderNames(i))
                            Next
                            Call mail.Move(archiveFolder)
                        End If
                    End If
                Next
            End If
        End If
    End If

    Exit Sub
ErrorHandler:
    Call MsgBox(Error(Err), vbCritical)
End Sub
```
