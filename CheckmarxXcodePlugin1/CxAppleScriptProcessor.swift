//
//  CxAppleScriptProcessor.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 03/14/19.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation
import Cocoa
import Carbon
import AppleScriptObjC       // ASOC adds its own 'load scripts' method to NSBundle

class CxAppleScriptProcessor: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "CxAppleScriptProcessor";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    var id:String;

    var cxXcodeApp1Bridge:CheckmarxXcodeApp1Bridge? = nil;

    var sCurrentXcodeWSDocFilespec:String?;

    let jsTraceLog:JsTraceLog      = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                  = ClassInfo.sClsDisp;

    open func toString()->String
    {

        var asToString:[String] = Array();

        asToString.append("[");
        asToString.append("[");
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],");
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],");
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],");
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)],");
        asToString.append("'bClsTrace': [\(ClassInfo.bClsTrace)],");
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)],");
        asToString.append("'sClsLogFilespec': [\(ClassInfo.sClsLogFilespec)]");
        asToString.append("],");
        asToString.append("'id': [\(String(describing: self.id))],");
        asToString.append("'cxXcodeApp1Bridge': [\(String(describing: self.cxXcodeApp1Bridge))],");
        asToString.append("'sCurrentXcodeWSDocFilespec': [\(String(describing: self.sCurrentXcodeWSDocFilespec))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog)],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of (open) func toString().

    override init()
    {
        
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.id = UUID().uuidString;
        
        super.init();
        
    } // End of (override) init().

    func determineCurrentXcodeWSDocFile() -> (bDetermineCurrentXcodeWSDocFileOk:Bool, sCurrentXcodeWSDocFilespec:String?) 
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        self.sCurrentXcodeWSDocFilespec = nil;

        if (self.cxXcodeApp1Bridge == nil)
        {

            // AppleScriptObjC (ASOC) setup:

            Bundle.main.loadAppleScriptObjectiveCScripts();

            // Create an instance of CheckmarxXcodeApp1Bridge script object for Swift code to use:

            let cxXcodeApp1BridgeClass:AnyClass = NSClassFromString("CheckmarxXcodeApp1Bridge")!;
            self.cxXcodeApp1Bridge              = (cxXcodeApp1BridgeClass.alloc() as! CheckmarxXcodeApp1Bridge);

        }

        // Note: The 'retrieveXcodeWSDocFilespecV#()' method(s) invoke AppleScript to communicate with both
        //       CheckmarxXcodePlugin1 and Xcode (to retrieve the current filespec of the currently active
        //       WorkSpace document. Both of these routines are subject to Apple's Security rules. Debugging
        //       revealed that 'retrieveXcodeWSDocFilespecV1()' fails without any acknowledgement from the Mac
        //       for a security breach. 'retrieveXcodeWSDocFilespecV2()' will display an error in the log on
        //       the security breach but is NOT the preferred method to interact with Xcode (v1 is). 
        //
        //       Therefore, the signal for this is the value of the 2 fields 'bIsAppXcodeRunning' and
        //       'bIsAppXcodeWSDocLoaded'. Since the code is here, then we were triggered by a menu item
        //       selection in the Checkmarx Xcode Source Editor plugin (thus, Xcode is running and there is
        //       a current WorkSpace document (or the menu is NOT available to be used). If BOTH of these
        //       fields are 'true', then the AppleScriptObjC bridge is working (security is not stopping the
        //       execution), so we'll use 'retrieveXcodeWSDocFilespecV1()'. In any other combination, the 
        //       AppleScriptObjC bridge is NOT working (probably because of security) so we'll use the 2nd
        //       option 'retrieveXcodeWSDocFilespecV2()' (which will still fail) to catch the problem in the 
        //       log.
        //       
        //       For either of these methods to work, the following MUST be coded into the 'info.plist':
        //       
        //           <key>NSAppleEventsUsageDescription</key>
        //           <string>CheckmarxXcodePlugin1 requires access to Xcode to get the current WorkSpace document file.</string>

        let bIsAppXcodeRunning:Bool     = cxXcodeApp1Bridge!.isAppRunning;
        let bIsAppXcodeWSDocLoaded:Bool = cxXcodeApp1Bridge!.isAppWorkSpaceDocLoaded;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<Validation decision>:...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeRunning' [\(bIsAppXcodeRunning)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeWSDocLoaded' [\(bIsAppXcodeWSDocLoaded)]...");

        if (bIsAppXcodeRunning     == true &&
            bIsAppXcodeWSDocLoaded == true)
        {

            let bRetrieveXcodeWSDocFilespec1Ok = self.retrieveXcodeWSDocFilespecV1();

            if (bRetrieveXcodeWSDocFilespec1Ok == false)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The retrieval of the Xcode WS Doc file failed ('bRetrieveXcodeWSDocFilespec1Ok' [\(bRetrieveXcodeWSDocFilespec1Ok)]) - Error!");

                return (false, nil);

            }

        }
        else
        {

            let bRetrieveXcodeWSDocFilespec2Ok = self.retrieveXcodeWSDocFilespecV2();

            if (bRetrieveXcodeWSDocFilespec2Ok == false)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The retrieval of the Xcode WS Doc file failed ('bRetrieveXcodeWSDocFilespec2Ok' [\(bRetrieveXcodeWSDocFilespec2Ok)]) - Error!");

                return (false, nil);

            }

        }

        if (self.sCurrentXcodeWSDocFilespec        != nil &&
            self.sCurrentXcodeWSDocFilespec!.count > 0)
        {

            self.sCurrentXcodeWSDocFilespec = JsFileIO.stripQuotesFromFile(sFilespec: self.sCurrentXcodeWSDocFilespec!);

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The retrived current Xcode WS Doc filespec 'sCurrentXcodeWSDocFilespec' is [\(self.sCurrentXcodeWSDocFilespec!)]...");

        return (true, self.sCurrentXcodeWSDocFilespec);
       
    } // End of func determineCurrentXcodeWSDocFile().

    private func retrieveXcodeWSDocFilespecV1() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let bIsAppXcodeRunning:Bool               = cxXcodeApp1Bridge!.isAppRunning;
        let bIsAppXcodeWSDocLoaded:Bool           = cxXcodeApp1Bridge!.isAppWorkSpaceDocLoaded;
        var sCurrentXcodeWSDocFilespec:String     = "";
        var nsCurrentXcodeWSDocFilespec:NSString? = cxXcodeApp1Bridge!.appWorkSpaceDocFile();

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<Before Validation>:...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeRunning' [\(bIsAppXcodeRunning)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeWSDocLoaded' [\(bIsAppXcodeWSDocLoaded)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'sCurrentXcodeWSDocFilespec' [\(sCurrentXcodeWSDocFilespec)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsCurrentXcodeWSDocFilespec' [\(String(describing: nsCurrentXcodeWSDocFilespec))]...");

        if (nsCurrentXcodeWSDocFilespec != nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsCurrentXcodeWSDocFilespec' [\(String(describing: nsCurrentXcodeWSDocFilespec))] is NOT 'nil' - converting to 'String'...");

        }
        else
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsCurrentXcodeWSDocFilespec' [\(String(describing: nsCurrentXcodeWSDocFilespec))] IS 'nil' - invoking cxXcodeApp1Bridge!.setAppWorkSpaceDocFile()...");
            
            let nsAEDesc:NSAppleEventDescriptor = NSAppleEventDescriptor(string: "DetermineCurrentXcodeWSDocFile1");

            nsCurrentXcodeWSDocFilespec = cxXcodeApp1Bridge!.setAppWorkSpaceDocFile(sCurrScanTitle: nsAEDesc);

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"AppleScript returned 'nsCurrentXcodeWSDocFilespec' [\(String(describing: nsCurrentXcodeWSDocFilespec))]...");

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsCurrentXcodeWSDocFilespec' [\(String(describing: nsCurrentXcodeWSDocFilespec))] is NOT 'nil' - converting to 'String'...");

        sCurrentXcodeWSDocFilespec = nsCurrentXcodeWSDocFilespec! as String;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<After Validation>:...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeRunning' [\(bIsAppXcodeRunning)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeWSDocLoaded' [\(bIsAppXcodeWSDocLoaded)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'sCurrentXcodeWSDocFilespec' [\(sCurrentXcodeWSDocFilespec)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsCurrentXcodeWSDocFilespec' [\(String(describing: nsCurrentXcodeWSDocFilespec))]...");

        self.sCurrentXcodeWSDocFilespec = sCurrentXcodeWSDocFilespec;

        return true;
       
    } // End of private func retrieveXcodeWSDocFilespecV1().

    private func retrieveXcodeWSDocFilespecV2() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let sAppleScriptText1:String =
            """
            on setAppWorkSpaceDocFile(sCurrScanTitle as string)

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

                            return nsCurrWSDocFilespec

                        else

                            return missing value -- nil

                        end if

                    end tell

                end if

                return missing value -- nil

            end setAppWorkSpaceDocFile
            """;

        let nsAppleScript:NSAppleScript = NSAppleScript(source: sAppleScriptText1)!;
        let bScriptCompileOk            = nsAppleScript.compileAndReturnError(nil);

        if (bScriptCompileOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The NSAppleScript compile failed ('bScriptCompileOk' [\(bScriptCompileOk)]) - Error!");

            return false;

        }

        let nsScriptParms:NSAppleEventDescriptor = NSAppleEventDescriptor.list();

        nsScriptParms.insert(NSAppleEventDescriptor(string: "DetermineCurrentXcodeWSDocFile2"), at: 0);
      
        let nsAppleEventDesc = NSAppleEventDescriptor(eventClass:       AEEventClass(kASAppleScriptSuite),  
                                                      eventID:          AEEventID(kASSubroutineEvent),  
                                                      targetDescriptor: nil,  
                                                      returnID:         AEReturnID(kAutoGenerateReturnID),  
                                                      transactionID:    AETransactionID(kAnyTransactionID));  

        nsAppleEventDesc.setDescriptor(NSAppleEventDescriptor(string: "setAppWorkSpaceDocFile"), forKeyword: AEKeyword(keyASSubroutineName));
        nsAppleEventDesc.setDescriptor(nsScriptParms, forKeyword: AEKeyword(keyDirectObject));
      
        var error:NSDictionary? = nil;
        let result              = nsAppleScript.executeAppleEvent(nsAppleEventDesc, error: &error) as NSAppleEventDescriptor?;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The NSAppleScript execution 'result' is [\(String(describing: result))] and 'error' is [\(String(describing: error))]...");

        if (result != nil)
        {

            self.sCurrentXcodeWSDocFilespec = result!.stringValue;

        }

        return true;
       
    } // End of private func retrieveXcodeWSDocFilespecV2().

} // End of class CxAppleScriptProcessor.

