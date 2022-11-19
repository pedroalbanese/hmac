; ====================================================
; ================ HMAC Tool With GUI ================
; ====================================================
; AutoIt version: 3.3.12.0
; Language:       English
; Author:         Pedro F. Albanese
; Modified:       -
;
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

#NoTrayIcon
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
#include <WinAPIEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <File.au3>

Main()

Func Main()

	Local $hGUI = GUICreate("HMAC Tool - ALBANESE Lab " & Chr(169) & " 2018-2019", 670, 130)
	GUISetFont(9, 400, 1, "Consolas")
	Local $idInput = GUICtrlCreateInput("Select file...", 10, 15, 465, 20)
	Local $idBrowse = GUICtrlCreateButton("...", 480, 15, 35, 20)
	Local $idCombo = GUICtrlCreateCombo("", 520, 15, 140, 20, $CBS_DROPDOWNLIST)
	GUICtrlSetData($idCombo, "MD5 (128bit)|RIPEMD (160bit)|SHA1 (160bit)|SHA_256 (256bit)|SHA_384 (384bit)|SHA_512 (512bit)", "SHA_256 (256bit)")
	Local $idCalculate = GUICtrlCreateButton("Calculate", 585, 73, 77, 22)
	Local $pButton = GUICtrlCreateButton("Paste", 585, 45, 77, 22)
	Local $hButton = GUICtrlCreateButton("Clipboard", 585, 98, 77, 22)
	Local $idHashLabel = GUICtrlCreateEdit("Message Authentication Code", 10, 75, 570, 40, $ES_AUTOVSCROLL + $WS_VSCROLL)
	Local $idSecret = GUICtrlCreateEdit("Secret", 10, 45, 570, 20, $ES_AUTOVSCROLL)
	GUISetState(@SW_SHOW, $hGUI)

	Local $dHash = 0, _
			$sRead = ""
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $idBrowse
				Local $sFilePath = FileOpenDialog("Open a file", "", "All files (*.*)") ; Select a file to find the hash.
				If @error Then
					ContinueLoop
				EndIf
				GUICtrlSetData($idInput, $sFilePath) ; Set the inputbox with the filepath.
				GUICtrlSetData($idHashLabel, "Hash Digest") ; Reset the hash digest label.
			Local $iAlgorithm = "SHA256"

			Case $idCombo ; Check when the combobox is selected and retrieve the correct algorithm.
				Switch GUICtrlRead($idCombo) ; Read the combobox selection.
					Case "MD5 (128bit)"
						$iAlgorithm = "MD5"
					Case "RIPEMD (160bit)"
						$iAlgorithm = "RIPEMD160"
					Case "SHA1 (160bit)"
						$iAlgorithm = "SHA1"
					Case "SHA_256 (256bit)"
						$iAlgorithm = "SHA256"
					Case "SHA_384 (384bit)"
						$iAlgorithm = "SHA384"
					Case "SHA_512 (512bit)"
						$iAlgorithm = "SHA512"
				EndSwitch
			Case $hButton
				ClipPut(GUICtrlRead($idHashLabel))
			Case $pButton
				Local $sData = ClipGet()
				GUICtrlSetData($idSecret, $sData)
			Case $idCalculate
				$sSecret = GUICtrlRead($idSecret)
				Local $iFileExists = FileExists(GUICtrlRead($idInput))
				If Not $iFileExists Then
						MsgBox($MB_SYSTEMMODAL, "", "The file doesn't exist.")
				Else
					$Full = FileRead(GUICtrlRead($idInput))
					$dHash = _HashHMAC($iAlgorithm, $Full, $sSecret); Create a hash of the file.
					GUICtrlSetData($idHashLabel, $dHash) ; Set the hash digest label with the hash data.
				EndIf
		EndSwitch
	WEnd

	GUIDelete($hGUI) ; Delete the previous GUI and all controls.
EndFunc   ;==>Main

Func _HashHMAC($sAlgorithm, $bData, $bKey, $bRaw_Output = False)
	Local $oHashHMACErrorHandler = ObjEvent("AutoIt.Error", "_HashHMACErrorHandler")
	Local $oHMAC = ObjCreate("System.Security.Cryptography.HMAC" & $sAlgorithm)
	If @error Then SetError(1, 0, "")
	$oHMAC.key = Binary($bKey)
	Local $bHash = $oHMAC.ComputeHash_2(Binary($bData))
	Return SetError(0, 0, $bRaw_Output ? $bHash : StringLower(StringMid($bHash, 3)))
EndFunc   ;==>_HashHMAC


Func _HashHMACErrorHandler($oError)
	;Dummy Error Handler
EndFunc   ;==>_HashHMACErrorHandler