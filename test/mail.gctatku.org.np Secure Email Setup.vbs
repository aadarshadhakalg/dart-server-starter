' mail.gctatku.org.np Secure Email Setup.vbs
'
' This script will setup an Email account in Windows Live Mail
'
' 06/26/2012 - Initial write.

Option Explicit
Dim strIncServerAddress, strOutServerAddress, strServerMailPort, strAccount, strSecureConnection, strFolderNotFoundText, _
	strProgramNotFoundText, strCloseText, boolPop, strServerSmtpPort, strFileNotFoundText, boolArchive

' *************************************************************************
' Configurable Variables
' *************************************************************************
strIncServerAddress	   = "mail.gctatku.org.np"		 					' This is the address for the mail server
strOutServerAddress	   = "mail.gctatku.org.np"		 					' This is the address for the mail server
strServerMailPort 	   = "000003e1"							' The port on the server to which to connect
																' Imap:  Secure = 000003e1  Unsecure = 0000008f
																' Pop:   Secure = 000003e3	Unsecure = 0000006e
strAccount			   = "amds2021@gctatku.org.np"							' Mail account to connect as
strSecureConnection    = "00000001"					' Use a secure connection - 00000001 for true, 00000000 for false
strCloseText 		   = "Please close Windows Live Mail before continuing."
strFolderNotFoundText  = "Windows Live Mail may not be installed; the following directory was not found:"
strProgramNotFoundText = "Windows Live Mail may not be installed; the following file was not found:"
strFileNotFoundText	   = "File not found."
strServerSmtpPort	   = "000001d1"							' Smtp port on the server
boolPop				   = False							' Whether to setup Imap or Pop
boolArchive			   = False						' Whether or not to use the special folders


' *************************************************************************
' Write out the Account File for Windows Live Mail
' *************************************************************************
Function WriteFile
	Dim objShell, objFSO, objAccountFile, strBaseFilePath, strFullFilePath

	' Generate a first file name for the account file
	Set objShell 	= CreateObject("WScript.Shell")
	strBaseFilePath = objShell.ExpandEnvironmentStrings("%USERPROFILE%\AppData\Local\Microsoft\Windows Live Mail")

	Set objFSO		= CreateObject("Scripting.FileSystemObject")
	If objFSO.FolderExists(strBaseFilePath) = False Then
		MsgBox strFolderNotFoundText & ": " & strBaseFilePath, 16, strFileNotFoundText

		Set objShell = Nothing

		WScript.Quit
	End if

	strFullFilePath = GenerateAccountFileName(strBaseFilePath)

	' See if the account file already exists and keep trying new ones until we find one that isn't there
	Do While objFSO.FileExists(strFullFilePath)
		strFullFilePath = GenerateAccountFileName(strBaseFilePath)
	Loop

	' Write the account file
	Set objAccountFile = objFSO.CreateTextFile(strFullFilePath, False)
	objAccountFile.WriteLine "<?xml version=""1.0"" encoding=""utf-8"" ?>"
	objAccountFile.WriteLine "<MessageAccount>"
	objAccountFile.WriteLine "	<Account_Name type=""SZ"">" & strAccount & "</Account_Name>"
	objAccountFile.WriteLine "	<Connection_Type type=""DWORD"">00000003</Connection_Type>"
	If boolPop = True Then
		objAccountFile.WriteLine "	<POP3_Server type=""SZ"">" & strIncServerAddress & "</POP3_Server>"
		objAccountFile.WriteLine "	<POP3_User_Name type=""SZ"">" & strAccount & "</POP3_User_Name>"
		objAccountFile.WriteLine "	<POP3_Use_Sicily type=""DWORD"">00000000</POP3_Use_Sicily>"
		objAccountFile.WriteLine "	<POP3_Port type=""DWORD"">" & strServerMailPort & "</POP3_Port>"
		objAccountFile.WriteLine "	<POP3_Secure_Connection type=""DWORD"">" & strSecureConnection & "</POP3_Secure_Connection>"
		objAccountFile.WriteLine "	<Leave_Mail_On_Server type=""DWORD"">00000001</Leave_Mail_On_Server>"
		objAccountFile.WriteLine "	<Remove_When_Deleted type=""DWORD"">00000001</Remove_When_Deleted>"
		objAccountFile.WriteLine "	<POP3_Prompt_for_Password type=""DWORD"">00000001</POP3_Prompt_for_Password>"
		objAccountFile.WriteLine "	<POP3_Use_APOP type=""DWORD"">00000000</POP3_Use_APOP>"
	Else
		objAccountFile.WriteLine "	<IMAP_Server type=""SZ"">" & strIncServerAddress & "</IMAP_Server>"
		objAccountFile.WriteLine "	<IMAP_User_Name type=""SZ"">" & strAccount & "</IMAP_User_Name>"
		objAccountFile.WriteLine "	<IMAP_Port type=""DWORD"">" & strServerMailPort & "</IMAP_Port>"
		objAccountFile.WriteLine "	<IMAP_Secure_Connection type=""DWORD"">" & strSecureConnection & "</IMAP_Secure_Connection>"
		objAccountFile.WriteLine "	<IMAP_Timeout type=""DWORD"">0000003c</IMAP_Timeout>"
		objAccountFile.WriteLine "	<IMAP_Polling type=""DWORD"">00000001</IMAP_Polling>"
		objAccountFile.WriteLine "	<IMAP_Prompt_for_Password type=""DWORD"">00000001</IMAP_Prompt_for_Password>"
		objAccountFile.WriteLine "	<IMAP_Dirty type=""DWORD"">00000000</IMAP_Dirty>"
		objAccountFile.WriteLine "	<IMAP_Poll_All_Folders type=""DWORD"">00000001</IMAP_Poll_All_Folders>"
		objAccountFile.WriteLine "	<IMAP_XLIST_Migration_Done type=""DWORD"">00000001</IMAP_XLIST_Migration_Done>"
		If boolArchive = True Then
			objAccountFile.WriteLine "	<IMAP_Svr-side_Special_Folders type=""DWORD"">00000000</IMAP_Svr-side_Special_Folders>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Sent_Items type=""DWORD"">00000000</IMAP_XLIST_Sent_Items>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Drafts type=""DWORD"">00000000</IMAP_XLIST_Drafts>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Deleted_Items type=""DWORD"">00000000</IMAP_XLIST_Deleted_Items>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Junk_E-mail type=""DWORD"">00000000</IMAP_XLIST_Junk_E-mail>"
		Else
			objAccountFile.WriteLine "	<IMAP_Svr-side_Special_Folders type=""DWORD"">00000001</IMAP_Svr-side_Special_Folders>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Sent_Items type=""DWORD"">00000001</IMAP_XLIST_Sent_Items>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Drafts type=""DWORD"">00000001</IMAP_XLIST_Drafts>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Deleted_Items type=""DWORD"">00000001</IMAP_XLIST_Deleted_Items>"
			objAccountFile.WriteLine "	<IMAP_XLIST_Junk_E-mail type=""DWORD"">00000001</IMAP_XLIST_Junk_E-mail>"
		End if
	End if
	objAccountFile.WriteLine "	<SMTP_Server type=""SZ"">" & strOutServerAddress & "</SMTP_Server>"
	objAccountFile.WriteLine "	<SMTP_Use_Sicily type=""DWORD"">00000002</SMTP_Use_Sicily>"
	objAccountFile.WriteLine "	<SMTP_Port type=""DWORD"">" & strServerSmtpPort & "</SMTP_Port>"
	objAccountFile.WriteLine "	<SMTP_Secure_Connection type=""DWORD"">" & strSecureConnection & "</SMTP_Secure_Connection>"
	objAccountFile.WriteLine "	<SMTP_Display_Name type=""SZ"">" & strAccount & "</SMTP_Display_Name>"
	objAccountFile.WriteLine "	<SMTP_Email_Address type=""SZ"">" & strAccount & "</SMTP_Email_Address>"
	objAccountFile.WriteLine "</MessageAccount>"
	objAccountFile.Close

	' Clean up
	Set objAccountFile = Nothing
	Set objFSO 		   = Nothing
	Set objShell	   = Nothing

