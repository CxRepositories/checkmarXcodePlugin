//
//  ScanProcessor.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 01/02/19.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation
import Cocoa

class ScanProcessor: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "ScanProcessor";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    var id:String;
    weak var scan:Scan?;

    var restURLProcessor:RestURLProcessor?;
    var restURLResponse:RestURLResponse?;
    var restCxDataEndpoint:CxDataEndpoint?;
    var restCxDataBind:Bind?

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
        asToString.append("'restURLProcessor': [\(String(describing: self.restURLProcessor))],");
        asToString.append("'restURLResponse': [\(String(describing: self.restURLResponse))],");
        asToString.append("'restCxDataEndpoint': [\(String(describing: self.restCxDataEndpoint))],");
        asToString.append("'restCxDataBind': [\(String(describing: self.restCxDataBind))],");
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

        self.restURLProcessor              = RestURLProcessor(scanProcessor:self);
        self.restURLProcessor?.restURLData = self.createDefaultRestURLData();
        
    } // End of (override) init().

    private func createDefaultRestURLData() -> RestURLData
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let restURLData = RestURLData();

        return restURLData;
       
    } // End of func createDefaultRestURLData().

    private func traceLastCxAPIOutput(adJsonAPIRespResult:[NSDictionary]? = nil, sJsonAPIName:String = "") -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sJsonAPIName' [\(sJsonAPIName)]...");

        var sCxDataEndpointKey = "Unknown";

        if (self.restCxDataEndpoint != nil)
        {

            sCxDataEndpointKey = self.restCxDataEndpoint!.sCxEndpointName!;

        }

        if (adJsonAPIRespResult != nil &&
            adJsonAPIRespResult!.count > 0)
        {

            CxDataRepo.sharedCxDataRepo.storeJsonAPIResponseInCxDataRepo(sCxDataEndpointKey: sCxDataEndpointKey, sJsonAPIKey: sJsonAPIName, jsonAPIResponse: adJsonAPIRespResult as AnyObject);

        }

        return true;
       
    } // End of func traceLastCxAPIOutput().

    func performScanProcessing(scan:Scan) -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'scan' [\(scan)]...");

        self.scan            = scan;
        self.scan!.completed = false;

        if (self.restURLProcessor == nil)
        {

            self.restURLProcessor = RestURLProcessor(scanProcessor:self);

        }

        if (self.restURLProcessor?.restURLData == nil)
        {

            self.restURLProcessor?.restURLData = self.createDefaultRestURLData();

        }

        let cxActiveDataEndpoint = CxDataRepo.sharedCxDataRepo.retrieveActiveCxDataEndpoint();

        if (cxActiveDataEndpoint != nil)
        {

            self.restURLProcessor?.restURLData!.cxDataEndpoint = cxActiveDataEndpoint;

            if (cxActiveDataEndpoint != self.restCxDataEndpoint)
            {

                self.restCxDataEndpoint = cxActiveDataEndpoint;

            }

        }
        else
        {

            self.restCxDataEndpoint = nil;

            let sScanProcessorStatusMsg = " - - - - - - - - - -\nERROR: NO CxDataEndpoint is 'active' - the CxAPI cannot be used - use the 'Preferences' to select an 'active' CxDataEndpoint!";

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;

        }

        let cxActiveDataBind:Bind? = CxDataRepo.sharedCxDataRepo.cxDataBinds!.findBindForCxDataEndpoint(key: self.scan!.sAppXcodeWSDocFilespec, cxEndpointKey: self.restCxDataEndpoint!.sCxEndpointName!);

        if (cxActiveDataBind != nil)
        {

            self.restCxDataBind = cxActiveDataBind;

        }
        else
        {

            self.restCxDataBind = nil;

            let sScanProcessorStatusMsg = " - - - - - - - - - -\nNO CxDataBind is matched for this 'scan' - the CxAPI cannot be used - make sure the .plist has a matchable 'bind' - Error!";

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;

        }

        if (self.restCxDataEndpoint!.sURLAccessToken.count < 1)
        {

            let bCxAPILoginOk = self.issueCxAPITokenAuth();

            if (bCxAPILoginOk == false)
            {

                self.restCxDataEndpoint = nil;

                let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] 'login' Request failed - Error:");

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                DispatchQueue.main.async
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                }   

                return false;

            }

        }

        let bCxAPIProjectDetailsOk = self.issueCxAPIGetAllProjectDetails();
      
        if (bCxAPIProjectDetailsOk == false)
        {
      
            let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] 'get' ALL Project Detail(s) Request failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;
      
        }
      
        let bCxAPIPresetDetailsOk = self.issueCxAPIGetAllPresetDetails();
      
        if (bCxAPIPresetDetailsOk == false)
        {
      
            let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] 'get' ALL Preset Detail(s) Request failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;
      
        }
      
        let bCxAPIEngineConfigurationsDetailsOk = self.issueCxAPIGetAllEngineConfigurationsDetails();
      
        if (bCxAPIEngineConfigurationsDetailsOk == false)
        {
      
            let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] 'get' ALL Engine Configuration(s) Detail(s) Request failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;
      
        }
      
        let bCxAPIUploadOk = self.issueCxAPIUploadSourceCodeZipfile();
      
        if (bCxAPIUploadOk == false)
        {
      
            let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] 'upload' ZipFile Request failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;
        //  return false;
      
        }
      
        let bCxAPISastScanOk = self.issueCxAPICreateNewSASTScan();
      
        if (bCxAPISastScanOk == false)
        {
      
            let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] 'create' NEW 'scan' Request failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;
      
        }

        var sScanProcessorStatusMsg = "The CxAPI Sast 'create' NEW 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] was successful...\n - - - - - - - - - -";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

        DispatchQueue.main.async
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

        }   

        // Delay for 6 seconds to let the Cx Manager recognize the Scan...

        usleep(6000000);

        // Status of the scan can be: 
        //     1="New", 
        //     2="PreScan", 
        //     3="Queued", 
        //     4="Scanning", 
        //     6="PostScan", 
        //     7="Finished", 
        //     8="Canceled", 
        //     9="Failed", 
        //     10="SourcePullingAndDeployment", 
        //     1001="None".
        //
        //  status =
        //  {
        //      details =
        //      {
        //          stage = "Scan completed";
        //          step = "";
        //      };
        //      id = 7;
        //      name = Finished;
        //  };

        let aiScanStatusInProcess:[Int] = [1, 2, 3, 4, 6, 10, 1001];
        let aiScanStatusCompleted:[Int] = [7, 8, 9];

        var bScanIsComplete:Bool    = false;
        var bScanCompletedOk:Bool   = false;
        var bScanIsSynchronous:Bool = false;
        let scanAttr:Attr?          = self.scan!.locateUniqueAttr(name: "Synchronous");

        if (scanAttr        != nil &&
            scanAttr!.value == "true")
        {

            bScanIsSynchronous = true;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bScanIsSynchronous' [\(bScanIsSynchronous)]...");

        repeat
        {

            let bCxAPISastScanDetailsOk = self.issueCxAPIGetSASTScanDetailsByScanId();
          
            if (bCxAPISastScanDetailsOk == false)
            {
          
                let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI 'get' Sast 'scan' Details by 'scan' ID Request failed - Error:");

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                DispatchQueue.main.async
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                }   

                return false;
          
            }

            let bScanStatusInProcess:Bool = aiScanStatusInProcess.contains(self.scan!.idAppLastSASTScanStatus);
            let bScanStatusCompleted:Bool = aiScanStatusCompleted.contains(self.scan!.idAppLastSASTScanStatus);

            if (bScanStatusInProcess == false &&
                bScanStatusCompleted == false)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' Scan 'status' for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] of (\(self.scan!.idAppLastSASTScanStatus)):[\(self.scan!.sAppLastSASTScanStatus)] is 'invalid' - Error!");

                bScanIsComplete  = true;
                bScanCompletedOk = false;

                break;

            }

            if (bScanStatusCompleted == true)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' Scan 'status' for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] of (\(self.scan!.idAppLastSASTScanStatus)):[\(self.scan!.sAppLastSASTScanStatus)] indicates the Scan is 'complete'...");

                bScanIsComplete  = true;
                bScanCompletedOk = true;

                continue;

            }

            if (bScanIsSynchronous == false)
            {

                sScanProcessorStatusMsg = "The CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] is 'asynchronous' - scan is continuing separately (requests for reports will NOT be processed)...\n - - - - - - - - - -";

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                DispatchQueue.main.async
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                }   

                return true;

            }

            // Delay for 10 seconds to let the Cx Manager process the Scan...

            usleep(10000000);

        } while bScanIsComplete == false;

        self.scan!.completed = bScanIsComplete;

        let newAttr3 = Attr(name: "CxScanIsComplete",  value: "\(bScanIsComplete)");
        let newAttr4 = Attr(name: "CxScanCompletedOk", value: "\(bScanCompletedOk)");

        self.scan!.appendUniqueAttr(attr: newAttr3);
        self.scan!.appendUniqueAttr(attr: newAttr4);

        sScanProcessorStatusMsg = "The CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] 'completed' Ok? [\(bScanCompletedOk)] and is 'complete'? [\(bScanIsComplete)]\n - - - - - - - - - -";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

        DispatchQueue.main.async
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

        }   

        if(bScanIsComplete  == true &&
           bScanCompletedOk == true)
        {

            if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
            {

                DispatchQueue.main.async
                {

                    MainViewController.ClassSingleton.cxAppMainViewController!.sMainViewDisplay = ">>> Scan ID [\(self.scan!.sAppLastSASTScanId)] completed successfully...";

                    MainViewController.ClassSingleton.cxAppMainViewController!.updateMainViewDisplay();

                }   

            }

        }
        else
        {

            if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
            {

                DispatchQueue.main.async
                {

                    MainViewController.ClassSingleton.cxAppMainViewController!.sMainViewDisplay = ">>> Scan ID [\(self.scan!.sAppLastSASTScanId)] failed - Error!";

                    MainViewController.ClassSingleton.cxAppMainViewController!.updateMainViewDisplay();

                }   

            }

        }

        var bContinueScanProcessing = false;

        if (bScanIsComplete  == true &&
            bScanCompletedOk == true)
        {

            bContinueScanProcessing = true;

        }
        else
        {

            sScanProcessorStatusMsg = "\n - - - - - - - - - -\nThe CxAPI Sast 'scan' with a Scan ID of [\(self.scan!.sAppLastSASTScanId)] having 'completed' Ok? [\(bScanCompletedOk)] and is 'complete'? [\(bScanIsComplete)] indicates a 'partial' scan failure - Error!\n - - - - - - - - - -";

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;

        }

        // Check the scan Attr's for: GenerateReport:true, ReportType:xml (or pdf or csv or rtf):

        let scanAttr1:Attr? = self.scan!.locateUniqueAttr(name: "GenerateReport");

        if (scanAttr1        != nil &&
            scanAttr1!.value == "true")
        {

            bContinueScanProcessing = true;

        }
        else
        {

            bContinueScanProcessing = false;

        }

        let scanAttr2:Attr? = self.scan!.locateUniqueAttr(name: "ReportType");

        if (scanAttr2              != nil &&
            scanAttr2!.value.count > 0)
        {

            let sScanReportType = scanAttr2!.value.lowercased();

            if (sScanReportType == "pdf" ||
                sScanReportType == "rtf" ||
                sScanReportType == "csv" ||
                sScanReportType == "xml")
            {

                self.scan!.sAppLastSASTScanReportType = sScanReportType;

                bContinueScanProcessing = true;

            }
            else
            {

                sScanProcessorStatusMsg = "\n - - - - - - - - - -\nThe CxAPI Sast 'scan' with a Scan ID of [\(self.scan!.sAppLastSASTScanId)] is requesting an INVALID Report type of [\(sScanReportType)] - Error!\n - - - - - - - - - -";

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                DispatchQueue.main.async
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                }   

                return false;

            }

        }
        else
        {

            bContinueScanProcessing = false;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"After 'attr' check for 'GenerateReport': 'bContinueScanProcessing' [\(bContinueScanProcessing)]...");

        if (bContinueScanProcessing == false)
        {

            return true;

        }

        let bCxAPIRegisterSastScanReportOk = self.issueCxAPIRegisterSASTScanReport();
      
        if (bCxAPIRegisterSastScanReportOk == false)
        {
      
            let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Register Sast 'scan' Report failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;
      
        }

        // Report Status of the scan can be: 
        //     0="Deleted", 
        //     1="InProcess", 
        //     2="Created", 
        //     3="Failed" 
        //
        //  "status": {
        //  "id": 2,
        //  "value": "Created"
        //  }

        let aiScanReportStatusInProcess:[Int] = [1];
        let aiScanReportStatusCompleted:[Int] = [0, 2, 3];

        var bScanReportIsComplete:Bool        = false;
        var bScanReportCompletedOk:Bool       = false;

        repeat
        {

            let bCxAPIGetSASTScanReportStatusByIdOk = self.issueCxAPIGetSASTScanReportStatusById();

            if (bCxAPIGetSASTScanReportStatusByIdOk == false)
            {

                let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI 'get' Sast 'scan' Report Status by ID Request failed - Error:");

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                DispatchQueue.main.async
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                }   

                return false;

            }

            let bScanReportStatusInProcess:Bool = aiScanReportStatusInProcess.contains(self.scan!.idAppLastSASTScanReportStatus);
            let bScanReportStatusCompleted:Bool = aiScanReportStatusCompleted.contains(self.scan!.idAppLastSASTScanReportStatus);

            if (bScanReportStatusInProcess == false &&
                bScanReportStatusCompleted == false)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' Scan Report 'status' for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] of (\(self.scan!.idAppLastSASTScanReportStatus)):[\(self.scan!.sAppLastSASTScanReportValue)] is 'invalid' - Error!");

                bScanReportIsComplete  = true;
                bScanReportCompletedOk = false;

                break;

            }

            if (bScanReportStatusCompleted == true)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' Scan Report 'status' for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] of (\(self.scan!.idAppLastSASTScanReportStatus)):[\(self.scan!.sAppLastSASTScanReportValue)] indicates the Scan is 'complete'...");

                bScanReportIsComplete  = true;
                bScanReportCompletedOk = true;

                continue;

            }

            // Delay for 10 seconds to let the Cx Manager process the Scan Report...

            usleep(10000000);

        } while bScanReportIsComplete == false;

        let newAttr5 = Attr(name: "CxScanReportIsComplete",  value: "\(bScanReportIsComplete)");
        let newAttr6 = Attr(name: "CxScanReportCompletedOk", value: "\(bScanReportCompletedOk)");

        self.scan!.appendUniqueAttr(attr: newAttr5);
        self.scan!.appendUniqueAttr(attr: newAttr6);

        sScanProcessorStatusMsg = "The CxAPI Sast 'scan' Request for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] 'completed' Ok? [\(bScanReportCompletedOk)] and is 'complete'? [\(bScanReportIsComplete)]\n - - - - - - - - - -";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

        DispatchQueue.main.async
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

        }   

        if (bScanReportCompletedOk == false)
        {

            let sScanProcessorStatusMsg = "The CxAPI Sast 'scan' Report request(s) for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] were NOT successful - Error!\n - - - - - - - - - -";

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;

        }

        let bCxAPIGetSastScanReportByIdOk = self.issueCxAPIGetSASTScanReportById();
      
        if (bCxAPIGetSastScanReportByIdOk == false)
        {
      
            let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Get Sast 'scan' for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] Report by ID of [\(self.scan!.sAppLastSASTScanReportId)] failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

            }   

            return false;
      
        }

        sScanProcessorStatusMsg = "The CxAPI Sast 'scan' Report request(s) for a Scan ID of [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] were successful...\n - - - - - - - - - -";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

        DispatchQueue.main.async
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

        }   

        return true;
       
    } // End of func performScanProcessing().

    func issueCxAPITokenAuth() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = 
        [
            "Content-Type":  "application/x-www-form-urlencoded",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
        ];

        let sUsername = self.restURLProcessor?.restURLData!.cxDataEndpoint!.sUsername ?? "";
        let sPassword = self.restURLProcessor?.restURLData!.cxDataEndpoint!.sPassword ?? "";

        let postJsonData = NSMutableData(data: "username=\(sUsername)".data(using: String.Encoding.utf8)!);

        postJsonData.append("&password=\(sPassword)".data(using: String.Encoding.utf8)!);
        postJsonData.append("&grant_type=password".data(using: String.Encoding.utf8)!);
        postJsonData.append("&scope=sast_rest_api".data(using: String.Encoding.utf8)!);
        postJsonData.append("&client_id=resource_owner_client".data(using: String.Encoding.utf8)!);
        postJsonData.append("&client_secret=014DF517-39D1-4453-B7B3-9930C563627C".data(using: String.Encoding.utf8)!);

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/auth/identity/connect/token";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "POST";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;
        postJsonRequest.httpBody            = postJsonData as Data;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200, 500];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: true);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "AuthIdentityToken");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

        //  self.sRestURLAccessToken = "";
            self.restCxDataEndpoint  = nil;

            return false;

        }

        if (self.restURLProcessor!.adJsonResult.count > 0)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'deserialized' JSON result array 'adJsonResult' contains (\(self.restURLProcessor!.adJsonResult.count)) lines...");

            for (i, dictJsonResult) in self.restURLProcessor!.adJsonResult.enumerated()
            {

                var j = 0;

                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {

                    j += 1;

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");

                    if (dictJsonKey as! String == "access_token")
                    {
                  
                        self.restCxDataEndpoint!.sURLAccessToken = dictJsonValue as! String;
                  
                    }

                }

            }

        }

        return true;
       
    } // End of func issueCxAPITokenAuth().

    func issueCxAPIGetAllProjectDetails() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = 
        [
            "Content-Type":  "application/json;v1.0 / 2.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
        ];

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/projects";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "GET";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "GetAllProjectDetails");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }
        
        if (self.restURLProcessor!.adJsonResult.count > 0)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'deserialized' JSON result array 'adJsonResult' contains (\(self.restURLProcessor!.adJsonResult.count)) lines...");

            for (i, dictJsonResult) in self.restURLProcessor!.adJsonResult.enumerated()
            {

                var j            = 0;
                var idProject    = 0;
                var sProjectName = "";

                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {

                    j += 1;

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");

                    if (dictJsonKey as! String == "id")
                    {
                  
                        idProject = dictJsonValue as! Int;
                  
                    }

                    if (dictJsonKey as! String == "name")
                    {
                  
                        sProjectName = dictJsonValue as! String;
                  
                    }

                }

                if (self.restCxDataBind                != nil &&
                    self.restCxDataBind!.cxProjectName == sProjectName)
                {

                    if (self.restCxDataBind!.cxProjectId < 1)
                    {

                        self.restCxDataBind!.cxProjectId = idProject;

                    }

                    let newAttr1 = Attr(name: "CxRestProjectId", value: "\(self.restCxDataBind!.cxProjectId)");

                    self.scan!.appendUniqueAttr(attr: newAttr1);

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Project Id 'newAttr1' [\(newAttr1.toString())] added to the 'attrs' of the current 'Scan'...");

                    var newAttr2:Attr? = self.scan!.locateUniqueAttr(name: "Project");

                    if (newAttr2 == nil)
                    {

                        newAttr2 = Attr(name: "Project", value: "\(self.restCxDataBind!.cxProjectName)");

                        self.scan!.appendUniqueAttr(attr: newAttr2!);

                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Project name 'newAttr2' [\(newAttr2!.toString())] added to the 'attrs' of the current 'Scan'...");

                    }
                    else
                    {

                        if (sProjectName.count > 0)
                        {

                            newAttr2 = Attr(name: "Project", value: "\(self.restCxDataBind!.cxProjectName)");

                            self.scan!.appendUniqueAttr(attr: newAttr2!);

                            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Project name 'newAttr2' [\(newAttr2!.toString())] added to the 'attrs' of the current 'Scan' (overriding the current setting)...");

                        }

                    }

                }

            }

        }

        return true;
       
    } // End of func issueCxAPIGetAllProjectDetails().

    func issueCxAPIGetAllPresetDetails() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = 
        [
            "Content-Type":  "application/json;v1.0 / 2.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
        ];

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/sast/presets";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "GET";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "GetAllPresetDetails");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        return true;
       
    } // End of func issueCxAPIGetAllPresetDetails().

    func issueCxAPIGetAllEngineConfigurationsDetails() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = 
        [
            "Content-Type":  "application/json;v1.0 / 2.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
        ];

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/sast/engineConfigurations";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "GET";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "GetAllEngineConfigurationsDetails");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        return true;
       
    } // End of func issueCxAPIGetAllEngineConfigurationsDetails().

    func issueCxAPIUploadSourceCodeZipfile() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.scan!.sAppXcodeWSDocFilespec.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the Zip file failed - the Zip 'source' (Xcode WS Doc filespec) is 'empty' - Error!");

            return false;

        }
        
        let sZipSource:String   = self.scan!.sAppXcodeWSDocFilespec;
        var sZipFilespec:String = "";

        if (sZipSource.hasSuffix(".zip") == true)
        {

            sZipFilespec = sZipSource;

            if (JsFileIO.fileExists(sFilespec: sZipFilespec) == false)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For the ZipFile [\(sZipFilespec)] - the file does NOT exist - Error!");

                return false;

            }

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Uploading the current ZipFile [\(sZipFilespec)] from the Zip 'source' [\(sZipSource)]...");

        }
        else
        {

            sZipFilespec = "~/jweb/Temp-Upload/Project-\(self.restCxDataBind!.cxProjectId)_Scan-\(self.scan!.id)_GeneratedUpLoad.zip";

            if (sZipFilespec.hasPrefix("~/") == true)
            {

                sZipFilespec = NSString(string: sZipFilespec).expandingTildeInPath as String;

            }

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoking 'self.performZipFileCreation()' to create ZipFile [\(sZipFilespec)] from the Zip 'source' [\(sZipSource)]...");

            var asInclude:[String]?   = nil;
            let scanAttrInclude:Attr? = self.scan!.locateUniqueAttr(name: "Include");

            if (scanAttrInclude              != nil &&
                scanAttrInclude!.value.count > 0)
            {

                asInclude = scanAttrInclude!.value.components(separatedBy: ";");

            }

            var asExclude:[String]?   = nil;
            let scanAttrExclude:Attr? = self.scan!.locateUniqueAttr(name: "Exclude");

            if (scanAttrExclude              != nil &&
                scanAttrExclude!.value.count > 0)
            {

                asExclude = scanAttrExclude!.value.components(separatedBy: ";");

            }

        //  let asInclude:[String]? =
        //  [
        //      "*.swift",
        //      "*.applescript"
        //  ];
        //
        //  let asExclude:[String]? = nil;

            let bZipFileCreatedOk = self.performZipFileCreation(sZipFilespec: sZipFilespec, sZipSource: sZipSource, asInclude: asInclude, asExclude: asExclude);

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Return from 'self.performZipFileCreation()' to create ZipFile [\(sZipFilespec)] from the Zip 'source' [\(sZipSource)] - 'bZipFileCreatedOk' is [\(bZipFileCreatedOk)]...");

            if (bZipFileCreatedOk == false)
            {

                return false;

            }

        }

        self.scan!.sAppUploadZipFilespec = sZipFilespec;

        let sScanProcessorStatusMsg = "The CxAPI Sast 'scan' is using the ZipFile [\(sZipFilespec)] from the Zip 'source' [\(sZipSource)]...";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

        DispatchQueue.main.async
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

        }   

        let sFormBoundary = self.restURLProcessor!.generateURLRequestBoundaryString();

        let asJsonHeaders = 
        [
        //  "Content-Type":    "application/json;v1.0",
            "Content-Type":    "multipart/form-data; boundary=\(sFormBoundary)",
            "Authorization":   "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":        "CheckmarxXcodePlugin1",
        //  "Accept":          "application/json",
            "Accept":          "*/*",
            "accept-encoding": "gzip, deflate",
            "cache-control":   "no-cache"
        ];

        let asCxURLParameters = 
        [
            "Content-Type": "multipart/form-data",
            "id":           "\(self.restCxDataBind!.cxProjectId)"
        ];
        //  "id":           "170017"

        var svHttpParams:[String] = Array();

        for (sHttpName, sHttpValue) in asCxURLParameters
        {

            svHttpParams.append("\(sHttpName)=\(sHttpValue)");

        }

    //  self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/projects/170017/sourceCode/attachments";
        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/projects/\(self.restCxDataBind!.cxProjectId)/sourceCode/attachments";
        self.restURLProcessor!.restURLData!.sHttpParams = svHttpParams.joined(separator: "&");

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Zipfile 'loading' - 'sGeneratedHttpURL' [\(self.restURLProcessor!.restURLData!.sHttpGeneratedURL)]...");

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "POST";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;
        postJsonRequest.httpBody            = self.createHttpBodyFromBinaryFile(asParameters: nil, sFilespec: sZipFilespec, sBoundary: sFormBoundary) as Data;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Zipfile 'loading' - 'postJsonRequest.httpBody' len (\(postJsonRequest.httpBody!.count))...");

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [204];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: true);

        defer
        {

        //  _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "UploadSourceCodeZipfile");
            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: nil, sJsonAPIName: "UploadSourceCodeZipfile");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        return true;
       
    } // End of func issueCxAPIUploadSourceCodeZipfile().

    func issueCxAPICreateNewSASTScan() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = [
            "Content-Type":  "application/json;v1.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
            ];

    //  let postJsonData = NSMutableData(data: "{projectId:1,".data(using: String.Encoding.utf8)!);
    //  let postJsonData = NSMutableData(data: "{projectId:170017,".data(using: String.Encoding.utf8)!);
        let postJsonData = NSMutableData(data: "{projectId:\(self.restCxDataBind!.cxProjectId),".data(using: String.Encoding.utf8)!);

    //  postJsonData.append("isIncremental:false,".data(using: String.Encoding.utf8)!);
        postJsonData.append("isIncremental:\(self.scan!.fullScan),".data(using: String.Encoding.utf8)!);
        postJsonData.append("isPublic:true,".data(using: String.Encoding.utf8)!);
        postJsonData.append("forceScan:true,".data(using: String.Encoding.utf8)!);
        postJsonData.append("comment:\"Scan from CheckmarxXcodePlugin1\"}".data(using: String.Encoding.utf8)!);

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/sast/scans";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "POST";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;
        postJsonRequest.httpBody            = postJsonData as Data;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [201];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "CreateNewSASTScan");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        let adJsonAPIResult:[NSDictionary] = self.restURLResponse!.adRestURLResponseResult;

        if (adJsonAPIResult.count > 0)
        {

            for (i, dictJsonResult) in adJsonAPIResult.enumerated()
            {

                var j = 0;

                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {

                    j += 1;

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");

                    if (dictJsonKey as! String == "id")
                    {

                        let newAttr = Attr(name: "CxSubmittedScanId", value: "\((dictJsonValue as! Int))");
                        
                        self.scan!.appendUniqueAttr(attr: newAttr);

                        self.scan!.sAppLastSASTScanId = newAttr.value;

                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'newAttr' [\(newAttr.toString())] added to the 'attrs' of the current 'Scan'...");

                        self.restURLResponse!.sRestURLResponseError = "\(self.restURLResponse!.sRestURLResponseError)'submitted' Scan ID is [\(newAttr.value)]..."; 

                    //  let sScanProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: "The CxAPI Sast 'submitted' Scan ID is [\(newAttr.value)]...");
                        let sScanProcessorStatusMsg = "The CxAPI Sast 'submitted' Scan ID is [\(newAttr.value)]...";

                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                        DispatchQueue.main.async
                        {

                            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                        }   

                        if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
                        {

                            DispatchQueue.main.async
                            {

                                MainViewController.ClassSingleton.cxAppMainViewController!.sMainViewDisplay = ">>> Scan ID [\(self.scan!.sAppLastSASTScanId)] submitted...";

                                MainViewController.ClassSingleton.cxAppMainViewController!.updateMainViewDisplay();

                            }   

                        }

                    }

                }

            }

        }

        return true;
       
    } // End of func issueCxAPICreateNewSASTScan().

    func issueCxAPIGetSASTScanDetailsByScanId() -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = [
            "Content-Type":  "application/json;v1.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
            ];

        let asCxURLParameters = 
        [
            "id": "\(self.scan!.sAppLastSASTScanId)"
        ];

        var svHttpParams:[String] = Array();

        for (sHttpName, sHttpValue) in asCxURLParameters
        {

            svHttpParams.append("\(sHttpName)=\(sHttpValue)");

        }

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/sast/scans/\(self.scan!.sAppLastSASTScanId)";
        self.restURLProcessor!.restURLData!.sHttpParams = svHttpParams.joined(separator: "&");

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "GET";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "GetSASTScanDetailsByScanId");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        let adJsonAPIResult:[NSDictionary] = self.restURLResponse!.adRestURLResponseResult;
      
        if (adJsonAPIResult.count > 0)
        {
      
            for (i, dictJsonResult) in adJsonAPIResult.enumerated()
            {
      
                var j = 0;
      
                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {
      
                    j += 1;
      
                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");
      
                    //  status =
                    //  {
                    //      details =
                    //      {
                    //          stage = "Scan completed";
                    //          step = "";
                    //      };
                    //      id = 7;
                    //      name = Finished;
                    //  };

                    if (dictJsonKey as! String == "status")
                    {

                        let dictJsonStatus:[String:Any]     = dictJsonValue as! [String:Any]; 
                        let dictJsonDetails:[String:Any]    = dictJsonStatus["details"] as! [String:Any];
                        let bLastSASTScanStatusChanged:Bool = (self.scan!.idAppLastSASTScanStatus != (dictJsonStatus["id"]     as! Int));
                        let bLastSASTScanStageChanged:Bool  = (self.scan!.sAppLastSASTScanStage   != (dictJsonDetails["stage"] as! String));
                        var bUpdateAppStatusView:Bool       = false;

                        if (bLastSASTScanStatusChanged == true)
                        {

                            bUpdateAppStatusView = true;

                        }
                        else
                        {

                            if (bLastSASTScanStageChanged == true)
                            {

                                bUpdateAppStatusView = true;

                            }

                        }

                        self.scan!.idAppLastSASTScanStatus = dictJsonStatus["id"]     as! Int;
                        self.scan!.sAppLastSASTScanStatus  = dictJsonStatus["name"]   as! String;
                        self.scan!.sAppLastSASTScanStage   = dictJsonDetails["stage"] as! String;

                        let newAttr1 = Attr(name: "CxSubmittedScanStatusId", value: "\(self.scan!.idAppLastSASTScanStatus)");
                        let newAttr2 = Attr(name: "CxSubmittedScanStatus",   value: "\(self.scan!.sAppLastSASTScanStatus)");
                        let newAttr3 = Attr(name: "CxSubmittedScanStage",    value: "\(self.scan!.sAppLastSASTScanStage)");
      
                        self.scan!.appendUniqueAttr(attr: newAttr1);
                        self.scan!.appendUniqueAttr(attr: newAttr2);
                        self.scan!.appendUniqueAttr(attr: newAttr3);
      
                        var sScanProcessorStatusMsg = "For the 'submitted' Scan ID [\(self.scan!.sAppLastSASTScanId)] the 'status' ID is (\(newAttr1.value)) and the 'status' is [\(newAttr2.value)]..."; 

                        if (self.scan!.sAppLastSASTScanStage.count > 0)
                        {

                            sScanProcessorStatusMsg = "For the 'submitted' Scan ID [\(self.scan!.sAppLastSASTScanId)] the 'status' ID is (\(newAttr1.value)) the 'status' is [\(newAttr2.value)] and the 'stage' is [\(newAttr3.value)]..."; 

                        }
      
                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);
      
                        if (bUpdateAppStatusView == true)
                        {

                            DispatchQueue.main.async
                            {
          
                                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);
          
                            }   
          
                        }

                    }
      
                }
      
            }
      
        }

        return true;

    } // End of func issueCxAPIGetSASTScanDetailsByScanId().

    private func performZipFileCreation(sZipFilespec:String, sZipSource:String, asInclude:[String]? = nil, asExclude:[String]? = nil) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sZipFilespec' [\(sZipFilespec)] - 'sZipSource' [\(sZipSource)] - 'asInclude' [\(String(describing: asInclude))] - 'asExclude' [\(String(describing: asExclude))]...");

        if (sZipFilespec.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the 'sZipFilespec' [\(sZipFilespec)] failed - the filespec is 'empty' - Error!");

            return false;

        }
        
        var sZipFilespec:String = sZipFilespec;

        if (sZipFilespec.hasPrefix("~/") == true)
        {

            sZipFilespec = NSString(string: sZipFilespec).expandingTildeInPath as String;

        }

        let sCurrZipFilepath = (sZipFilespec as NSString).deletingLastPathComponent;

        do
        {

            try FileManager.default.createDirectory(atPath: sCurrZipFilepath, withIntermediateDirectories: true, attributes: nil)

        }
        catch
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the 'sZipFilespec' [\(sZipFilespec)] failed - unable to create the 'path' of [\(sCurrZipFilepath)] - Error: \(error)!");

        }

        if (sZipSource.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the 'sZipFilespec' [\(sZipFilespec)] failed - the zip 'source' is 'empty' - Error!");

            return false;

        }

        var sZipFromDir:String                 = sZipSource;
        let nsDictItemAttributes:NSDictionary? = try? FileManager.default.attributesOfItem(atPath: sZipFromDir) as NSDictionary;

        if (nsDictItemAttributes == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the 'sZipFilespec' [\(sZipFilespec)] failed - unable to retrieve the item attributes from a 'source' [\(sZipFromDir)] - Error!");

            return false;

        }

        if (nsDictItemAttributes!.fileType() != "NSFileTypeDirectory" &&
            nsDictItemAttributes!.fileType() != "NSFileTypeRegular")
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the 'sZipFilespec' [\(sZipFilespec)] failed - the item [\(sZipFromDir)] is NOT a valid directory NOR a file - Error!");

            return false;

        }

        let sZipFromDirLower:String = sZipFromDir.lowercased();

        if (nsDictItemAttributes!.fileType()         == "NSFileTypeRegular" ||
            sZipFromDirLower.hasSuffix(".xcodeproj") == true)
        {

            sZipFromDir = (sZipFromDir as NSString).deletingLastPathComponent;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creating the 'sZipFilespec' [\(sZipFilespec)] from the directory parent 'sZipFromDir' [\(sZipFromDir)]...");

        let sZipTaskExec   = "/usr/bin/zip";
        let pipeStdOut     = Pipe();
        let pipeStdErr     = Pipe();
        let processZipTask = Process();

        processZipTask.executableURL  = URL(fileURLWithPath: sZipTaskExec);
        processZipTask.standardOutput = pipeStdOut;
        processZipTask.standardError  = pipeStdErr;

        let asZipTaskParmsPrefix =
        [
            "-r9",
            "\(sZipFilespec)",
            "\(sZipFromDir)"
        ];

        let asZipTaskParmsSuffix =
        [
            "@"
        ];

        //  "--include",
        //  "*.swift",
        //  "*.applescript",

        var bZipParmsAdded = false;
        var asZipTaskParms = asZipTaskParmsPrefix;

        if (asInclude       != nil &&
            asInclude!.count > 0)
        {

            asZipTaskParms.append("--include");

            asZipTaskParms += asInclude!;

            bZipParmsAdded = true;

        }
        else
        {

            let sCxExtTxt:String? = CxDataRepo.sharedCxDataRepo.retrieveCxDataToCacheFromCxDataRepo(sCxDataCacheKey: "CxExt.txt") as? String;

            if (sCxExtTxt        != nil &&
                sCxExtTxt!.count > 0)
            {

                let asCxExtTxtInclude = sCxExtTxt!.components(separatedBy: ";");

                 if (asCxExtTxtInclude.count > 0)
                {

                    asZipTaskParms.append("--include");

                    asZipTaskParms += asCxExtTxtInclude;

                    bZipParmsAdded = true;

                }

            }

        }

        if (asExclude       != nil &&
            asExclude!.count > 0)
        {

            asZipTaskParms.append("--exclude");
            
            asZipTaskParms += asExclude!;

            bZipParmsAdded = true;

        }

        if (bZipParmsAdded == true)
        {

            asZipTaskParms.append(contentsOf: asZipTaskParmsSuffix);

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Create ZipFile [\(sZipFilespec)] with command parameters of [\(asZipTaskParms)]...");

        var bProcessZipTaskOk = true;

        processZipTask.arguments = asZipTaskParms;
        
        do
        {

            try processZipTask.run();

            bProcessZipTaskOk = true;

        }
        catch let error as NSError
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Failed to create ZipFile [\(sZipFilespec)] - Error: [\(error.domain)]!");

            bProcessZipTaskOk = false;

        }

        let dataStdOut = pipeStdOut.fileHandleForReading.readDataToEndOfFile();
        let sStdOutput = String(decoding: dataStdOut, as: UTF8.self);

        let dataStdErr = pipeStdErr.fileHandleForReading.readDataToEndOfFile();
        let sStdError  = String(decoding: dataStdErr, as: UTF8.self);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"ZipFile process 'stdout' was [\(sStdOutput)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"ZipFile process 'stderr' was [\(sStdError)]...");

        if (bProcessZipTaskOk == false)
        {

            return false;

        }

        if (JsFileIO.fileExists(sFilespec: sZipFilespec) == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Failed to create ZipFile [\(sZipFilespec)] - the file does NOT exist!");

            return false;

        }

        let nsDictFileAttributes:NSDictionary? = try? FileManager.default.attributesOfItem(atPath: sZipFilespec) as NSDictionary;

        if (nsDictFileAttributes == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the 'sZipFilespec' [\(sZipFilespec)] failed - unable to retrieve the File attributes - Error!");

            return false;

        }

        if (nsDictFileAttributes!.fileType() != "NSFileTypeRegular")
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Creation of the 'sZipFilespec' [\(sZipFilespec)] failed - it is NOT a valid file - Error!");

            return false;

        }

        let cZipFileSize:UInt64            = nsDictFileAttributes!.fileSize();
        let sScanProcessorStatusMsg:String = "Successfully created the ZipFile [\(sZipFilespec)] - the file exists and contains (\(cZipFileSize)) byte(s)...";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

        DispatchQueue.main.async
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

        }   
        return true;

    } // End of private func performZipFileCreation().

    private func createHttpBodyFromBinaryFile(asParameters:[String: String]? = nil, sFilespec: String, sBoundary: String) -> NSData
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'asParameters' [\(String(describing: asParameters))] - 'sFilespec' [\(sFilespec)] - 'sBoundary' [\(sBoundary)]...");

        let httpBody = NSMutableData();
  
        if asParameters != nil 
        {

            for (sParmKey, sParmValue) in asParameters! 
            {

                httpBody.append("--\(sBoundary)\r\n".data(using: String.Encoding.utf8)!)
                httpBody.append("Content-Disposition: form-data; name=\"\(sParmKey)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                httpBody.append("\(sParmValue)\r\n".data(using: String.Encoding.utf8)!)

            }

        }

    //  let sFilename           = sFilespec.lastPathComponent ?? "nil";
        let sFilename           = "PHP-Mailer.zip";
        let sMimeType           = "application/zip";
        var zipFileData:NSData  = NSData();
      
        do
        {
      
            zipFileData = try NSData(contentsOfFile: sFilespec, options: NSData.ReadingOptions.mappedIfSafe);

            // Delay for 1/4th of a second to allow the system to completely load the target file...

            usleep(250000);
      
        }
        catch let error as NSError
        {
      
            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Failed to read file [\(sFilespec)] - Error: [\(error.domain)]!");
      
            zipFileData = NSData();
      
        }
      
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'zipFileData' has a length of (\(String(describing: zipFileData.length))) bytes...");
  
        httpBody.append("--\(sBoundary)\r\n".data(using: String.Encoding.utf8)!);
        httpBody.append("Content-Disposition:form-data; name=\"zippedSource\"; filename=\"\(sFilename)\"\r\n".data(using: String.Encoding.utf8)!);
        httpBody.append("Content-Type: \(sMimeType)\r\n\r\n".data(using: String.Encoding.utf8)!);
    //  httpBody.append("Content-Type: \(sMimeType)\r\n".data(using: String.Encoding.utf8)!);
    //  httpBody.append("--\(sBoundary)\r\n".data(using: String.Encoding.utf8)!);
        httpBody.append(zipFileData as Data);
        httpBody.append("\r\n\r\n".data(using: String.Encoding.utf8)!);
    //  httpBody.append("--\(sBoundary)--\r\n\r\n\r\n\r\n".data(using: String.Encoding.utf8)!);
    //  httpBody.append("--\(sBoundary)--".data(using: String.Encoding.utf8)!);
        httpBody.append("--\(sBoundary)--\r\n".data(using: String.Encoding.utf8)!);
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Created 'httpBody' contains (\(httpBody.length)) bytes...");
  
        return httpBody;

    } // End of func createHttpBodyFromBinaryFile().

    func issueCxAPIRegisterSASTScanReport() -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = [
            "Content-Type":  "application/json;v1.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
            ];

        let postJsonData = NSMutableData(data: "{scanId:\(self.scan!.sAppLastSASTScanId),".data(using: String.Encoding.utf8)!);

        postJsonData.append("reportType:\"\(self.scan!.sAppLastSASTScanReportType)\"}".data(using: String.Encoding.utf8)!);

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/reports/sastScan";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "POST";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;
        postJsonRequest.httpBody            = postJsonData as Data;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [202];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "RegisterSASTScanReport");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        let adJsonAPIResult:[NSDictionary] = self.restURLResponse!.adRestURLResponseResult;

        if (adJsonAPIResult.count > 0)
        {

            for (i, dictJsonResult) in adJsonAPIResult.enumerated()
            {

                var j = 0;

                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {

                    j += 1;

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");

                    if (dictJsonKey as! String == "reportId")
                    {

                        let newAttr = Attr(name: "CxRegisteredScanReportId", value: "\((dictJsonValue as! Int))");

                        self.scan!.appendUniqueAttr(attr: newAttr);

                        self.scan!.sAppLastSASTScanReportId = newAttr.value;

                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'newAttr' [\(newAttr.toString())] added to the 'attrs' of the current 'Scan'...");

                        self.restURLResponse!.sRestURLResponseError = "\(self.restURLResponse!.sRestURLResponseError)'registered' Scan Report ID is [\(newAttr.value)]..."; 

                        let sScanProcessorStatusMsg = "The CxAPI Sast 'registered' Scan Report ID is [\(newAttr.value)]...";

                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                        DispatchQueue.main.async
                        {

                            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                        }   

                        if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
                        {

                            DispatchQueue.main.async
                            {

                                MainViewController.ClassSingleton.cxAppMainViewController!.sMainViewDisplay = ">>> Scan ID [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] requested...";

                                MainViewController.ClassSingleton.cxAppMainViewController!.updateMainViewDisplay();

                            }   

                        }

                    }

                }

            }

        }

        return true;

    } // End of func issueCxAPIRegisterSASTScanReport().

    func issueCxAPIGetSASTScanReportStatusById() -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = [
            "Content-Type":  "application/json;v1.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
            ];

        let asCxURLParameters = 
        [
            "id": "\(self.scan!.sAppLastSASTScanReportId)"
        ];

        var svHttpParams:[String] = Array();

        for (sHttpName, sHttpValue) in asCxURLParameters
        {

            svHttpParams.append("\(sHttpName)=\(sHttpValue)");

        }

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/reports/sastScan/\(self.scan!.sAppLastSASTScanReportId)/status";
        self.restURLProcessor!.restURLData!.sHttpParams = svHttpParams.joined(separator: "&");

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "GET";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "GetSASTScanReportStatusById");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        let adJsonAPIResult:[NSDictionary] = self.restURLResponse!.adRestURLResponseResult;

        if (adJsonAPIResult.count > 0)
        {

            for (i, dictJsonResult) in adJsonAPIResult.enumerated()
            {

                var j = 0;

                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {

                    j += 1;

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");

                    //  "status": {
                    //  "id": 2,
                    //  "value": "Created"
                    //  }

                    if (dictJsonKey as! String == "status")
                    {

                        let dictJsonStatus:[String:Any]           = dictJsonValue as! [String:Any]; 
                        let bLastSASTScanReportStatusChanged:Bool = (self.scan!.idAppLastSASTScanReportStatus != (dictJsonStatus["id"]    as! Int));
                        let bLastSASTScanReportValueChanged:Bool  = (self.scan!.sAppLastSASTScanReportValue   != (dictJsonStatus["value"] as! String));
                        var bUpdateAppReportStatusView:Bool       = false;

                        if (bLastSASTScanReportStatusChanged == true)
                        {

                            bUpdateAppReportStatusView = true;

                        }
                        else
                        {

                            if (bLastSASTScanReportValueChanged == true)
                            {

                                bUpdateAppReportStatusView = true;

                            }

                        }

                        self.scan!.idAppLastSASTScanReportStatus = dictJsonStatus["id"]     as! Int;
                        self.scan!.sAppLastSASTScanReportValue   = dictJsonStatus["value"] as! String;

                        let newAttr1 = Attr(name: "CxRegisteredScanReportStatus", value: "\(self.scan!.idAppLastSASTScanReportStatus)");
                        let newAttr2 = Attr(name: "CxRegisteredScanReportValue",  value: "\(self.scan!.sAppLastSASTScanReportValue)");

                        self.scan!.appendUniqueAttr(attr: newAttr1);
                        self.scan!.appendUniqueAttr(attr: newAttr2);

                        let sScanProcessorStatusMsg = "For the 'submitted' Scan ID [\(self.scan!.sAppLastSASTScanId)] 'registered' Report id [\(self.scan!.sAppLastSASTScanReportId)] the 'status' ID is (\(newAttr1.value)) and the 'value' is [\(newAttr2.value)]..."; 

                    //  if (self.scan!.sAppLastSASTScanReportValue.count > 0)
                    //  {
                    //
                    //      sScanProcessorStatusMsg = "For the 'submitted' Scan ID [\(self.scan!.sAppLastSASTScanId)] the 'status' ID is (\(newAttr1.value)) the 'status' is [\(newAttr2.value)] and the 'stage' is [\(newAttr3.value)]..."; 
                    //
                    //  }

                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

                        if (bUpdateAppReportStatusView == true)
                        {

                            DispatchQueue.main.async
                            {

                                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

                            }   

                        }

                    }

                }

            }

        }

        return true;

    } // End of func issueCxAPIGetSASTScanReportStatusById().

    func issueCxAPIGetSASTScanReportById() -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = [
            "Content-Type":  "application/json;v1.0",
            "Authorization": "Bearer \(self.restCxDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
            ];

        let asCxURLParameters = 
        [
            "id":           "\(self.scan!.sAppLastSASTScanReportId)",
            "Content-type": "application/\(self.scan!.sAppLastSASTScanReportType)"
        ];

        var svHttpParams:[String] = Array();

        for (sHttpName, sHttpValue) in asCxURLParameters
        {

            svHttpParams.append("\(sHttpName)=\(sHttpValue)");

        }

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/reports/sastScan/\(self.scan!.sAppLastSASTScanReportId)";
        self.restURLProcessor!.restURLData!.sHttpParams = svHttpParams.joined(separator: "&");

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "Get";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200];

        var bDataIsBinary:Bool = false;

        if (self.scan!.sAppLastSASTScanReportType == "pdf" ||
            self.scan!.sAppLastSASTScanReportType == "rtf")
        {

            bDataIsBinary = true;

        }

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithBasicResponse(reset: false, dataIsBinary: bDataIsBinary);

        // We do NOT trace the result here because we'd be tracing binary report output into memory and logs:
      
    //  defer
    //  {
    //
    //      _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "GetSASTScanReportById");
    //
    //  }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }

        var cURLDataLength:Int = 0;

        if (bDataIsBinary == false)
        {

            cURLDataLength = self.restURLResponse!.sRestURLResponseData.count;

        }
        else
        {

            cURLDataLength = self.restURLResponse!.nsRestURLResponseData!.length;

        }

        if (cURLDataLength < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The URL 'response' data was returned 'empty' - Error!");

            return false;

        }

        let sReportProjectName:String = (self.scan!.sAppCxProjectName.stringByReplacingAllOccurrencesOfString(target: " ", withString: "-"));
        let sReportFilespec:String    = "~/CheckMarx/Reports/Project-\(sReportProjectName)_Scan-\(self.scan!.sAppLastSASTScanId)_Report-\(self.scan!.sAppLastSASTScanReportId)_Generated.\(self.scan!.sAppLastSASTScanReportType)";
        var sCurrFilespec:String      = sReportFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        let sCurrFilepath = (sCurrFilespec as NSString).deletingLastPathComponent;

        do
        {

            try FileManager.default.createDirectory(atPath: sCurrFilepath, withIntermediateDirectories: true, attributes: nil)

        }
        catch
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Failed to create the 'path' of [\(sCurrFilepath)] - Error: \(error)...");

        }

        if (bDataIsBinary == false)
        {

            _ = JsFileIO.writeFile(sFilespec: sCurrFilespec, sContents: self.restURLResponse!.sRestURLResponseData, bAppendToFile: false);

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'saved' the Scan Report file with (\(self.restURLResponse!.sRestURLResponseData.count)) byte(s) to the file [\(sCurrFilespec)]...");

        }
        else
        {

            _ = self.restURLResponse!.nsRestURLResponseData!.write(toFile: sCurrFilespec, atomically: true);
  
            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'saved' the Scan Report file with (\(self.restURLResponse!.sRestURLResponseData.count)) byte(s) to the file [\(sCurrFilespec)]...");

        }

        let newAttr5 = Attr(name: "CxScanReportFilespec",  value: "\(sCurrFilespec)");

        self.scan!.appendUniqueAttr(attr: newAttr5);

        self.scan!.sAppLastSASTScanReportFilespec = sCurrFilespec;

        if (self.restCxDataBind != nil)
        {

            self.restCxDataBind!.cxLastSASTScanReportFilespec = sCurrFilespec;

        }

        if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
        {

            DispatchQueue.main.async
            {

                MainViewController.ClassSingleton.cxAppMainViewController!.sMainViewLastReportFilespec = self.scan!.sAppLastSASTScanReportFilespec;
                MainViewController.ClassSingleton.cxAppMainViewController!.sMainViewDisplay            = ">>> Scan ID [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] available...";

                MainViewController.ClassSingleton.cxAppMainViewController!.updateMainViewDisplay();

            }   

        }

        let sScanProcessorStatusMsg = "For a Scan ID of [\(self.scan!.sAppLastSASTScanId)] Report ID [\(self.scan!.sAppLastSASTScanReportId)] has been written to [\(sCurrFilespec)]..."; 

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sScanProcessorStatusMsg);

        DispatchQueue.main.async
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sScanProcessorStatusMsg);

        }   

        return true;

    } // End of func issueCxAPIGetSASTScanReportById().

} // End of class ScanProcessor.

