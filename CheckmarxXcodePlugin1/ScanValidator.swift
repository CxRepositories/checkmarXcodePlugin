//
//  ScanValidator.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 01/02/19.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation
import Cocoa
import Carbon

class ScanValidator: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "ScanValidator";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    var id:String;
    weak var scan:Scan?;
    var scanProcessors:[ScanProcessor] = Array();

    var cxAppleScriptProcessor:CxAppleScriptProcessor = CxAppleScriptProcessor();

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
        asToString.append("'scan': [\(String(describing: self.scan))],");
        asToString.append("'scanProcessors': [\(String(describing: self.scanProcessors))],");
        asToString.append("'cxAppleScriptProcessor': [\(String(describing: self.cxAppleScriptProcessor))],");
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

    private func processScanSubmission() -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppDelegateDisplay();

        let scanProcessor = ScanProcessor();

        self.scanProcessors.append(scanProcessor);

        let dispatchGroup = DispatchGroup();

        do
        {
            
            dispatchGroup.enter();
  
            let dispatchQueue = DispatchQueue(label: "ScanProcessingBackgroundThread", qos: .userInitiated);

            dispatchQueue.async
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoking 'ScanProcessor.performScanProcessing()' - 'scan' is [\(String(describing: self.scan))]...");

                let bScanProcessedOk = scanProcessor.performScanProcessing(scan: self.scan!);

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Return from 'ScanProcessor.performScanProcessing()' - 'bScanProcessedOk' is [\(bScanProcessedOk)]...");

                dispatchGroup.notify(queue: DispatchQueue.main, execute:
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppDelegateDisplay();

                });

            }

            dispatchGroup.leave();
            
        }
        
        _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppDelegateDisplay();
        
        return true;

    } // End of private func processScanSubmission().

    func performScanValidation(scan:Scan) -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'scan' [\(scan)] as [\(scan.toString())]...");

        self.scan = scan;

        // If the 'current' Scan does NOT have a WorkSpace Document or Directory, try to find one:

        _ = self.determineScanXcodeWSDocFile();

        if (self.scan!.sAppXcodeWSDocFilespec.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The processing of the 'scan' Submission failed - there is NO WorkSpace Document or Directory to scan from - Error!");

            return false;

        }

        // Given that we have a WS Doc file/directory, determine if we have an 'active' Endpoint:

        var cxActiveDataEndpoint = CxDataRepo.sharedCxDataRepo.retrieveActiveCxDataEndpoint();

        if (cxActiveDataEndpoint != nil)
        {

            if (cxActiveDataEndpoint!.sCxEndpointName        == nil ||
                cxActiveDataEndpoint!.sCxEndpointName!.count < 1)
            {

                cxActiveDataEndpoint = nil;

            }

        }

        if (cxActiveDataEndpoint == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The processing of the 'scan' Submission failed - there is NO 'active' CxDataEndpoint to scan to - Error!");

            return false;

        }

        // We look in the 'Binds' array to see if this 'key'/'Endpoint' pair exists, if it does, 
        // then the scan 'might' be good to go.

        let cxActiveDataBind:Bind? = CxDataRepo.sharedCxDataRepo.cxDataBinds!.findBindForCxDataEndpoint(key: self.scan!.sAppXcodeWSDocFilespec, cxEndpointKey: cxActiveDataEndpoint!.sCxEndpointName!);

        if (cxActiveDataBind == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The processing of the 'scan' Submission failed - NO  'active' Bind for 'key' [\(self.scan!.sAppXcodeWSDocFilespec)] and 'endpoint' [\(String(describing: cxActiveDataEndpoint!.sCxEndpointName))] found - setting up a new 'Bind' for it...");

            let currBind:Bind = Bind();

            currBind.key           = self.scan!.sAppXcodeWSDocFilespec;
            currBind.cxEndpointKey = cxActiveDataEndpoint!.sCxEndpointName!;
            currBind.cxBindOrigin  = "CheckmarxXcodePlugin1.app";

        //  AppDelegate.ClassSingleton.cxAppDelegate!.binds = CxDataRepo.sharedCxDataRepo.cxDataBinds!.insertBind(bind: currBind, at: CxDataRepo.sharedCxDataRepo.cxDataBinds!.binds.count);
            _ = AppDelegate.ClassSingleton.cxAppDelegate!.insertObject(currBind, inBindsAtIndex: CxDataRepo.sharedCxDataRepo.cxDataBinds!.binds.count);


            CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentScanOnHold = self.scan;

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.invokeBindOrUnbindViaAPICall(bind: currBind, bCallIsForReportView: false);

            return false;

        }

        // Now we check to see if there's enough information in the 'Bind' to run a 'Scan', if not then we display the 'Bind-Report' screen:

        if (cxActiveDataBind!.cxProjectName.count < 1 ||
            cxActiveDataBind!.cxProjectId         < 0)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The processing of the 'scan' Submission failed - The 'current' Bind 'currBind' [\(cxActiveDataBind!.toString())] has NO Project Name/Id - sending the 'Bind' to be fixed...");

            CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentScanOnHold = self.scan;

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.invokeBindOrUnbindViaAPICall(bind: cxActiveDataBind!, bCallIsForReportView: false);

            return false;

        }

        // Update the scan with the Project/Id:

        self.scan!.sAppCxProjectName = cxActiveDataBind!.cxProjectName;
        self.scan!.cAppCxProjectId   = cxActiveDataBind!.cxProjectId;

        // Override the scan Attr's from the 'Bind' for: GenerateReport:true, ReportType:xml (or pdf or csv or rtf):

        if (cxActiveDataBind!.bCxBindGenerateReport == true)
        {

            switch (cxActiveDataBind!.cxBindReportType)
            {

                case "pdf", "xml", "csv", "rtf":

                    break;

                default:

                    cxActiveDataBind!.bCxBindGenerateReport = false;
                    cxActiveDataBind!.cxBindReportType      = "";

            }

        }
        else
        {

            cxActiveDataBind!.bCxBindGenerateReport = false;
            cxActiveDataBind!.cxBindReportType      = "";

        }

        let newAttr1 = Attr(name: "GenerateReport",  value: "\(cxActiveDataBind!.bCxBindGenerateReport)");
        let newAttr2 = Attr(name: "ReportType",      value: "\(cxActiveDataBind!.cxBindReportType)");

        self.scan!.appendUniqueAttr(attr: newAttr1);
        self.scan!.appendUniqueAttr(attr: newAttr2);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Overriding Scan attributes with: '\(newAttr1.name)' [\(newAttr1.value)] - '\(newAttr2.name)' [\(newAttr2.value)]...");

        // Go process the scan:

        let bProcessScanSubmissionOk  = self.processScanSubmission();
      
        if (bProcessScanSubmissionOk == false)
        {
      
            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The processing of the 'scan' Submission failed ('bProcessScanSubmissionOk' [\(bProcessScanSubmissionOk)]) - Error!");
      
            return false;
      
        }

        return true;
       
    } // End of func performScanValidation().

    private func determineScanXcodeWSDocFile() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        // Note: We check here to see if we already know the Xcode WS (WorkSpace) Doc (document) Filespec.
        //       This could be loaded from a plist or set via AppleScript. Since this can happen far after
        //       Xcode (itself) may have been terminated, we don't want to use AppleScript to 'talk' to 
        //       Xcode to try to get this value (even if Xcode is running, it may be a different instance
        //       than the one that originally setup this scan).
        //
        //       All we care about here, is if we already know a filespec, then does it exist. If so, then
        //       skip all of the AppleScript talking to Xcode to try to get this value. If it doesn't exist,
        //       then just clear the field and let the Xcode flag determine whether or not to use AppleScript.

        if (self.scan!.sAppXcodeWSDocFilespec.count > 1)
        {

            if (JsFileIO.fileExists(sFilespec: self.scan!.sAppXcodeWSDocFilespec) == false)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan's 'sAppXcodeWSDocFilespec' [\(String(describing: self.scan!.sAppXcodeWSDocFilespec))] does NOT exist - setting the field to \"\"...");

                self.scan!.sAppXcodeWSDocFilespec = "";

            }
            else
            {

                return true;

            }

        }

        var sAppXcodeWSDocFilespec:String? = nil;
        var bScanSourceIsXcode:Bool        = false;
        let scanAttr:Attr?                 = self.scan!.locateUniqueAttr(name: "CxScanSourceIsXcode");

        if (scanAttr        != nil &&
            scanAttr!.value == "true")
        {

            bScanSourceIsXcode = true;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bScanSourceIsXcode' [\(bScanSourceIsXcode)]...");

        if (bScanSourceIsXcode == true)
        {

            let (bDetermineCurrentXcodeWSDocFileOk, sCurrentXcodeWSDocFilespec) = self.cxAppleScriptProcessor.determineCurrentXcodeWSDocFile();

            if (bDetermineCurrentXcodeWSDocFileOk == false ||
                sCurrentXcodeWSDocFilespec        == nil   ||
                sCurrentXcodeWSDocFilespec!.count < 1)
            {

                sAppXcodeWSDocFilespec = nil;

            }
            else
            {

                sAppXcodeWSDocFilespec = sCurrentXcodeWSDocFilespec;

            }

        }

        if (sAppXcodeWSDocFilespec        == nil ||
            sAppXcodeWSDocFilespec!.count < 1)
        {

            // Since the 'current' Xcode WS Doc filespec is 'nil' or 'empty', search for an 'attr' that indicates the (Xcode) 'project' file:

            let scanAttr:Attr? = self.scan!.locateUniqueAttr(name: "CxXcodeWSDocFilespec");

            if (scanAttr != nil)
            {

                sAppXcodeWSDocFilespec = scanAttr!.value;

            }

        }

        if (sAppXcodeWSDocFilespec == nil)
        {

            self.scan!.sAppXcodeWSDocFilespec = "";

        }
        else
        {

            self.scan!.sAppXcodeWSDocFilespec = sAppXcodeWSDocFilespec!;

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan's 'sAppXcodeWSDocFilespec' [\(self.scan!.sAppXcodeWSDocFilespec)]...");

            let newAttr = Attr(name: "CxXcodeWSDocFilespec", value: self.scan!.sAppXcodeWSDocFilespec);
  
            self.scan!.appendUniqueAttr(attr: newAttr);
  
            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'newAttr' [\(newAttr.toString())] added to the 'attrs' of the current 'Scan'...");
  
        }

        return true;
       
    } // End of private func determineScanXcodeWSDocFile().

} // End of class ScanValidator.

