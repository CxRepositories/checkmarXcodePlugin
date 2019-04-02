//
//  LogHistoryViewController.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 2/18/19.
//  Copyright © 2018-2019 Checkmarx. All rights reserved.
//

import Foundation
import Cocoa

class LogHistoryViewController: NSViewController
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "LogHistoryViewController";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    struct ClassSingleton
    {

        static var cxLogHistoryViewController:LogHistoryViewController? = nil;

    }

    @IBOutlet weak var nsTFLogHistoryDisplay:NSTextField!
    @IBOutlet weak var nsTFScansCountDisplay:NSTextField!
    @IBOutlet weak var nsTVScansElementsDisplay:NSTextView!
    @IBOutlet weak var nsTVLastURLOutputDisplay:NSTextView!
    
    @IBOutlet weak var btnRefresh:NSButton!
    @IBOutlet weak var btnSubmitScan:NSButton!
    
    var cTestBtn              = 0;
    var cTestApi              = 0;
    var cTestSubmitScan       = 0;
    
    let jsTraceLog:JsTraceLog = JsTraceLog.sharedJsTraceLog;
    let sTraceCls             = ClassInfo.sClsDisp;

    // Items at the instance level that are NOT part of the 'toString()' output (used for Log 'file' output):

    var sLogHistoryMainDisplay:String = "";
    var sScansCountDisplay:String     = "";
    var svScansDisplaySet:String      = "";
    var svLastURLOutput:String        = "";

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
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)]");
        asToString.append("'sClsLogFilespec': [\(ClassInfo.sClsLogFilespec)]");
        asToString.append("],");
        asToString.append("'nsTFLogHistoryDisplay': [\(String(describing: self.nsTFLogHistoryDisplay))]");
        asToString.append("'nsTFScansCountDisplay': [\(String(describing: self.nsTFScansCountDisplay))]");
        asToString.append("'nsTVScansElementsDisplay': [\(String(describing: self.nsTVScansElementsDisplay))]");
        asToString.append("'nsTVLastURLOutputDisplay': [\(String(describing: self.nsTVLastURLOutputDisplay))]");
        asToString.append("'btnRefresh': [\(String(describing: self.btnRefresh))]");
        asToString.append("'btnSubmitScan': [\(String(describing: self.btnSubmitScan))]");
        asToString.append("'cTestBtn': [\(self.cTestBtn)],");
        asToString.append("'cTestApi': [\(self.cTestApi)],");
        asToString.append("'cTestSubmitScan': [\(self.cTestSubmitScan)],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog.toString())],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of public func toString().

    override func viewDidLoad()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        super.viewDidLoad();

        ClassSingleton.cxLogHistoryViewController = self;

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        self.updateLogHistoryDisplay();

        self.btnRefresh.isEnabled    = true;
        self.btnSubmitScan.isEnabled = true;
        
    } // End of (override) func viewDidLoad().
    
    override func viewDidDisappear()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        super.viewDidDisappear();

        ClassSingleton.cxLogHistoryViewController = nil;

    } // End of (override) func viewDidDisappear().

    override var representedObject: Any?
    {
        
        didSet
        {
            
            self.updateLogHistoryDisplay();
            
        }
        
    }
    
    @IBAction func buttonRefreshPressed(_ sender: Any)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.cTestBtn += 1;
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Current 'CxDataRepo' is [\(CxDataRepo.sharedCxDataRepo.toString())]...");

        self.updateLogHistoryDisplay();
        self.outputLogHistoryDisplayToLogFile();
        
    } // End of func buttonRefreshPressed().
    
    @IBAction func buttonSubmitScanPressed(_ sender: Any)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");

        self.cTestSubmitScan += 1;

        if (AppDelegate.ClassSingleton.cxAppDelegate != nil)
        {

            let newScan:Scan = Scan(scan: CxDataRepo.sharedCxDataRepo.cxDataScans!.scans[0]);

            AppDelegate.ClassSingleton.cxAppDelegate!.insertObject(newScan, inScansAtIndex: CxDataRepo.sharedCxDataRepo.cxDataScans!.scans!.count)
            
            _ = AppDelegate.ClassSingleton.cxAppDelegate!.processScanSubmit(scan: newScan);
            
        }
        
    } // End of func buttonSubmitScanPressed().
    
    func updateLogHistoryDisplay()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        var sLogHistoryMainDisplay = ">>> 'Refresh' Button (\(self.cTestBtn)) - API called (\(self.cTestApi)) - 'Scan' button (\(self.cTestSubmitScan))...";
        var sScansCountDisplay     = "CxApp - 'Scan(s)' Array contains (0) element(s)...";
        var svScansDisplaySet      = "...placeholder #1...";
        var svLastURLOutput        = "...placeholder #2...";
        
        self.nsTFLogHistoryDisplay.stringValue = sLogHistoryMainDisplay;
        self.nsTFScansCountDisplay.stringValue = sScansCountDisplay;
        
        self.nsTVScansElementsDisplay.textStorage?.setAttributedString(NSAttributedString(string: svScansDisplaySet));
        self.nsTVLastURLOutputDisplay.textStorage?.setAttributedString(NSAttributedString(string: svLastURLOutput));
         
        if (AppDelegate.ClassSingleton.cxAppDelegate != nil)
        {

            let cxAppDelegate:AppDelegate = AppDelegate.ClassSingleton.cxAppDelegate!;

        //  self.cTestBtn          = cxAppDelegate.cTestBtn;       
            self.cTestApi          = cxAppDelegate.cTestApi;      
        //  self.cTestSubmitScan   = cxAppDelegate.cTestSubmitScan;

            sLogHistoryMainDisplay = ">>> 'Refresh' Button (\(self.cTestBtn)) - API called (\(self.cTestApi)) - 'Scan' button (\(self.cTestSubmitScan))...";
            sScansCountDisplay     = "CxApp - 'Scan(s)' Array contains (\(cxAppDelegate.scans.count)) element(s)...";

            self.nsTFLogHistoryDisplay.stringValue = sLogHistoryMainDisplay;
            self.nsTFScansCountDisplay.stringValue = sScansCountDisplay;

            self.nsTVScansElementsDisplay.isHorizontallyResizable = true;
            self.nsTVScansElementsDisplay.isVerticallyResizable   = true;
            self.nsTVScansElementsDisplay.isEditable              = false;

            self.nsTVScansElementsDisplay.textStorage?.setAttributedString(NSAttributedString(string:svScansDisplaySet));

            if (cxAppDelegate.scans.count > 0)
            {

                svScansDisplaySet = "...(\(cxAppDelegate.scans.count)) Scans...";

                var asToStringScans:[String] = Array();

                for scan in cxAppDelegate.scans
                {

                    var asToString:[String] = Array();

                    asToString.append("['id': [\(String(describing: scan.id))],");
                    asToString.append("'title': [\(scan.title)],");
                    asToString.append("'daysUntilDue': [\(scan.daysUntilDue)],");
                    asToString.append("'completed': [\(scan.completed)],");
                    asToString.append("'fullScan': [\(scan.fullScan)],");
                    asToString.append("'sAppXcodeWSDocFilespec': [\(scan.sAppXcodeWSDocFilespec)],");
                    asToString.append("'sAppLastSASTScanId': [\(scan.sAppLastSASTScanId)],");
                    asToString.append("'idAppLastSASTScanStatus': (\(scan.idAppLastSASTScanStatus)),");
                    asToString.append("'sAppLastSASTScanStatus': [\(scan.sAppLastSASTScanStatus)],");

                    var sToStringAttrs = "-None-";

                    if scan.attrs.count > 0
                    {

                        var asToStringAttrs:[String] = Array();

                        for attr in scan.attrs
                        {

                            asToStringAttrs.append("['id': [\(String(describing: attr.id))],");
                            asToStringAttrs.append("'name': [\(attr.name)],");
                            asToStringAttrs.append("'value': [\(attr.value)],],");

                        }

                        sToStringAttrs = asToStringAttrs.joined(separator: "");

                    }

                    asToString.append("'attrs': (\(scan.attrs.count))[\(sToStringAttrs)]],");

                    let sContents:String = asToString.joined(separator: "");

                    asToStringScans.append(sContents);

                }

                svScansDisplaySet = asToStringScans.joined(separator: "\n");

            }

            self.nsTVScansElementsDisplay.textStorage?.setAttributedString(NSAttributedString(string:svScansDisplaySet));

        //  if (cxAppDelegate.scanValidator                                               != nil &&
        //      cxAppDelegate.scanValidator!.scanProcessor                                != nil &&
        //      cxAppDelegate.scanValidator!.scanProcessor!.restURLProcessor              != nil &&
        //      cxAppDelegate.scanValidator!.scanProcessor!.restURLProcessor!.restURLData != nil)
        //  {
        //
        //      svLastURLOutput = cxAppDelegate.scanValidator!.scanProcessor!.restURLProcessor!.restURLData!.renderJsonAPIResponsesToString();
        //
        //  }

            if (cxAppDelegate.scanValidator                       != nil &&
                cxAppDelegate.scanValidator!.scanProcessors.count > 0)
            {

                var svLastURLOutputs:[String] = Array();

                for scanProcessor in cxAppDelegate.scanValidator!.scanProcessors
                {

                    if (scanProcessor.restURLProcessor              != nil &&
                        scanProcessor.restURLProcessor!.restURLData != nil)
                    {

                        svLastURLOutputs.append(scanProcessor.restURLProcessor!.restURLData!.renderJsonAPIResponsesToString());

                    }

                }

                svLastURLOutput = svLastURLOutputs.joined(separator: "\n");

            }

            self.nsTVLastURLOutputDisplay.textStorage?.setAttributedString(NSAttributedString(string:svLastURLOutput));

            let posTVLastURLOutputScoll = (NSMaxY(self.nsTVLastURLOutputDisplay.visibleRect) - NSMaxY(self.nsTVLastURLOutputDisplay.bounds));

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'svMainStatusView' 'position' is (\(posTVLastURLOutputScoll)):(\(posTVLastURLOutputScoll.magnitude)) with (\(svLastURLOutput.count)) byte(s) in the 'view'...");

            if (abs(posTVLastURLOutputScoll) < 30.0)
            { 

            //   We're at the bottom of the 'StatusView' scrolling - let's keep it there (otherwise - do nothing):

                 self.nsTVLastURLOutputDisplay.scrollToEndOfDocument(nil);

            } 

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sLogHistoryMainDisplay' is [\(sLogHistoryMainDisplay)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sScansCountDisplay' is [\(sScansCountDisplay)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'svScansDisplaySet' is (\(svScansDisplaySet.count)) in length...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'svLastURLOutput' is (\(svLastURLOutput.count)) in length...");

        self.sLogHistoryMainDisplay = sLogHistoryMainDisplay;
        self.sScansCountDisplay     = sScansCountDisplay;    
        self.svScansDisplaySet      = svScansDisplaySet;     
        self.svLastURLOutput        = svLastURLOutput;       

    } // End of func updateLogHistoryDisplay().
    
    func outputLogHistoryDisplayToLogFile()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sLogHistoryMainDisplay' is [\(self.sLogHistoryMainDisplay)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sScansCountDisplay' is [\(self.sScansCountDisplay)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'svScansDisplaySet' is (\(self.svScansDisplaySet.count)) of [\(self.svScansDisplaySet)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'svLastURLOutput' is (\(self.svLastURLOutput.count)) of [\(self.svLastURLOutput)]...");

    } // End of func outputLogHistoryDisplayToLogFile().
    
} // End of class LogHistoryViewController.

