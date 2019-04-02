
-- CheckmarxXcodePlugin1Bridge - v1.0402

script CheckmarxXcodePlugin1Bridge
	
	property parent : class "NSObject"
	
	-- AppleScript will automatically launch apps before sending Apple events;
	-- if that is undesirable, check the app object's `running` property first
	
	on isAppRunning() -- () -> NSNumber (Bool)
		
		return running of application "CheckmarxXcodePlugin1"
		
	end isAppRunning
	
	on cXcodeScans() -- () -> NSNumber (Int, 0...100)
		
		local cXcodeScan
		
		tell application "CheckmarxXcodePlugin1"
			
			activate
			
			set cXcodeScan to count of every scan
			
		end tell
		
		return cXcodeScan -- ASOC will convert returned integer to NSNumber...
		
	end cXcodeScans
	
	on submitNextScanAsFull() -- () 
		
		local idXcodeScan
		
		tell application "CheckmarxXcodePlugin1"
			
			activate
			
			set cXcodeScan to count of every scan
			set idXcodeScan to 1 + cXcodeScan
			
		end tell
		
		submitScanAsFull(idXcodeScan)
		
	end submitNextScanAsFull
	
	on submitScanAsFull(idXcodeScan) -- (NSNumber) -> ()
		
		tell application "CheckmarxXcodePlugin1"
			
			activate
			
			set nameXcodeScan to "AppleScript Xcode Scan " & idXcodeScan
			
			set newXcodeScan to make new scan with properties {name:nameXcodeScan}
			mark newXcodeScan as "not complete"
			set newAttr1 to make new attr with properties {name:"CxScanSourceIsXcode", value:"true"} at end of every attr of newXcodeScan
			set newAttr2 to make new attr with properties {name:"FullScan", value:"true"} at end of every attr of newXcodeScan
			set newAttr3 to make new attr with properties {name:"Synchronous", value:"true"} at end of every attr of newXcodeScan
			set newAttr4 to make new attr with properties {name:"EngineConfig", value:"Default Configuration"} at end of every attr of newXcodeScan
			set newAttr5 to make new attr with properties {name:"GenerateReport", value:"true"} at end of every attr of newXcodeScan
			set newAttr6 to make new attr with properties {name:"ReportType", value:"xml"} at end of every attr of newXcodeScan
			
			submit newXcodeScan as "full"
			
		end tell
		
	end submitScanAsFull
	
	on submitNextScanAsIncremental() -- () 
		
		local idXcodeScan
		
		tell application "CheckmarxXcodePlugin1"
			
			activate
			
			set cXcodeScan to count of every scan
			set idXcodeScan to 1 + cXcodeScan
			
		end tell
		
		submitScanAsIncremental(idXcodeScan)
		
	end submitNextScanAsIncremental
	
	on submitScanAsIncremental(idXcodeScan) -- (NSNumber) -> ()
		
		tell application "CheckmarxXcodePlugin1"
			
			activate
			
			set nameXcodeScan to "AppleScript Xcode Scan " & idXcodeScan
			
			set newXcodeScan to make new scan with properties {name:nameXcodeScan}
			mark newXcodeScan as "not complete"
			set newAttr1 to make new attr with properties {name:"CxScanSourceIsXcode", value:"true"} at end of every attr of newXcodeScan
			set newAttr2 to make new attr with properties {name:"FullScan", value:"false"} at end of every attr of newXcodeScan
			set newAttr3 to make new attr with properties {name:"Synchronous", value:"true"} at end of every attr of newXcodeScan
			set newAttr4 to make new attr with properties {name:"EngineConfig", value:"Default Configuration"} at end of every attr of newXcodeScan
			set newAttr5 to make new attr with properties {name:"GenerateReport", value:"true"} at end of every attr of newXcodeScan
			set newAttr6 to make new attr with properties {name:"ReportType", value:"xml"} at end of every attr of newXcodeScan
			
			submit newXcodeScan as "incremental"
			
		end tell
		
	end submitScanAsIncremental
	
	on signalBindViewLastReport() -- ()
		
		tell application "CheckmarxXcodePlugin1"
			
			activate
			
			set newBind to make new bind
			
			tagOrigin newBind as "CxBindSourceIsXcode"
			
			viewLastSASTScanReport newBind
			
		end tell
		
	end signalBindViewLastReport
	
	on signalBindOrUnbind() -- () 
		
		tell application "CheckmarxXcodePlugin1"
			
			activate
			
			--  set cBinds to count of every bind
			--  set keyBind to "/Test/Key/Bind/"
			--  set newBind to make new bind with properties {key:keyBind, cxProjectId:170017, cxProjectName:"PHP-Mailer"}
			
			set newBind to make new bind
			
			tagOrigin newBind as "CxBindSourceIsXcode"
			
			handleBindOrUnbind newBind
			
		end tell
		
	end signalBindOrUnbind
	
end script

-- tell CheckmarxXcodePlugin1Bridge to submitNextScanAsFull()
-- tell CheckmarxXcodePlugin1Bridge to submitNextScanAsIncremental()
-- tell CheckmarxXcodePlugin1Bridge to signalNextScanAsBindOrUnbind()

