//  
//  BindViewController.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 3/20/19.
//  Copyright © 2019 Daryl R. Cox. All rights reserved.
//

import Foundation
import Cocoa

class BindReportViewController: NSViewController, NSComboBoxDelegate
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "BindReportViewController";
        static let sClsVers        = "v1.0401";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }
    
    struct ClassSingleton
    {
        
        static var cxAppBindReportViewController:BindReportViewController? = nil;
        
    }

    @IBOutlet weak var nsCBBindReportProjectNameDisplay:NSComboBox!;
    @IBOutlet weak var nsChkBBindReportDownload:NSButton!;
    @IBOutlet weak var nsCBBindReportTypeDisplay:NSComboBox!;
    @IBOutlet weak var nsBtnBindReportUnbind: NSButton!
    @IBOutlet weak var nsBtnBindReportApply:NSButton!;
    @IBOutlet weak var nsBtnBindReportCancel:NSButton!;
    @IBOutlet weak var nsBtnBindReportMainImage:NSButton!;
    @IBOutlet weak var nsTFBindReportMainViewDisplay:NSTextField!;
    
    let bBindReportViewInternalTest              = false;
    var cBindReportImageBtn                      = 0;
    var sBindReportViewDisplay                   = "";

    var cxCurrentBind:Bind?                      = nil;
    var cxCurrentDataEndpoint:CxDataEndpoint?    = nil;
    var dictCurrentEndpointProjects:[String:Int] = [:];

    let jsTraceLog:JsTraceLog                    = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                                = ClassInfo.sClsDisp;
    
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
        
        ClassSingleton.cxAppBindReportViewController = self;
        
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        self.cxCurrentBind = CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentActiveBind;

        if (self.cxCurrentBind == nil)
        {

            self.sBindReportViewDisplay = ">>> Error: NO 'current' Bind is available!"; 

        }
        else
        {

            self.loadBindReportViewForCurrentItem();

        }
        
        self.updateBindReportViewDisplay();

    } // End of (override) func viewDidLoad().
    
    override func viewDidDisappear()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
        
        CxDataRepo.sharedCxDataRepo.saveCxDataBinds();

        super.viewDidDisappear();

        if (CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentScanOnHold != nil)
        {

            let currScan = CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentScanOnHold!;

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.invokeScanSubmitViaAPICall(scan: currScan);

            }   

        }

        CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentActiveBind = nil;
        CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentScanOnHold = nil;

        self.cxCurrentBind                                         = nil;
        
        ClassSingleton.cxAppBindReportViewController               = nil;
        
    } // End of (override) func viewDidDisappear().
    
    override var representedObject: Any?
    {
        
        didSet
        {
            
            // Update the view, if already loaded.
            
             self.updateBindReportViewDisplay();

        }
        
    }

    @IBAction func buttonBindReportMainImagePressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

        self.cBindReportImageBtn += 1;

        self.sBindReportViewDisplay = "";

        self.updateBindReportViewDisplay();

    } // End of func buttonBindReportMainImagePressed().
    
    func updateBindReportViewDisplay()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.bBindReportViewInternalTest == true)
        {

            if (self.sBindReportViewDisplay.count < 1)
            {

                self.sBindReportViewDisplay = ">>> Button 'BindReportImage' pressed (\(self.cBindReportImageBtn)) times..."; 

            }

        }

        self.nsTFBindReportMainViewDisplay.stringValue = self.sBindReportViewDisplay;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sBindReportViewDisplay' was [\(sBindReportViewDisplay)]...");

    } // End of func updateBindReportViewDisplay().

    func loadBindReportViewForCurrentItem()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.cxCurrentBind == nil)
        {

            self.sBindReportViewDisplay = ">>> ERROR: NO 'current' Checkmarx Bind available!";

            return;

        }

        self.nsCBBindReportProjectNameDisplay.removeAllItems();

        self.nsCBBindReportProjectNameDisplay.delegate             = self;
        self.nsCBBindReportProjectNameDisplay.numberOfVisibleItems = 5;
        self.nsCBBindReportProjectNameDisplay.completes            = false;

        var adRestURLResponseResults:[NSDictionary]? = CxDataRepo.sharedCxDataRepo.retrieveJsonAPIResponseFromCxDataRepo(sCxDataEndpointKey: self.cxCurrentBind!.cxEndpointKey, sJsonAPIKey: "GetAllProjectDetails") as? [NSDictionary];

        if (adRestURLResponseResults        == nil ||
            adRestURLResponseResults!.count < 1)
        {

            self.sBindReportViewDisplay = ">>> ERROR: NO 'current' Checkmarx Project(s) for the Endpoint [\(self.cxCurrentBind!.cxEndpointKey)] - delaying!";

            // Delay for 6 seconds to let the CxDataRepo to load the Checkmarx Project(s)...

            usleep(6000000);

            // Now, try again:

            adRestURLResponseResults = CxDataRepo.sharedCxDataRepo.retrieveJsonAPIResponseFromCxDataRepo(sCxDataEndpointKey: self.cxCurrentBind!.cxEndpointKey, sJsonAPIKey: "GetAllProjectDetails") as? [NSDictionary];

            if (adRestURLResponseResults        == nil ||
                adRestURLResponseResults!.count < 1)
            {

                self.sBindReportViewDisplay = ">>> ERROR: NO 'current' Checkmarx Project(s) for the Endpoint [\(self.cxCurrentBind!.cxEndpointKey)] - after delay!";

                return;

            }

        }

        self.dictCurrentEndpointProjects = [:];

        for (i, dictJsonResult) in adRestURLResponseResults!.enumerated()
        {

            var j                          = 0;
            var sCurrentProjectName:String = "";
            var cCurrentProjectId:Int      = 0;
        
            for (dictJsonKey, dictJsonValue) in dictJsonResult
            {
        
                j += 1;
                
                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");
        
                // 'loadBindReportViewForCurrentItem()()' - JSON result #(2:1): Key [id], Value [170017]...
                // 'loadBindReportViewForCurrentItem()()' - JSON result #(2:4): Key [name], Value [PHP-Mailer]...

                if ((dictJsonKey as! String) == "id")
                {

                    cCurrentProjectId = dictJsonValue as! Int;

                }

                if ((dictJsonKey as! String) == "name")
                {

                    sCurrentProjectName = dictJsonValue as! String;

                }

                if (sCurrentProjectName.count > 0 &&
                    cCurrentProjectId         > 0)
                {

                    self.dictCurrentEndpointProjects[sCurrentProjectName] = cCurrentProjectId;

                    self.nsCBBindReportProjectNameDisplay.addItem(withObjectValue: sCurrentProjectName);

                    if (self.cxCurrentBind!.cxProjectName.count > 0 &&
                        self.cxCurrentBind!.cxProjectName       == sCurrentProjectName)
                    {

                        self.nsCBBindReportProjectNameDisplay.selectItem(at: i);

                    }

                    break;

                }

            }
            
        }

        self.nsChkBBindReportDownload.state = (self.cxCurrentBind!.bCxBindGenerateReport == true) ? NSControl.StateValue.on : NSControl.StateValue.off;

        self.nsCBBindReportTypeDisplay.removeAllItems();

        self.nsCBBindReportTypeDisplay.addItem(withObjectValue: "PDF");
        self.nsCBBindReportTypeDisplay.addItem(withObjectValue: "XML");
        self.nsCBBindReportTypeDisplay.addItem(withObjectValue: "CSV");
        self.nsCBBindReportTypeDisplay.addItem(withObjectValue: "RTF");

        switch (self.cxCurrentBind!.cxBindReportType)
        {

            case "pdf":

                self.nsCBBindReportTypeDisplay.selectItem(at: 0);

            case "xml":

                self.nsCBBindReportTypeDisplay.selectItem(at: 1);

            case "csv":

                self.nsCBBindReportTypeDisplay.selectItem(at: 2);

            case "rtf":

                self.nsCBBindReportTypeDisplay.selectItem(at: 3);

            default:

                self.nsCBBindReportTypeDisplay.selectItem(at: 0);

        }

        self.nsCBBindReportTypeDisplay.delegate              = self;
        self.nsCBBindReportTypeDisplay.numberOfVisibleItems  = 4;
        self.nsCBBindReportTypeDisplay.completes             = false;

    } // End of func loadBindReportViewForCurrentItem().
    
    func updateCxDataBindFromBindReportView()
    {
  
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
  
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
  
        if (self.cxCurrentBind == nil)
        {
  
            self.sBindReportViewDisplay = ">>> ERROR: NO 'current' Checkmarx Bind available!";
  
            return;
  
        }

        let selectedItemObjectValue:Any? = self.nsCBBindReportProjectNameDisplay.objectValueOfSelectedItem;

        if (selectedItemObjectValue == nil)
        {

            return;

        }

        let sCxProjectNameSelected:String         = (selectedItemObjectValue as? String)!;
 
        self.cxCurrentBind!.cxProjectName         = sCxProjectNameSelected;
        self.cxCurrentBind!.cxProjectId           = self.dictCurrentEndpointProjects[sCxProjectNameSelected]!;
        self.cxCurrentBind!.bCxBindGenerateReport = (self.nsChkBBindReportDownload.state == NSControl.StateValue.on) ? true : false;

        switch (self.nsCBBindReportTypeDisplay.indexOfSelectedItem)
        {

            case 0:

                self.cxCurrentBind!.cxBindReportType      = "pdf";

            case 1:

                self.cxCurrentBind!.cxBindReportType      = "xml";

            case 2:

                self.cxCurrentBind!.cxBindReportType      = "csv";

            case 3:

                self.cxCurrentBind!.cxBindReportType      = "rtf";

            default:

                self.cxCurrentBind!.bCxBindGenerateReport = false;
                self.cxCurrentBind!.cxBindReportType      = "";

        }

        return;

    } // End of func updateCxDataBindFromBindReportView().
    
    @IBAction func buttonBindReportUnbindPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

        if (self.cxCurrentBind != nil)
        {

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.removeObjectFromBinds(bind: self.cxCurrentBind!);

        }

        CxDataRepo.sharedCxDataRepo.saveCxDataBinds();

        CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentActiveBind = nil;

        self.cxCurrentBind                                         = nil;

        self.updateBindReportViewDisplay();

        self.view.window!.close();
    //  self.view.window?.contentViewController?.dismiss(animated: false, completion: nil);
    //  NSApplication.shared.terminate(self);

    } // End of func buttonBindReportUnbindPressed().
    
    @IBAction func buttonBindReportApplyPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

        self.updateCxDataBindFromBindReportView();

        self.sBindReportViewDisplay = ">>> Change(s) to the 'current' Bind have been applied!";

        self.updateBindReportViewDisplay();

    } // End of func buttonBindReportApplyPressed().
    
    @IBAction func buttonBindReportCancelPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

        self.loadBindReportViewForCurrentItem();

        self.sBindReportViewDisplay = ">>> Change(s) to the 'current' Bind have been cancelled!";

        self.updateBindReportViewDisplay();

    } // End of func buttonBindReportCancelPressed().
    
} // End of class BindViewController.
