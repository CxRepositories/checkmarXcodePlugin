//
//  PreferencesViewController.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 2/20/19.
//  Copyright © 2018-2019 Checkmarx. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController, NSComboBoxDelegate
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "PreferencesViewController";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    struct ClassSingleton
    {

        static var cxAppPrefsViewController:PreferencesViewController? = nil;

    }

    @IBOutlet weak var nsTFPrefsEndpointsDisplay:NSTextField!;
    @IBOutlet weak var nsChkBPrefsEndpointActive:NSButton!;
    @IBOutlet weak var nsCBPrefsProtocolDisplay:NSComboBox!;
    @IBOutlet weak var nsTFPrefsHostDisplay:NSTextField!;
    @IBOutlet weak var nsTFPrefsPortDisplay:NSTextField!;
    @IBOutlet weak var nsTFPrefsUsernameDisplay:NSTextField!;
    @IBOutlet weak var nsTFPrefsPasswordDisplay:NSTextField!;
    @IBOutlet weak var nsBtnPrefsEndpointApply:NSButton!;
    @IBOutlet weak var nsBtnPrefsEndpointCancel:NSButton!;
    @IBOutlet weak var nsBtnPrefsEndpointTestConnection:NSButton!;
    @IBOutlet weak var nsBtnPrefsImage:NSButton!;
    @IBOutlet weak var nsTFPrefsViewDisplay:NSTextField!;
    @IBOutlet weak var nsOVPrefsEndpointsList:NSOutlineView!;
    @IBOutlet weak var nsBtnPrefsEndpointsPlus:NSButton!;
    @IBOutlet weak var nsBtnPrefsEndpointsMinus:NSButton!;
    
    let bPrefsViewInternalTest                = false;
    var cPrefsImageBtn                        = 0;
    var sPrefsViewDisplay                     = "";

    var indexCxDataEndpointActive:Int         = 0;
    var sCurrentPrefsEndpointKey:String       = "";
    var cxCurrentDataEndpoint:CxDataEndpoint? = nil;
    var asCxDataEndpointNames:[String]        = Array();

    let jsTraceLog:JsTraceLog                 = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                             = ClassInfo.sClsDisp;

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
        asToString.append("'nsTFPrefsEndpointsDisplay': [\(String(describing: self.nsTFPrefsEndpointsDisplay))],");
        asToString.append("'nsChkBPrefsEndpointActive': [\(String(describing: self.nsChkBPrefsEndpointActive))],");
        asToString.append("'nsCBPrefsProtocolDisplay': [\(String(describing: self.nsCBPrefsProtocolDisplay))],");
        asToString.append("'nsTFPrefsHostDisplay': [\(String(describing: self.nsTFPrefsHostDisplay))],");
        asToString.append("'nsTFPrefsPortDisplay': [\(String(describing: self.nsTFPrefsPortDisplay))],");
        asToString.append("'nsTFPrefsUsernameDisplay': [\(String(describing: self.nsTFPrefsUsernameDisplay))],");
        asToString.append("'nsTFPrefsPasswordDisplay': [\(String(describing: self.nsTFPrefsPasswordDisplay))],");
        asToString.append("'nsBtnPrefsEndpointApply': [\(String(describing: self.nsBtnPrefsEndpointApply))],");
        asToString.append("'nsBtnPrefsEndpointCancel': [\(String(describing: self.nsBtnPrefsEndpointCancel))],");
        asToString.append("'nsBtnPrefsEndpointTestConnection': [\(String(describing: self.nsBtnPrefsEndpointTestConnection))],");
        asToString.append("'nsBtnPrefsImage': [\(String(describing: self.nsBtnPrefsImage))]");
        asToString.append("'nsTFPrefsViewDisplay': [\(String(describing: self.nsTFPrefsViewDisplay))]");
        asToString.append("'nsOVPrefsEndpointsList': [\(String(describing: self.nsOVPrefsEndpointsList))]");
        asToString.append("'nsBtnPrefsEndpointsPlus': [\(String(describing: self.nsBtnPrefsEndpointsPlus))],");
        asToString.append("'nsBtnPrefsEndpointsMinus': [\(String(describing: self.nsBtnPrefsEndpointsMinus))],");
        asToString.append("'bPrefsViewInternalTest': [\(self.bPrefsViewInternalTest)],");
        asToString.append("'cPrefsImageBtn': [\(self.cPrefsImageBtn)],");
        asToString.append("'sPrefsViewDisplay': [\(self.sPrefsViewDisplay)],");
        asToString.append("'indexCxDataEndpointActive': [\(self.indexCxDataEndpointActive)],");
        asToString.append("'sCurrentPrefsEndpointKey': [\(self.sCurrentPrefsEndpointKey)],");
        asToString.append("'cxCurrentDataEndpoint': [\(String(describing: self.cxCurrentDataEndpoint))],");
        asToString.append("'asCxDataEndpointNames': [\(String(describing: self.asCxDataEndpointNames))],");
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

        ClassSingleton.cxAppPrefsViewController = self;

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        self.loadPreferencesViewForAllItems();
        
        self.nsBtnPrefsEndpointApply.isEnabled = false;

        self.nsOVPrefsEndpointsList.delegate   = self;
        self.nsOVPrefsEndpointsList.dataSource = self;

        self.sPrefsViewDisplay = "";

        self.updatePrefsViewDisplay();

    } // End of (override) func viewDidLoad().
    
    override func viewDidDisappear()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        CxDataRepo.sharedCxDataRepo.saveCxDataEndpoints();

        super.viewDidDisappear();

        ClassSingleton.cxAppPrefsViewController = nil;

    } // End of (override) func viewDidDisappear().

    override var representedObject: Any? 
    {

        didSet
        {

             self.updatePrefsViewDisplay();
        
        }

    }
    
    @IBAction func buttonPreferencesViewPressed(_ sender: Any)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        cPrefsImageBtn += 1;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");

        self.sPrefsViewDisplay = "";

        self.updatePrefsViewDisplay();
        
    } // End of func buttonPreferencesViewPressed().
    
    func updatePrefsViewDisplay()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.bPrefsViewInternalTest == true)
        {

            if (self.sPrefsViewDisplay.count < 1)
            {

                self.sPrefsViewDisplay = ">>> Button 'PrefsImage' pressed (\(self.cPrefsImageBtn)) times..."; 

            }

        }

        // Make sure that there is an 'Active' CxDataEndpoint:

        let cxActiveDataEndpoint:CxDataEndpoint? = CxDataRepo.sharedCxDataRepo.retrieveActiveCxDataEndpoint();

        if (cxActiveDataEndpoint == nil)
        {

            self.sPrefsViewDisplay = ">>> ERROR: NO CxServer URL is set as default - fix this before running a scan!"; 

        }

        self.nsTFPrefsViewDisplay.stringValue = self.sPrefsViewDisplay;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sPrefsViewDisplay' was [\(sPrefsViewDisplay)]...");

    } // End of func updatePrefsViewDisplay().

    func loadPreferencesViewForAllItems()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
        
        if (self.asCxDataEndpointNames.count > 0)
        {
            
            self.nsOVPrefsEndpointsList.removeItems(at: IndexSet(integersIn: (0..<self.asCxDataEndpointNames.count)), inParent: nil, withAnimation: NSTableView.AnimationOptions.effectFade);
            
        }
        
        self.asCxDataEndpointNames.removeAll();
        self.nsCBPrefsProtocolDisplay.removeAllItems();
        
        self.nsCBPrefsProtocolDisplay.addItem(withObjectValue: "HTTP");
        self.nsCBPrefsProtocolDisplay.addItem(withObjectValue: "HTTPS");

        self.nsCBPrefsProtocolDisplay.selectItem(at: 0);

        self.nsCBPrefsProtocolDisplay.delegate              = self;
        self.nsCBPrefsProtocolDisplay.numberOfVisibleItems  = 2;
        self.nsCBPrefsProtocolDisplay.completes             = false;

        self.indexCxDataEndpointActive = 0;
        self.sCurrentPrefsEndpointKey  = "";

        if (CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints.count > 1)
        {

            for (i, dictEntry) in CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints.enumerated()
            {

                let cxDataEndpoint:CxDataEndpoint = dictEntry.value;

                self.asCxDataEndpointNames.append(cxDataEndpoint.sCxEndpointName!);

                if (i == 0)
                {

                    self.nsTFPrefsEndpointsDisplay.stringValue = cxDataEndpoint.sCxEndpointName!;
                    self.nsChkBPrefsEndpointActive.state       = (cxDataEndpoint.bCxEndpointActive == true) ? NSControl.StateValue.on : NSControl.StateValue.off;
                    self.nsTFPrefsHostDisplay.stringValue      = cxDataEndpoint.sHttpHost!;
                    self.nsTFPrefsPortDisplay.stringValue      = cxDataEndpoint.sHttpPort!;
                    self.nsTFPrefsUsernameDisplay.stringValue  = cxDataEndpoint.sUsername!;
                    self.nsTFPrefsPasswordDisplay.stringValue  = cxDataEndpoint.sPassword!;

                    self.cxCurrentDataEndpoint    = cxDataEndpoint;
                    self.sCurrentPrefsEndpointKey = cxDataEndpoint.sCxEndpointName!;

                }

                if (cxDataEndpoint.bCxEndpointActive == true)
                {

                    self.nsTFPrefsEndpointsDisplay.stringValue = cxDataEndpoint.sCxEndpointName!;
                    self.nsChkBPrefsEndpointActive.state       = NSControl.StateValue.on;

                    _ = CxDataRepo.sharedCxDataRepo.resetAllCxDataEndpointsToInactive(sActiveEndpointKey: cxDataEndpoint.sCxEndpointName!);

                    if (cxDataEndpoint.sHttpProtocol == "https")
                    {

                        self.nsCBPrefsProtocolDisplay.selectItem(at: 1);

                    }

                    self.nsTFPrefsHostDisplay.stringValue     = cxDataEndpoint.sHttpHost!;
                    self.nsTFPrefsPortDisplay.stringValue     = cxDataEndpoint.sHttpPort!;
                    self.nsTFPrefsUsernameDisplay.stringValue = cxDataEndpoint.sUsername!;
                    self.nsTFPrefsPasswordDisplay.stringValue = cxDataEndpoint.sPassword!;

                    self.cxCurrentDataEndpoint     = cxDataEndpoint;
                    self.sCurrentPrefsEndpointKey  = cxDataEndpoint.sCxEndpointName!;
                    self.indexCxDataEndpointActive = i;

                }

            }

            self.nsOVPrefsEndpointsList.reloadData();

            self.nsOVPrefsEndpointsList.needsDisplay = true;

            self.nsOVPrefsEndpointsList.display();

        }

    } // End of func loadPreferencesViewForAllItems().
    
    func loadPreferencesViewForItem(atKey:String)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'atKey' [\(atKey)]...");

        self.sPrefsViewDisplay = "";

        let sNotificationKey:String        = atKey;
        let cxDataEndpoint:CxDataEndpoint? = CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints[sNotificationKey];

        if (cxDataEndpoint != nil)
        {

            self.nsTFPrefsEndpointsDisplay.stringValue = cxDataEndpoint!.sCxEndpointName!;
            self.nsChkBPrefsEndpointActive.state       = (cxDataEndpoint!.bCxEndpointActive == true) ? NSControl.StateValue.on : NSControl.StateValue.off;

            if (cxDataEndpoint!.bCxEndpointActive == true)
            {

                _ = CxDataRepo.sharedCxDataRepo.resetAllCxDataEndpointsToInactive(sActiveEndpointKey: cxDataEndpoint!.sCxEndpointName!);

            }

            if (cxDataEndpoint!.sHttpProtocol == "https")
            {

                self.nsCBPrefsProtocolDisplay.selectItem(at: 1);

            }
            else
            {

                self.nsCBPrefsProtocolDisplay.selectItem(at: 0);

            }

            self.nsTFPrefsHostDisplay.stringValue     = cxDataEndpoint!.sHttpHost!;
            self.nsTFPrefsPortDisplay.stringValue     = cxDataEndpoint!.sHttpPort!;
            self.nsTFPrefsUsernameDisplay.stringValue = cxDataEndpoint!.sUsername!;
            self.nsTFPrefsPasswordDisplay.stringValue = cxDataEndpoint!.sPassword!;

            let atIndex:Int = self.asCxDataEndpointNames.firstIndex(of: cxDataEndpoint!.sCxEndpointName!)!;

            self.cxCurrentDataEndpoint     = cxDataEndpoint!;
            self.sCurrentPrefsEndpointKey  = cxDataEndpoint!.sCxEndpointName!;
            self.indexCxDataEndpointActive = atIndex;

            self.nsBtnPrefsEndpointApply.isEnabled   = false;
            self.nsOVPrefsEndpointsList.needsDisplay = true;

            self.nsOVPrefsEndpointsList.display();

            return;

        }

        self.nsTFPrefsHostDisplay.stringValue     = "";                         
        self.nsTFPrefsPortDisplay.stringValue     = "";                         
        self.nsTFPrefsUsernameDisplay.stringValue = "";                         
        self.nsTFPrefsPasswordDisplay.stringValue = "";                         

        self.cxCurrentDataEndpoint     = nil;
        self.sCurrentPrefsEndpointKey  = "";
        self.indexCxDataEndpointActive = -1;

    } // End of func loadPreferencesViewForItem().

    func updateCxDataEndpointFromPreferencesView(cxDataEndpoint:CxDataEndpoint?)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'cxDataEndpoint' [\(String(describing: cxDataEndpoint))]...");

        if (cxDataEndpoint != nil)
        {

            let sCurrentHttpHost = self.nsTFPrefsHostDisplay.stringValue; 

            if (sCurrentHttpHost.count > 0)
            {

                let indexOfFwdSlash = sCurrentHttpHost.indexOfString(target: "/");

                if (indexOfFwdSlash >= 0)
                {

                    self.nsTFPrefsHostDisplay.stringValue = sCurrentHttpHost.subString(startIndex: 0, length: indexOfFwdSlash); 

                    self.sPrefsViewDisplay = ">>> ERROR: CxServer URL contains a '/' - it and all trailing data removed..."; 

                }

            }

            cxDataEndpoint!.bCxEndpointActive = (self.nsChkBPrefsEndpointActive.state == NSControl.StateValue.on) ? true : false;
            cxDataEndpoint!.sHttpProtocol     = (self.nsCBPrefsProtocolDisplay.indexOfSelectedItem == 0) ? "http" : "https";
            cxDataEndpoint!.sHttpHost         = self.nsTFPrefsHostDisplay.stringValue;
            cxDataEndpoint!.sHttpPort         = self.nsTFPrefsPortDisplay.stringValue;
            cxDataEndpoint!.sUsername         = self.nsTFPrefsUsernameDisplay.stringValue;
            cxDataEndpoint!.sPassword         = self.nsTFPrefsPasswordDisplay.stringValue;

            let atIndex:Int = self.asCxDataEndpointNames.firstIndex(of: cxDataEndpoint!.sCxEndpointName!)!;

            self.cxCurrentDataEndpoint     = cxDataEndpoint;
            self.sCurrentPrefsEndpointKey  = cxDataEndpoint!.sCxEndpointName!;
            self.indexCxDataEndpointActive = atIndex;

            return;

        }

        self.nsTFPrefsHostDisplay.stringValue     = "";                         
        self.nsTFPrefsPortDisplay.stringValue     = "";                         
        self.nsTFPrefsUsernameDisplay.stringValue = "";                         
        self.nsTFPrefsPasswordDisplay.stringValue = "";                         

        self.cxCurrentDataEndpoint     = nil;
        self.sCurrentPrefsEndpointKey  = "";
        self.indexCxDataEndpointActive = -1;

    } // End of func updateCxDataEndpointFromPreferencesView().

    @IBAction func buttonPreferencesEndpointApplyPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(String(describing: sender))]...");

        self.sPrefsViewDisplay = ""; 

        self.updateCxDataEndpointFromPreferencesView(cxDataEndpoint: self.cxCurrentDataEndpoint);

        if (self.cxCurrentDataEndpoint!.bCxEndpointActive == true)
        {

            _ = CxDataRepo.sharedCxDataRepo.resetAllCxDataEndpointsToInactive(sActiveEndpointKey: self.cxCurrentDataEndpoint!.sCxEndpointName!);

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For the CxDataEndpoint named [\(String(describing: self.cxCurrentDataEndpoint!.sCxEndpointName))] updated from the 'prefs' view 'body'...");

        self.sPrefsViewDisplay = ">>> Change(s) to the CxServer URL have been applied!";

        self.updatePrefsViewDisplay();

    } // End of func buttonPreferencesEndpointApplyPressed().
    
    @IBAction func buttonPreferencesEndpointCancelPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(String(describing: sender))]...");

        self.loadPreferencesViewForItem(atKey: self.cxCurrentDataEndpoint!.sCxEndpointName!);

        self.nsBtnPrefsEndpointApply.isEnabled = false;

        self.sPrefsViewDisplay = ">>> Change(s) to the CxServer URL have been cancelled!";

        self.updatePrefsViewDisplay();

    } // End of func buttonPreferencesEndpointCancelPressed().

    @IBAction func buttonPreferencesEndpointTestConnectionPressed(_ sender: Any)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(String(describing: sender))]...");

        let bTestConnectionOk = CxDataRepo.sharedCxDataRepo.performInitialLoadProcessing(cxDataEndpoint: self.cxCurrentDataEndpoint!);

        if (bTestConnectionOk == false)
        {

            self.nsBtnPrefsEndpointApply.isEnabled = false;

            self.sPrefsViewDisplay = ">>> ERROR: Connection to \(self.cxCurrentDataEndpoint!.sCxEndpointName!) failed!";

            self.updatePrefsViewDisplay();

            return;

        }

        self.nsBtnPrefsEndpointApply.isEnabled = true;

        self.sPrefsViewDisplay = ">>> Connected to \(self.cxCurrentDataEndpoint!.sCxEndpointName!) successfully!";

        self.updatePrefsViewDisplay();

        return;
        
    } // End of func buttonPreferencesEndpointTestConnectionPressed().
    
    @IBAction func buttonPreferencesPlusPressed(_ sender: Any)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(String(describing: sender))]...");

        let nsRectAccessory:NSRect    = NSRect(x: 0, y: 0, width: 280, height: 17);
        let nsTVAccessory:NSTextView  = NSTextView(frame: nsRectAccessory);
        let nsTFAccessory:NSTextField = NSTextField(frame: nsRectAccessory);

        nsTVAccessory.addSubview(nsTFAccessory);

        nsTVAccessory.isHorizontallyResizable = true;
        nsTVAccessory.isVerticallyResizable   = true;
        nsTVAccessory.isEditable              = true;
        nsTVAccessory.isFieldEditor           = true;
        nsTVAccessory.isHidden                = false;
        
        let nsLSAlertMsg = NSLocalizedString("Enter the 'new' Checkmarx Endpoint name:", comment: "Cancel without create error question message");
        let nsBtnCreate  = NSLocalizedString("Create", comment: "Create anyway button title");
        let nsBtnCancel  = NSLocalizedString("Cancel", comment: "Cancel button title");
        let nsAlert      = NSAlert();
        
        nsAlert.alertStyle    = NSAlert.Style.informational;
        nsAlert.messageText   = nsLSAlertMsg;
        nsAlert.accessoryView = nsTVAccessory;
        
        nsAlert.addButton(withTitle: nsBtnCreate);
        nsAlert.addButton(withTitle: nsBtnCancel);
        
        var nsAlertAnswer:NSApplication.ModalResponse?;
        
        nsAlert.beginSheetModal(for: self.view.window!, completionHandler:
            {   (modalResponse: NSApplication.ModalResponse) -> Void in
                
                nsAlertAnswer = modalResponse;
 
                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Alert answer 'nsAlertAnswer' [\(String(describing: nsAlertAnswer)))]...");

                if nsAlertAnswer != .alertFirstButtonReturn 
                {

                    // This is NOT the 'create' button ('cancel' button or the view was dismissed) - just do nothing and return:

                    return;

                }
                
                let sNewCxDataEndpointName:String? = nsTFAccessory.stringValue;
                
                if (sNewCxDataEndpointName        == nil ||
                    sNewCxDataEndpointName!.count < 1)
                {

                    // NO data was entered for a CxDataEndpoint name - just return:

                    return;
                    
                }

                let cxNewDataEndpoint:CxDataEndpoint?;

                if (self.cxCurrentDataEndpoint == nil)
                {

                    cxNewDataEndpoint = CxDataEndpoint();

                }
                else
                {

                    cxNewDataEndpoint = CxDataEndpoint(cxDataEndpoint: self.cxCurrentDataEndpoint!);

                }

                cxNewDataEndpoint!.sCxEndpointName = sNewCxDataEndpointName;

                _ = CxDataRepo.sharedCxDataRepo.registerCxDataEndpoint(cxDataEndpoint: cxNewDataEndpoint!);

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'selected' CxDataEndpoint named [\(String(describing: sNewCxDataEndpointName))] was added to the collection...");

                if (cxNewDataEndpoint!.bCxEndpointActive == true)
                {

                    _ = CxDataRepo.sharedCxDataRepo.resetAllCxDataEndpointsToInactive(sActiveEndpointKey: cxNewDataEndpoint!.sCxEndpointName!);

                }

                self.loadPreferencesViewForAllItems();
                self.updatePrefsViewDisplay();

                return;

            });

        return;

    } // End of func buttonPreferencesPlusPressed().
    
    @IBAction func buttonPreferencesMinusPressed(_ sender: Any)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(String(describing: sender))]...");
        
        let selectedIndex               = self.nsOVPrefsEndpointsList.selectedRow;
        let sCxDataEndpointName:String? = self.nsOVPrefsEndpointsList.item(atRow: selectedIndex) as? String;

        if (sCxDataEndpointName == nil ||
            sCxDataEndpointName!.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'selected' CxDataEndpoint name was 'nil' or empty - returning...");

            return;

        }

        let cxDataEndpoint:CxDataEndpoint? = CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints[sCxDataEndpointName!];

        if (cxDataEndpoint == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'selected' CxDataEndpoint named [\(sCxDataEndpointName!)] was 'nil' - returning...");

            return;

        }

        let nsLSAlertMsg = NSLocalizedString("Are you sure you want to 'delete' the Checkmarx Endpoint named '\(sCxDataEndpointName!)'?", comment: "Delete error question message");
        let nsBtnDelete  = NSLocalizedString("Ok", comment: "Delete anyway button title");
        let nsBtnCancel  = NSLocalizedString("Cancel", comment: "Cancel button title");
        let nsAlert      = NSAlert();

        nsAlert.alertStyle  = NSAlert.Style.informational;
        nsAlert.messageText = nsLSAlertMsg;

        nsAlert.addButton(withTitle: nsBtnDelete);
        nsAlert.addButton(withTitle: nsBtnCancel);

        var nsAlertAnswer:NSApplication.ModalResponse?;

        nsAlert.beginSheetModal(for: self.view.window!, completionHandler:
            {   (modalResponse: NSApplication.ModalResponse) -> Void in

                nsAlertAnswer = modalResponse;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Alert answer 'nsAlertAnswer' [\(String(describing: nsAlertAnswer)))]...");

                if nsAlertAnswer != .alertFirstButtonReturn 
                {

                    // This is NOT the 'delete' (Ok) button ('cancel' button or the view was dismissed) - just do nothing and return:

                    return;

                }

                _ = CxDataRepo.sharedCxDataRepo.deregisterCxDataEndpointClass(name: sCxDataEndpointName!);

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'selected' CxDataEndpoint named [\(sCxDataEndpointName!)] was deleted from the collection...");

                self.loadPreferencesViewForAllItems();
                self.updatePrefsViewDisplay();

                return;

            });

        return;

    } // End of func buttonPreferencesMinusPressed().
    
} // End of class PreferencesViewController.

