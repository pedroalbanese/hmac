#NoTrayIcon
#include <cmdline.au3>
#include <Array.au3>
#include <File.au3>

If Not StringInStr($CmdLineRaw, "in") Or $CmdLineRaw == "" Then
	ConsoleWrite("HMAC Tool CLI v1.00 - ALBANESE Lab " & Chr(184) & " 2018-2021" & @CRLF & @CRLF) ;
	ConsoleWrite("Usage: " & @CRLF) ;
	ConsoleWrite("   " & @ScriptName & " --in <file.ext> [--alg <algorithm>] [--key <secretkey>]" & @CRLF & @CRLF) ;
	ConsoleWrite("Algorithms: ") ;
	ConsoleWrite("MD5, SHA1, SHA-256, SHA-384, SHA-512, RMD160" & @CRLF) ;
	Exit
Else
	If _CmdLine_KeyExists('alg') Then
		Local $algo = _CmdLine_Get('alg')
		If $algo = "MD5" Then
			$alg = "MD5"
		ElseIf $algo = "SHA1" Then
			$alg = "SHA1"
		ElseIf $algo = "SHA-256" Then
			$alg = "SHA256"
		ElseIf $algo = "SHA-384" Then
			$alg = "SHA384"
		ElseIf $algo = "SHA-512" Then
			$alg = "SHA512"
		ElseIf $algo = "RMD160" Then
			$alg = "RIPEMD160"
		Else
			ConsoleWrite("Error: Unknown Algorithm." & @CRLF) ;
			Exit
		EndIf
		Local $file = _CmdLine_Get('in')
	Else
		$alg = "MD5"
		Local $file = _CmdLine_Get('in')
	EndIf
EndIf

Local $sSecret = _CmdLine_Get('key')

ConsoleWrite("HMAC-" & $alg & "(" & $file & ")= " & _HashHMAC($alg, $file, $sSecret) & @CRLF)

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
