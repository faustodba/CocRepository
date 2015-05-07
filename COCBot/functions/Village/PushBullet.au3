; #FUNCTION# ====================================================================================================================
; Name ..........: PushBulle
; Description ...: This function will report to your mobile phone your values and last attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Antidote (2015-03)
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================


#include <Array.au3>
#include <String.au3>


Func _PushBullet($pTitle = "", $pMessage = "")
    #cs $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
    $access_token = $PushToken
    ;$device_iden = ""

    $oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
    $oHTTP.SetCredentials($access_token, "", 0)
    $oHTTP.Send()
    $Result = $oHTTP.ResponseText
    Local $device_iden = _StringBetween($Result, 'iden":"', '"')
    Local $device_name = _StringBetween($Result, 'nickname":"', '"')
    Local $device = ""
    Local $pDevice = 1
    $oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
    $oHTTP.SetCredentials($access_token, "", 0)
    $oHTTP.SetRequestHeader("Content-Type", "application/json")
    Local $pPush = '{"type": "note", "title": "' & $pTitle & '", "body": "' & $pMessage & '"}'
    $oHTTP.Send($pPush)
	#ce
    $pTitle=StringReplace($pTitle,"My Village:","Village Report")
    $pTitle=StringReplace($pTitle,"Last Attack:","Last Raid")

	_PushGoogleJson($pTitle, $pMessage)
	_PushGoogleApi($pTitle, $pMessage)
EndFunc   ;==>_PushBullet

Func _Push($pTitle, $pMessage)
   #cs
    $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
    $access_token = $PushToken
    ;$device_iden = ""

    $oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
    $oHTTP.SetCredentials($access_token, "", 0)
    $oHTTP.SetRequestHeader("Content-Type", "application/json")
    Local $pPush = '{"type": "note", "title": "' & $pTitle & '", "body": "' & $pMessage & '"}'
    ;Local $pPush = '{"type": "note", "title": "' & $pTitle & '", "body": "' & $pMessage & '","device_iden": "' & $device_iden[$pDevice - 1] & '"}'
    $oHTTP.Send($pPush)
	#ce
    $pTitle=StringReplace($pTitle,"My Village:","Village Report")
    $pTitle=StringReplace($pTitle,"Last Attack:","Last Raid")

	_PushGoogleJson($pTitle, $pMessage)
	_PushGoogleApi($pTitle, $pMessage)
EndFunc   ;==>_Push

; _PushBullet()
;_Push("CGB Notifications", "Message")


Func _PushGoogleJson($pTitle, $pMessage)
   ;Local $N="N-"
   ;$pTitle=$N&$pTitle

   $pTitle=StringReplace($pTitle,"My Village:","")

   Local $strId = "APA91bEBcTUDIgNkulhnwuVRpEfFX469EnITYsOqDRFNPh4Ok7wdCreUBxusTWXeZjeuDUo2gBmWqgv0juMHeT2vJYH2EAsM-vfsbHGnwTHPpa1HhT_C0E4Y6OTTgZmckbDJ0DB4hhiPFQNnMfHGBMY8AhQ03pDurA";
   Local $applicationID = "AIzaSyBpqjGqIOUx2zJeEkR3qX-FuxK0xJQ6nmo";

   $objHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
   $objHTTP.open ("post", "https://android.googleapis.com/gcm/send", False)
   $objHTTP.SetRequestHeader("Content-Type", "application/json")
   $objHTTP.setRequestHeader('Authorization', 'key=AIzaSyBpqjGqIOUx2zJeEkR3qX-FuxK0xJQ6nmo')
   $objHTTP.setRequestHeader('Sender', 'id=296637719773')

   Local $pPush = '{'
   $pPush&='"collapse_key": "score_update",'
   $pPush&='"time_to_live": 108,'
   $pPush&='"data": {'
   $pPush&='"message": "'&$pMessage&'",'
   $pPush&='"title": "'&$pTitle&'"'
   $pPush&='},'
   $pPush&='"to":"'&$strId&'"' ;errore nella documentazione di google non usare registration_id
   $pPush&='}'
   $objHTTP.send ($pPush)
   ;SetLog('Send _PushGoogleJson')
   ;SetLog('message ' &$pMessage)
   ;SetLog('title ' &$pTitle)
EndFunc

Func _PushGoogleApi($pTitle, $pMessage)
   Local $strId = "APA91bEBcTUDIgNkulhnwuVRpEfFX469EnITYsOqDRFNPh4Ok7wdCreUBxusTWXeZjeuDUo2gBmWqgv0juMHeT2vJYH2EAsM-vfsbHGnwTHPpa1HhT_C0E4Y6OTTgZmckbDJ0DB4hhiPFQNnMfHGBMY8AhQ03pDurA";
   Local $applicationID = "AIzaSyBpqjGqIOUx2zJeEkR3qX-FuxK0xJQ6nmo";

   Local $objHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
   ;$objHTTP.open ("post", "http://localhost:8089/api/Notifications", False)
   $objHTTP.open ("post", "http://192.168.111.103:8089/api/notifications", False)
   $objHTTP.SetRequestHeader("Content-Type", "application/json")
   ;$objHTTP.setRequestHeader('Authorization', 'key=AIzaSyBpqjGqIOUx2zJeEkR3qX-FuxK0xJQ6nmo')
   ;$objHTTP.setRequestHeader('Sender', 'id=296637719773')

   Local $pPush = '{'
   $pPush&='"collapse_key": "score_update",'
   $pPush&='"time_to_live": 108,'
   $pPush&='"data": {'
   $pPush&='"message": "'&$pMessage&'",'
   $pPush&='"title": "'&$pTitle&'"'
   $pPush&='},'
   $pPush&='"to":"'&$strId&'"' ;errore nella documentazione di google non usare registration_id
   $pPush&='}'
   $objHTTP.send ($pPush)

   ;SetLog('Send _PushGoogleJsonApi')
   ;SetLog('message ' &$pMessage)
   ;SetLog('title ' &$pTitle)

   ;Sleep(3000)
   Local $request=$objHTTP.ResponseText
   Local $oStatusCode = $objHTTP.status
   If $oStatusCode == 200 then
	  SetLog("Send message "&$pPush)
   else
	  SetLog("Send message Error "&$request)
   EndIf

EndFunc
