//
//  MainViewController.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 2/17/19.
//  Copyright © 2018-2019 Checkmarx. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "MainViewController";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    struct ClassSingleton
    {

        static var cxAppMainViewController:MainViewController? = nil;

    }

    @IBOutlet weak var nsBtnMainImage:NSButton!;
    @IBOutlet weak var nsTFMainViewDisplay:NSTextField!;
    @IBOutlet weak var nsBtnMainSubmitScan:NSButton!;
    @IBOutlet weak var nsBtnMainBindView:NSButton!;
    @IBOutlet weak var nsBtnMainViewLastReport:NSButton!;
    @IBOutlet weak var nsTVStatusViewDisplay:NSTextView!
    
    let bMainViewInternalTest       = false;
    var cMainImageBtn               = 0;
    var bMainButtonsAreEnabled      = false;
    var sMainViewDisplay            = "";
    var sMainViewLastReportFilespec = "";
    var svMainStatusView:[String]   = Array();

    let jsTraceLog:JsTraceLog       = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                   = ClassInfo.sClsDisp;

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
        asToString.append("'nsBtnMainImage': [\(String(describing: self.nsBtnMainImage))]");
        asToString.append("'nsTFMainViewDisplay': [\(String(describing: self.nsTFMainViewDisplay))]");
        asToString.append("'nsBtnMainSubmitScan': [\(String(describing: self.nsBtnMainSubmitScan))]");
        asToString.append("'nsBtnMainBindView': [\(String(describing: self.nsBtnMainBindView))]");
        asToString.append("'nsBtnMainViewLastReport': [\(String(describing: self.nsBtnMainViewLastReport))]");
        asToString.append("'nsTVStatusViewDisplay': [\(String(describing: self.nsTVStatusViewDisplay))]");
        asToString.append("'bMainViewInternalTest': [\(self.bMainViewInternalTest)],");
        asToString.append("'cMainImageBtn': [\(self.cMainImageBtn)],");
        asToString.append("'bMainButtonsAreEnabled': [\(self.bMainButtonsAreEnabled)],");
        asToString.append("'sMainViewDisplay': [\(self.sMainViewDisplay)],");
        asToString.append("'sMainViewLastReportFilespec': [\(self.sMainViewLastReportFilespec)],");
        asToString.append("'svMainStatusView': [\(self.svMainStatusView)],");
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

        ClassSingleton.cxAppMainViewController = self;

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        self.nsBtnMainSubmitScan.isEnabled = false;
        self.nsBtnMainSubmitScan.isHidden  = true;
        self.nsBtnMainBindView.isEnabled   = false;
        self.nsBtnMainBindView.isHidden    = true;
        self.bMainButtonsAreEnabled        = false;
 
        self.updateMainViewDisplay();

    } // End of (override) func viewDidLoad().

    override func viewDidDisappear()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        super.viewDidDisappear();

        ClassSingleton.cxAppMainViewController = nil;

    } // End of (override) func viewDidDisappear().

    override var representedObject: Any? 
    {

        didSet
        {

            // Update the view, if already loaded.

            self.updateMainViewDisplay();
        
        }

    }
    
    @IBAction func buttonMainImagePressed(_ sender: Any)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        cMainImageBtn += 1;
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");

        if (self.bMainButtonsAreEnabled == true)
        {

            self.nsBtnMainSubmitScan.isEnabled = false;
            self.nsBtnMainSubmitScan.isHidden  = true;
            self.nsBtnMainBindView.isEnabled   = false;
            self.nsBtnMainBindView.isHidden    = true;
            self.bMainButtonsAreEnabled        = false;

        }
        else
        {

            self.nsBtnMainSubmitScan.isEnabled = true;
            self.nsBtnMainSubmitScan.isHidden  = false;
            self.nsBtnMainBindView.isEnabled   = true;
            self.nsBtnMainBindView.isHidden    = false;
            self.bMainButtonsAreEnabled        = true;

        }

        self.sMainViewDisplay = "";

        self.updateMainViewDisplay();
    //  self.updateMainStatusView(sMainStatusView: "...refresh...");

    } // End of func buttonMainImagePressed().

    func updateMainViewDisplay()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.bMainViewInternalTest == true)
        {

            if (self.sMainViewDisplay.count < 1)
            {

                self.sMainViewDisplay = ">>> Button 'MainImage' pressed (\(self.cMainImageBtn)) times...";

            }

        }

        self.nsTFMainViewDisplay.stringValue = self.sMainViewDisplay;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sMainViewDisplay' is [\(sMainViewDisplay)]...");
       
    } // End of func updateMainViewDisplay().

    @IBAction func buttonSubmitScanPressed(_ sender: Any) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");

        if (AppDelegate.ClassSingleton.cxAppDelegate != nil)
        {

            let newScan:Scan = Scan(scan: CxDataRepo.sharedCxDataRepo.cxDataScans!.scans[0]);

            AppDelegate.ClassSingleton.cxAppDelegate!.insertObject(newScan, inScansAtIndex: CxDataRepo.sharedCxDataRepo.cxDataScans!.scans!.count)

            _ = AppDelegate.ClassSingleton.cxAppDelegate!.processScanSubmit(scan: newScan);

        }

    } // End of func buttonSubmitScanPressed().
    
    @IBAction func buttonMainBindViewPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");

        let cxActiveDataEndpoint:CxDataEndpoint? = CxDataRepo.sharedCxDataRepo.retrieveActiveCxDataEndpoint();
        let currBind                             = Bind();

        // ToDo: temp code to test the 'Bind' view...

        currBind.key           = "/public_hda2/JWeb.Software/JWeb_MacOSx_apps/Swift_Command_line_tools/HelloSwift4WithJNI/HelloSwift4WithJNI/HelloSwift4WithJNI.xcodeproj";
        currBind.cxEndpointKey = (cxActiveDataEndpoint != nil) ? cxActiveDataEndpoint!.sCxEndpointName! : "";
        currBind.cxBindOrigin  = "CheckmarxXcodePlugin1.app.MainViewController";

    //  AppDelegate.ClassSingleton.cxAppDelegate!.binds = CxDataRepo.sharedCxDataRepo.cxDataBinds!.insertBind(bind: currBind, at: CxDataRepo.sharedCxDataRepo.cxDataBinds!.binds.count);
        _ = AppDelegate.ClassSingleton.cxAppDelegate!.insertObject(currBind, inBindsAtIndex: CxDataRepo.sharedCxDataRepo.cxDataBinds!.binds.count);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Calling the AppDelegate...");

        _ = AppDelegate.ClassSingleton.cxAppDelegate!.invokeBindOrUnbindViaAPICall(bind: currBind, bCallIsForReportView: false);

    } // End of func buttonMainBindViewPressed().

    @IBAction func buttonMainViewLastReportPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");

        self.handleMainViewLastReport();

    } // End of func buttonMainViewLastReportPressed().

    public func handleMainViewLastReport()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        var sCurrLastSASTScanReportFilespec = self.sMainViewLastReportFilespec;

        if (sCurrLastSASTScanReportFilespec.count > 0)
        {

            NSWorkspace.shared.open(URL(string: "file://\(sCurrLastSASTScanReportFilespec)")!);

            let sMainProcessorStatusMsg = "Launched the file [\(sCurrLastSASTScanReportFilespec)] to view in the 'default' extension handler...";

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sMainProcessorStatusMsg);

            self.updateMainStatusView(sMainStatusView: sMainProcessorStatusMsg);

            return;

        }

        let sScanReportTempDir:String = "~/CheckMarx/Reports/";
        var sScanReportDirspec:String = sScanReportTempDir;

        if (sScanReportDirspec.hasPrefix("~/") == true)
        {

            sScanReportDirspec = NSString(string: sScanReportDirspec).expandingTildeInPath as String;

        }

        let nsDictItemAttributes:NSDictionary? = try? FileManager.default.attributesOfItem(atPath: sScanReportDirspec) as NSDictionary;

        if (nsDictItemAttributes == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan Report(s) 'temp' Directory [\(sScanReportDirspec)] is NOT valid - Warning!");

            return;

        }

        if (nsDictItemAttributes!.fileType() != "NSFileTypeDirectory")
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan Report(s) 'temp' Directory [\(sScanReportDirspec)] is NOT a valid Directory - Error!");

            return;

        }
        
        let asReportsInDirspec:[String]? = FileManager.default.componentsToDisplay(forPath: sScanReportDirspec);

        if (asReportsInDirspec        == nil ||
            asReportsInDirspec!.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan Report(s) 'temp' Directory [\(sScanReportDirspec)] contains NO Report(s) file(s) - Warning!");

            let sMainProcessorStatusMsg = "There is NO 'last' Scan Report available to view...";

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sMainProcessorStatusMsg);

            self.updateMainStatusView(sMainStatusView: sMainProcessorStatusMsg);

            return;

        }

        let nsLSAlertMsg = NSLocalizedString("There is NO 'last' Scan Report available to view. Do you want to browse older Scan Report(s)?", comment: "Ok error question message");
        let nsBtnOk      = NSLocalizedString("Ok", comment: "View anyway button title");
        let nsBtnCancel  = NSLocalizedString("Cancel", comment: "Cancel button title");
        let nsAlert      = NSAlert();

        nsAlert.alertStyle  = NSAlert.Style.informational;
        nsAlert.messageText = nsLSAlertMsg;

        nsAlert.addButton(withTitle: nsBtnOk);
        nsAlert.addButton(withTitle: nsBtnCancel);

        var nsAlertAnswer:NSApplication.ModalResponse?;

        nsAlert.beginSheetModal(for: self.view.window!, completionHandler:
            {   (modalResponse: NSApplication.ModalResponse) -> Void in

                nsAlertAnswer = modalResponse;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Alert answer 'nsAlertAnswer' [\(String(describing: nsAlertAnswer)))]...");

                if nsAlertAnswer != .alertFirstButtonReturn 
                {

                    // This is NOT the 'view' (Ok) button ('cancel' button or the view was dismissed) - just do nothing and return:

                    return;

                }

                let nsOPFileDialog:NSOpenPanel = NSOpenPanel();

                nsOPFileDialog.prompt                  = "Open a Scan Report file";
                nsOPFileDialog.worksWhenModal          = true;
                nsOPFileDialog.allowsMultipleSelection = false;
                nsOPFileDialog.canChooseDirectories    = false;
                nsOPFileDialog.resolvesAliases         = true;
                nsOPFileDialog.title                   = ClassInfo.sClsId+" OPEN file...";
                nsOPFileDialog.message                 = "Select a Scan Report file to 'open'...";
                nsOPFileDialog.allowedFileTypes        = ["pdf", "xml", "csv", "rtf"];
                nsOPFileDialog.directoryURL            = URL(fileURLWithPath: sScanReportDirspec);

                let nsMRReturnCode:NSApplication.ModalResponse = nsOPFileDialog.runModal();
                
                if (nsMRReturnCode == NSApplication.ModalResponse.cancel)
                {

                    // This is NOT the 'Select...' button ('cancel' button or the view was dismissed) - just do nothing and return:
                
                    return;
                    
                }
                
                let urlChosenFile          = nsOPFileDialog.url;
                var sReportFilespec:String = "";

                if (urlChosenFile != nil)
                {

                    sReportFilespec = urlChosenFile!.absoluteString;

                }

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<Open> dialog returned a 'sReportFileSpec' of [\(String(describing: sReportFilespec))]...");

                if (sReportFilespec.count < 1)
                {

                    let sMainProcessorStatusMsg = "There is NO selected 'last' Scan Report available to view...";

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sMainProcessorStatusMsg);

                    self.updateMainStatusView(sMainStatusView: sMainProcessorStatusMsg);

                    return;

                }

                let nsUrlFilespec:URL = URL(string:sReportFilespec)!;

                sReportFilespec = String(cString: (nsUrlFilespec as NSURL).fileSystemRepresentation);

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"<Open> dialog selected a file named [\(String(describing: sReportFilespec))]...");

                sCurrLastSASTScanReportFilespec = sReportFilespec;

                if (sCurrLastSASTScanReportFilespec.count < 1)
                {

                    let sMainProcessorStatusMsg = "There is NO 'last' Scan Report available to view...";

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sMainProcessorStatusMsg);

                    self.updateMainStatusView(sMainStatusView: sMainProcessorStatusMsg);

                    return;

                }

                self.sMainViewLastReportFilespec = sCurrLastSASTScanReportFilespec;
                
                NSWorkspace.shared.open(URL(string: "file://\(sCurrLastSASTScanReportFilespec)")!);

                let sMainProcessorStatusMsg = "Launched the file [\(sCurrLastSASTScanReportFilespec)] to view in the 'default' extension handler...";

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sMainProcessorStatusMsg);

                self.updateMainStatusView(sMainStatusView: sMainProcessorStatusMsg);

            });

        return;

    } // End of func handleMainViewLastReport().
    
    func updateMainStatusView(sMainStatusView:String = "")
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sMainStatusView' is [\(sMainStatusView)]...");

        _ = self.addMainStatusView(sMainStatusView: sMainStatusView);

        self.nsTVStatusViewDisplay.textStorage?.setAttributedString(NSAttributedString(string: self.renderMainStatusViewsToString()));

        let posTVStatusViewScoll = (NSMaxY(self.nsTVStatusViewDisplay.visibleRect) - NSMaxY(self.nsTVStatusViewDisplay.bounds));

    //  self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'svMainStatusView' 'position' is (\(posTVStatusViewScoll)):(\(posTVStatusViewScoll.magnitude)) with [\(self.svMainStatusView)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'svMainStatusView' 'position' is (\(posTVStatusViewScoll)):(\(posTVStatusViewScoll.magnitude)) with (\(self.svMainStatusView.count)) byte(s) in the 'view'...");

        if (abs(posTVStatusViewScoll) < 30.0)
        { 

        //   We're at the bottom of the 'StatusView' scrolling - let's keep it there (otherwise - do nothing):

             self.nsTVStatusViewDisplay.scrollToEndOfDocument(nil);

        } 

    } // End of func updateMainStatusView().

    func addMainStatusView(sMainStatusView:String = "") -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sMainStatusView' is [\(sMainStatusView)]...");

        self.svMainStatusView.append(sMainStatusView);

        return true;

    } // End of func addMainStatusView().

    func clearMainStatusViews() -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'svMainStatusView' contains (\(self.svMainStatusView.count)) element(s)...");

        self.svMainStatusView = Array();

        return true;

    } // End of func clearMainStatusViews().

    func renderMainStatusViewsToString() -> String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'svMainStatusView' contains (\(self.svMainStatusView.count)) element(s)...");

        return (self.svMainStatusView.joined(separator: "\n"));

    } // End of func renderMainStatusViewsToString().

} // End of class MainViewController.