extension PreferencesViewController: NSOutlineViewDataSource
{

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'outlineView' [\(String(describing: outlineView))] - 'item' [\(String(describing: item))]...");

        if (item != nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] that is NOT 'nil' returning 'numberOfChildrenOfItem' as (0)...");

            return 0;

        }

        let cCxDataEndpoints = CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints.count;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] that is 'nil' (ROOT item) returning 'numberOfChildrenOfItem' as (\(cCxDataEndpoints))...");

        return cCxDataEndpoints;

    } // End of func outlineView().

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'outlineView' [\(String(describing: outlineView))] - 'index' [\(String(describing: index))] - 'item' [\(String(describing: item))]...");

        let sCxDataEndpointName = self.asCxDataEndpointNames[index];

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'index' [\(String(describing: index))] - 'item' [\(String(describing: item))] - returning a value of 'sCxDataEndpointName' [\(sCxDataEndpointName)]...");

        return sCxDataEndpointName as Any;

    } // End of func outlineView().

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'outlineView' [\(String(describing: outlineView))] - 'item' [\(String(describing: item))] - returning 'isItemExpandable?' of [false]...");

        return false;

    } // End of func outlineView().

} // End of extension PreferencesViewController().

extension PreferencesViewController: NSOutlineViewDelegate 
{
		
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'outlineView' [\(String(describing: outlineView))] - 'tableColumn' [\(String(describing: tableColumn))] - 'item' [\(String(describing: item))]...");