End Function

' *************************************************************************
' Generates a new Windows Live Mail account file name
' *************************************************************************
Function GenerateAccountFileName(strBasePath)
	GenerateAccountFileName = strBasePath & "\account" & NewGuid & ".oeaccount"
End Function

' *************************************************************************
' Returns a new guid in brace notation e.g. {00000000-0000-0000-0000-000000000000}
' *************************************************************************
Function NewGuid
	Dim TypeLib
	Set TypeLib = CreateObject("Scriptlet.TypeLib")
	NewGuid = Left(TypeLib.Guid, 38)
End Function

' *************************************************************************
' Warns the user if Windows Live Mail is in the process list and exits if so
' *************************************************************************
Function WarnIfWindowsLiveMailIsRunning

	Do While IsWindowsLiveMailRunning = True
		Dim return
		return = MsgBox(strCloseText, 49)
		If return = vbCancel Then
			WScript.Quit
		End if

		WScript.Sleep 5000 ' Sleep for 5 seconds
	Loop

End Function

Function IsWindowsLiveMailRunning
	Dim objShell, objWmiService, objProcessList, boolFound

	' See if Windows Live Mail is running
	boolFound 		   = False
	Set objShell   	   = CreateObject("WScript.Shell")
	Set objWmiService  = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	Set objProcessList = objWmiService.ExecQuery ( _
		"Select * from Win32_Process where Name = 'wlmail.exe'")
	If objProcessList.Count >= 1 Then
		boolFound = True
	End if

	' Clean up
	Set objWmiService  = Nothing
	Set objProcessList = Nothing
	Set objShell 	   = Nothing

	IsWindowsLiveMailRunning = boolFound
End Function

' *************************************************************************
' Launches Windows Live Mail
' *************************************************************************
Function LaunchWindowsLiveMail
	Dim objShell, objFSO, strLiveMailPath

	' Start Windows Live Mail
	Set objShell = CreateObject("WScript.Shell")
	strLiveMailPath = objShell.ExpandEnvironmentStrings( _
		"%PROGRAMFILES(x86)%\Windows Live\Mail\wlmail.exe")

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	If objFSO.FileExists(strLiveMailPath) = False Then
		strLiveMailPath = objShell.ExpandEnvironmentStrings( _
			"%PROGRAMFILES%\Windows Live\Mail\wlmail.exe")

		If objFSO.FileExists(strLiveMailPath) = False Then
			MsgBox strProgramNotFoundText & ": " & strLiveMailPath, 16, strFileNotFoundText

			Set objShell = Nothing

			WScript.Quit
		End if
	End if

	objShell.Run("""" & strLiveMailPath & """")

	Set objShell = Nothing
	Set objFSO   = Nothing
End Function

WarnIfWindowsLiveMailIsRunning
WriteFile
LaunchWindowsLiveMail