//  func extractText(from image: CGImage)
//  {
//
//      let bitmapRep = NSBitmapImageRep(cgImage: image)
//      let imageData = bitmapRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])! as Data
//
//      let url = URL(string: "https://api.ocr.space/parse/image")!
//
//      let session = URLSession.shared
//      var request = URLRequest(url: url)
//      request.httpMethod = "POST"
//
//      let boundary = "--------69-69-69-69-69"
//      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//      request.addValue("application/json", forHTTPHeaderField: "Accept")
//      request.addValue("6ea787d56088957", forHTTPHeaderField: "apikey")
//      request.httpBody = createBody(parameters: nil, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
//
//      let task = session.synchronousDataTask(urlrequest: request)
//      let data = task.0
//      let error = task.2
//
//      if data == nil {
//          print("ERROR: No response from OCR.space api call")
//          return
//      }
//
//      if error != nil {
//          print("ERROR: ", error!)
//          return
//      }
//
//      do {
//          let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
//
//          if let parsedResults = dictionary["ParsedResults"] as? [[String: Any]] {
//              if let parsedResult = parsedResults.first {
//                  if let text = parsedResult["ParsedText"] as? String {
//                      parsedText = text
//                      return
//                  } else {
//                      print("ERROR: Could not read parsedText")
//                      return
//                  }
//              } else {
//                  print("ERROR: Could not read first element of parsedResult")
//                  return
//              }
//          } else {
//              print("ERROR: Could not read parsedResult")
//              return
//          }
//      } catch let error {
//          print("ERROR: Could not serialize jSON Data into dictionary: \(error.localizedDescription)")
//          return
//      }
//  }
//
//  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  ///
//  ///    Creates a the body of the url request using the given parameters
//  ///
//  private func createBody(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
//      var body = Data();
//
//      if parameters != nil {
//          for (key, value) in parameters! {
//              body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//              body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//              body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
//          }
//      }
//
//      let filename = "image.jpg"
//      let mimetype = "image/jpg"
//
//      body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//      body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
//      body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
//      body.append(imageDataKey)
//      body.append("\r\n".data(using: String.Encoding.utf8)!)
//
//      body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//
//      return body
//   }