        let nsTCVCxDataEndpoint:NSTableCellView? = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CxDataEndpointCell"), owner: self) as? NSTableCellView;

        if (nsTCVCxDataEndpoint == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] the constructed view for identifier 'CxDataEndpointCell' is 'nil' - Warning...");

        }
        else
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] the constructed view for identifier 'CxDataEndpointCell' is NOT 'nil' - 'nsTCVCxDataEndpoint' [\(String(describing: nsTCVCxDataEndpoint))]...");

            var nsTFCxDataEndpoint:NSTextField? = nil;

            if (nsTCVCxDataEndpoint!.textField != nil)
            {

                nsTFCxDataEndpoint = nsTCVCxDataEndpoint!.textField!;

            }
            else
            {

                let nsView:NSView = nsTCVCxDataEndpoint! as NSView;
                
                nsTFCxDataEndpoint = nsView.subviews[0] as? NSTextField;

            }

            if (nsTFCxDataEndpoint != nil)
            {

                nsTFCxDataEndpoint!.stringValue = item as! String;

                nsTFCxDataEndpoint!.sizeToFit();

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] updated (2) textField value(s)...");

            }
            else
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] the constructed view did NOT return a textField object...");

            }

        }

        return nsTCVCxDataEndpoint;

    } // End of func outlineView().

    func outlineViewSelectionDidChange(_ notification: Notification)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'notification' [\(String(describing: notification))]...");

        guard let outlineView = notification.object as? NSOutlineView else
        {

            return;

        }

        let selectedIndex = outlineView.selectedRow;

        if let sCxDataEndpointName = outlineView.item(atRow: selectedIndex) as? String
        {
        
            self.loadPreferencesViewForItem(atKey: sCxDataEndpointName);

            self.updatePrefsViewDisplay();

        }

    } // End of func outlineViewSelectionDidChange().

} // End of extension PreferencesViewController.

