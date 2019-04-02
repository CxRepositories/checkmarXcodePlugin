
-- CheckmarxXcodeApp1Bridge - v1.0402

use framework "Foundation"
use scripting additions

script CheckmarxXcodeApp1Bridge
	
	property parent : class "NSObject"
	
	-- AppleScript will automatically launch apps before sending Apple events;
	-- if that is undesirable, check the app object's `running` property first
	
	on isAppRunning() -- () -> NSNumber (Bool)
		
		set isAppXcodeRunning to running of application "Xcode"
		
		return isAppXcodeRunning
		
	end isAppRunning
	
	on isAppWorkSpaceDocLoaded() -- () -> NSNumber (Bool)
		
		set isAppXcodeRunning to running of application "Xcode"
		
		if isAppXcodeRunning = true then
			
			tell application "Xcode"
				
				set currWSDoc to active workspace document
				set isAppXcodeWSDocLoaded to false
				
				try
					
					set isAppXcodeWSDocLoaded to loaded of currWSDoc
					
				on error
					
					set isAppXcodeWSDocLoaded to false
					
				end try
				
				return isAppXcodeWSDocLoaded
				
			end tell
			
		else
			
			return false
			
		end if
		
	end isAppWorkSpaceDocLoaded
	
	on appWorkSpaceDocFile() -- () -> "Filespec":NSString?
		
		set isAppXcodeRunning to running of application "Xcode"
		
		if isAppXcodeRunning = true then
			
			tell application "Xcode"
				
				set currWSDoc to active workspace document
				set isAppXcodeWSDocLoaded to false
				
				try
					
					set isAppXcodeWSDocLoaded to loaded of currWSDoc
					
				on error
					
					set isAppXcodeWSDocLoaded to false
					
				end try
				
				if isAppXcodeWSDocLoaded = true then
					
					set nsCurrWSDocFile to file of currWSDoc
					set nsCurrWSDocFilespec to quoted form of (POSIX path of (nsCurrWSDocFile))
					
				--	display notification "The 'current' WorkSpace document (POSIX) 'file' is " & nsCurrWSDocFilespec
				--	display dialog "The 'current' WorkSpace document (POSIX) 'file' is " & nsCurrWSDocFilespec
					
					return nsCurrWSDocFilespec
					
				else
					
					return missing value -- nil
					
				end if
				
			end tell
			
		end if
		
		return missing value -- nil
		
	end appWorkSpaceDocFile
	
	on setAppWorkSpaceDocFile(sCurrScanTitle as string) -- (String) -> "Filespec":NSString?
		
		set isAppXcodeRunning to running of application "Xcode"
		
		if isAppXcodeRunning = true then
			
			tell application "Xcode"
				
				set currWSDoc to active workspace document
				set isAppXcodeWSDocLoaded to false
				
				try
					
					set isAppXcodeWSDocLoaded to loaded of currWSDoc
					
				on error
					
					set isAppXcodeWSDocLoaded to false
					
				end try
				
				if isAppXcodeWSDocLoaded = true then
					
					set nsCurrWSDocFile to file of currWSDoc
					set nsCurrWSDocFilespec to quoted form of (POSIX path of (nsCurrWSDocFile))
					
				--	tell application "CheckmarxXcodePlugin1"
				--		
				--		--	set currScan to scan id idCurrScan
				--		set currScan to scan sCurrScanTitle
				--		--  set newAttr1 to make new attr with properties {name:"XcodeWSDocFilespec", value:nsCurrWSDocFilespec} at end of every attr of currScan
				--		
				--	end tell
					
					--  display notification "The 'current' WorkSpace document (POSIX) 'file' is " & nsCurrWSDocFilespec
					--  display dialog "The 'current' WorkSpace document (POSIX) 'file' is " & nsCurrWSDocFilespec
					
					return nsCurrWSDocFilespec
					
				else
					
					return missing value -- nil
					
				end if
				
			end tell
			
		end if
		
		return missing value -- nil
		
	end setAppWorkSpaceDocFile
	
end script

tell CheckmarxXcodeApp1Bridge
	
	set sAppWSDocFile to setAppWorkSpaceDocFile("AppleScript Xcode Scan 3")
	
	display dialog "The 'current' WorkSpace document (POSIX) 'file' is " & sAppWSDocFile
	
end tell

--tell CheckmarxXcodeApp1Bridge
--	
--	set sAppWSDocFile to appWorkSpaceDocFile()
--			
--	display dialog "The 'current' WorkSpace document (POSIX) 'file' is " & sAppWSDocFile
--	
--end tell

--tell CheckmarxXcodeApp1Bridge
--	
--	set appRunning to isAppRunning()
--	
--	if appRunning = true then
--		
--		set appWSDocLoaded to isAppWorkSpaceDocLoaded()
--		
--		if appWSDocLoaded = true then
--			
--			set sAppWSDocFile to appWorkSpaceDocFile()
--			
--			display dialog "The 'current' WorkSpace document (POSIX) 'file' is " & sAppWSDocFile
--			
--		else
--			
--			display dialog "Xcode currently has NO 'current' WorkSpace document 'file'."
--			
--		end if
--		
--	else
--		
--		display dialog "Xcode is NOT running - Script is 'terminating' - 'appRunning' is " & appRunning
--		
--	end if
--	
--end tell