//  private func retrieveXcodeWSDocFilespecV1() -> Bool
//  {
//      
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'scan' [\(String(describing: self.scan))] as [\(self.scan!.toString())]...");
//
//      if (self.cxAppleScriptProcessor == nil)
//      {
//
//          // AppleScriptObjC (ASOC) setup:
//
//          Bundle.main.loadAppleScriptObjectiveCScripts();
//
//          // Create an instance of CheckmarxXcodeApp1Bridge script object for Swift code to use:
//
//          let cxAppleScriptProcessorClass:AnyClass = NSClassFromString("CheckmarxXcodeApp1Bridge")!;
//          self.cxAppleScriptProcessor              = (cxAppleScriptProcessorClass.alloc() as! CheckmarxXcodeApp1Bridge);
//
//      }
//
//      let bIsAppXcodeRunning:Bool           = cxAppleScriptProcessor!.isAppRunning;
//      let bIsAppXcodeWSDocLoaded:Bool       = cxAppleScriptProcessor!.isAppWorkSpaceDocLoaded;
//      var sAppXcodeWSDocFilespec:String     = "";
//      var nsAppXcodeWSDocFilespec:NSString? = cxAppleScriptProcessor!.appWorkSpaceDocFile();
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<Before Validation>:...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'scan' [\(String(describing: self.scan))] as [\(self.scan!.toString())]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeRunning' [\(bIsAppXcodeRunning)]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeWSDocLoaded' [\(bIsAppXcodeWSDocLoaded)]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'sAppXcodeWSDocFilespec' [\(sAppXcodeWSDocFilespec)]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsAppXcodeWSDocFilespec' [\(String(describing: nsAppXcodeWSDocFilespec))]...");
//
//      if (nsAppXcodeWSDocFilespec != nil)
//      {
//
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsAppXcodeWSDocFilespec' [\(String(describing: nsAppXcodeWSDocFilespec))] is NOT 'nil' - converting to 'String'...");
//
//      }
//      else
//      {
//
//          let sScanId:String    = self.scan!.id;
//          let sScanTitle:String = self.scan!.title;
//          
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsAppXcodeWSDocFilespec' [\(String(describing: nsAppXcodeWSDocFilespec))] IS 'nil' - invoking cxAppleScriptProcessor!.setAppWorkSpaceDocFile(sCurrScanTitle: '\(sScanTitle)') as {idCurrScan: '\(sScanId)'}...");
//          
//          let nsAEDesc:NSAppleEventDescriptor = NSAppleEventDescriptor(string: sScanTitle);
//
//          nsAppXcodeWSDocFilespec = cxAppleScriptProcessor!.setAppWorkSpaceDocFile(sCurrScanTitle: nsAEDesc);
//
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"AppleScript returned 'nsAppXcodeWSDocFilespec' [\(String(describing: nsAppXcodeWSDocFilespec))]...");
//
//      }
//
//      var newAttr:Attr? = nil;
//
//      if (nsAppXcodeWSDocFilespec != nil)
//      {
//
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsAppXcodeWSDocFilespec' [\(String(describing: nsAppXcodeWSDocFilespec))] is NOT 'nil' - converting to 'String'...");
//
//          sAppXcodeWSDocFilespec = nsAppXcodeWSDocFilespec! as String;
//
//          newAttr = Attr(name: "CxXcodeWSDocFilespec", value:sAppXcodeWSDocFilespec);
//
//          self.scan!.appendUniqueAttr(attr: newAttr!);
//
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'newAttr' [\(newAttr!.toString())] added to the 'attrs' of the current 'Scan'...");
//
//      }
//      else
//      {
//
//          let scanAttr:Attr? = self.scan!.locateUniqueAttr(name: "CxXcodeWSDocFilespec");
//
//          if (scanAttr != nil)
//          {
//
//              sAppXcodeWSDocFilespec  = scanAttr!.value;
//              nsAppXcodeWSDocFilespec = NSString(string: sAppXcodeWSDocFilespec);
//
//          }
//
//      }
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<After Validation>:...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'scan' [\(String(describing: self.scan))] as [\(self.scan!.toString())]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeRunning' [\(bIsAppXcodeRunning)]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bIsAppXcodeWSDocLoaded' [\(bIsAppXcodeWSDocLoaded)]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'sAppXcodeWSDocFilespec' [\(sAppXcodeWSDocFilespec)]...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'nsAppXcodeWSDocFilespec' [\(String(describing: nsAppXcodeWSDocFilespec))]...");
//
//      if (newAttr != nil)
//      {
//
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'newAttr' [\(newAttr!.toString())]...");
//
//      }
//
//      self.scan!.sAppXcodeWSDocFilespec = sAppXcodeWSDocFilespec;
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<After 'scan' fix-up>:...");
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'scan' [\(String(describing: self.scan))] as [\(self.scan!.toString())]...");
//
//      return true;
//     
//  } // End of private func retrieveXcodeWSDocFilespecV1().
//
//  private func retrieveXcodeWSDocFilespecV2() -> Bool
//  {
//      
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'scan' [\(String(describing: self.scan))] as [\(self.scan!.toString())]...");
//
//      let sAppleScriptText1:String =
//          """
//          on setAppWorkSpaceDocFile(sCurrScanTitle as string)
//
//              set isAppXcodeRunning to running of application "Xcode"
//
//              if isAppXcodeRunning = true then
//
//                  tell application "Xcode"
//
//                      set currWSDoc to active workspace document
//                      set isAppXcodeWSDocLoaded to false
//
//                      try
//
//                          set isAppXcodeWSDocLoaded to loaded of currWSDoc
//
//                      on error
//
//                          set isAppXcodeWSDocLoaded to false
//
//                      end try
//
//                      if isAppXcodeWSDocLoaded = true then
//
//                          set nsCurrWSDocFile to file of currWSDoc
//                          set nsCurrWSDocFilespec to quoted form of (POSIX path of (nsCurrWSDocFile))
//
//                      --  tell application "CheckmarxXcodePlugin1"
//                      --
//                      --      --	set currScan to scan id idCurrScan
//                      --      set currScan to scan sCurrScanTitle
//                      --      --  set newAttr1 to make new attr with properties {name:"CxXcodeWSDocFilespec", value:nsCurrWSDocFilespec} at end of every attr of currScan
//                      --
//                      --  end tell
//
//                          return nsCurrWSDocFilespec
//
//                      else
//
//                          return missing value -- nil
//
//                      end if
//
//                  end tell
//
//              end if
//
//              return missing value -- nil
//
//          end setAppWorkSpaceDocFile
//          """;
//
//      let nsAppleScript:NSAppleScript = NSAppleScript(source: sAppleScriptText1)!;
//      let bScriptCompileOk            = nsAppleScript.compileAndReturnError(nil);
//
//      if (bScriptCompileOk == false)
//      {
//
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The NSAppleScript compile failed ('bScriptCompileOk' [\(bScriptCompileOk)]) - Error!");
//
//          return false;
//
//      }
//
//      let nsScriptParms:NSAppleEventDescriptor = NSAppleEventDescriptor.list();
//
//      nsScriptParms.insert(NSAppleEventDescriptor(string: self.scan!.title), at: 0);
//    
//      let nsAppleEventDesc = NSAppleEventDescriptor(eventClass:       AEEventClass(kASAppleScriptSuite),  
//                                                    eventID:          AEEventID(kASSubroutineEvent),  
//                                                    targetDescriptor: nil,  
//                                                    returnID:         AEReturnID(kAutoGenerateReturnID),  
//                                                    transactionID:    AETransactionID(kAnyTransactionID));  
//
//      nsAppleEventDesc.setDescriptor(NSAppleEventDescriptor(string: "setAppWorkSpaceDocFile"), forKeyword: AEKeyword(keyASSubroutineName));
//      nsAppleEventDesc.setDescriptor(nsScriptParms, forKeyword: AEKeyword(keyDirectObject));
//    
//      var error:NSDictionary? = nil;
//      let result              = nsAppleScript.executeAppleEvent(nsAppleEventDesc, error: &error) as NSAppleEventDescriptor?;
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The NSAppleScript execution 'result' is [\(String(describing: result))] and 'error' is [\(String(describing: error))]...");
//
//      var sAppXcodeWSDocFilespec:String? = nil;
//      let scanAttr:Attr?                 = self.scan!.locateUniqueAttr(name: "CxXcodeWSDocFilespec");
//
//      if (scanAttr != nil)
//      {
//
//          sAppXcodeWSDocFilespec = scanAttr!.value;
//
//      }
//
//      if (sAppXcodeWSDocFilespec == nil &&
//          result                 != nil)
//      {
//
//          sAppXcodeWSDocFilespec = result!.stringValue;
//
//          let newAttr = Attr(name: "CxXcodeWSDocFilespec", value:sAppXcodeWSDocFilespec!);
//
//          self.scan!.appendUniqueAttr(attr: newAttr);
//
//          self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'newAttr' [\(newAttr.toString())] added to the 'attrs' of the current 'Scan'...");
//
//      }
//
//      if (sAppXcodeWSDocFilespec == nil)
//      {
//
//          self.scan!.sAppXcodeWSDocFilespec = "";
//
//      }
//      else
//      {
//
//          self.scan!.sAppXcodeWSDocFilespec = sAppXcodeWSDocFilespec!;
//
//      }
//
//      return true;
//     
//  } // End of private func retrieveXcodeWSDocFilespecV2().