//  func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
//  {
//
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"'";
//
//      let sControlValue:String = control.stringValue;
//      let sFieldEditor:String  = fieldEditor.string;
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sControlValue' [\(sControlValue)] - 'sFieldEditor' [\(sFieldEditor)] - 'control' [\(control)] - 'fieldEditor' [\(fieldEditor)]...");
//
//      self.updateCxDataEndpointFromPreferencesView(cxDataEndpoint: self.cxCurrentDataEndpoint);
//
//      let cxNewDataEndpoint = CxDataEndpoint();
//
//      cxNewDataEndpoint.sCxEndpointName = sFieldEditor;
//
//      _ = CxDataRepo.sharedCxDataRepo.registerCxDataEndpoint(cxDataEndpoint: cxNewDataEndpoint);
//
//      self.updateCxDataEndpointFromPreferencesView(cxDataEndpoint: cxNewDataEndpoint);
//      self.nsCBPrefsEndpointsDisplay.addItem(withObjectValue: cxNewDataEndpoint.sCxEndpointName as Any);
//
//      self.nsCBPrefsProtocolDisplay.selectItem(at: (self.nsCBPrefsEndpointsDisplay.numberOfItems - 1));
//
//      self.updatePrefsViewDisplay();
//
//      return true;
//      
//  } // End of control().
//  
//  func comboBoxSelectionIsChanging(_ notification: Notification)
//  {
//      
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"'";
//
//      let nsCBNotification:NSComboBox     = ((notification.object as? NSComboBox)!);
//      let indexCxDataEndpointSelected:Int = nsCBNotification.indexOfSelectedItem;
//      let sCBNotificationKey:String       = (nsCBNotification.objectValueOfSelectedItem as? String)!;
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'indexCxDataEndpointSelected' [\(indexCxDataEndpointSelected)] - 'sCBNotificationKey' [\(sCBNotificationKey)] - 'notification' [\(notification)]...");
//      
//      if (nsCBNotification != self.nsCBPrefsEndpointsDisplay)
//      {
//
//          return;
//
//      }
//
//      self.updateCxDataEndpointFromPreferencesView(cxDataEndpoint:self.cxCurrentDataEndpoint);
//
//      self.updatePrefsViewDisplay();
//
//      return;
//
//  } // End of func comboBoxSelectionIsChanging().
//  
//  func comboBoxSelectionDidChange(_ notification: Notification)
//  {
//      
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"'";
//
//      let nsCBNotification:NSComboBox     = ((notification.object as? NSComboBox)!);
//      let indexCxDataEndpointSelected:Int = nsCBNotification.indexOfSelectedItem;
//      let sCBNotificationKey:String       = (nsCBNotification.objectValueOfSelectedItem as? String)!;
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'indexCxDataEndpointSelected' [\(indexCxDataEndpointSelected)] - 'sCBNotificationKey' [\(sCBNotificationKey)] - 'notification' [\(notification)]...");
//
//      if (nsCBNotification != self.nsCBPrefsEndpointsDisplay)
//      {
//
//          return;
//
//      }
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'indexCurrentPrefsEndpoint' [\(self.indexCurrentPrefsEndpoint)] - 'sCurrentPrefsEndpointKey' [\(self.sCurrentPrefsEndpointKey)] - 'cxCurrentDataEndpoint' [\(String(describing: self.cxCurrentDataEndpoint))]...");
//
//      self.loadPreferencesViewForItem(atIndex:indexCxDataEndpointSelected, triggerIsComboBox: true);
//
//      self.updatePrefsViewDisplay();
//
//  } // End of func comboBoxSelectionDidChange().
    
