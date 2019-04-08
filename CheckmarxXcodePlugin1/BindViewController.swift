//  
//  BindViewController.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 3/20/19.
//  Copyright © 2019 Daryl R. Cox. All rights reserved.
//

import Foundation
import Cocoa

class BindViewController: NSViewController, NSComboBoxDelegate
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "BindViewController";
        static let sClsVers        = "v1.0403";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }
    
    struct ClassSingleton
    {
        
        static var cxAppBindViewController:BindViewController? = nil;
        
    }
    
    @IBOutlet weak var nsTFBindKeyDisplay:NSTextField!;
    @IBOutlet weak var nsCBBindEndpointDisplay:NSComboBox!;
    @IBOutlet weak var nsCBBindProjectNameDisplay:NSComboBox!;
    @IBOutlet weak var nsTFBindProjectIdDisplay:NSTextField!;
    @IBOutlet weak var nsTFBindOriginDisplay:NSTextField!;
    @IBOutlet weak var nsBtnBindApply:NSButton!;
    @IBOutlet weak var nsBtnBindCancel:NSButton!;
    @IBOutlet weak var nsBtnBindMainImage:NSButton!;
    @IBOutlet weak var nsTFBindMainViewDisplay:NSTextField!;
    @IBOutlet weak var nsOVBindIdDisplay:NSOutlineView!;
    @IBOutlet weak var nsBtnBindIdPlus:NSButton!;
    @IBOutlet weak var nsBtnBindIdMinus:NSButton!;
    
    var cBindImageBtn                         = 0;
    var sBindViewDisplay                      = "";

    var indexBindSelected:Int                 = 0;
    var cxCurrentBind:Bind?                   = nil;
    var asCxDataBindIds:[String]              = Array();
    var sCurrentBindEndpointKey:String        = "";
    var cxCurrentDataEndpoint:CxDataEndpoint? = nil;

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
        
        ClassSingleton.cxAppBindViewController = self;
        
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
        
        self.loadBindViewForAllItems();
        
        self.nsOVBindIdDisplay.delegate   = self;
        self.nsOVBindIdDisplay.dataSource = self;

        self.updateBindViewDisplay();

    } // End of (override) func viewDidLoad().
    
    override func viewDidDisappear()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
        
        CxDataRepo.sharedCxDataRepo.saveCxDataBinds();

        super.viewDidDisappear();
        
        ClassSingleton.cxAppBindViewController = nil;
        
    } // End of (override) func viewDidDisappear().
    
    override var representedObject: Any?
    {
        
        didSet
        {
            
            // Update the view, if already loaded.
            
             self.updateBindViewDisplay();

        }
        
    }

    @IBAction func buttonBindMainImagePressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

        self.cBindImageBtn += 1;

        self.sBindViewDisplay = "";

        self.updateBindViewDisplay();

    } // End of func buttonBindMainImagePressed().
    
    func updateBindViewDisplay()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.sBindViewDisplay.count < 1)
        {

            self.sBindViewDisplay = ">>> Button 'BindImage' pressed (\(self.cBindImageBtn)) times..."; 

        }

        // Make sure that there is an 'Active' CxDataEndpoint:

        let cxActiveDataEndpoint:CxDataEndpoint? = CxDataRepo.sharedCxDataRepo.retrieveActiveCxDataEndpoint();

        if (cxActiveDataEndpoint == nil)
        {

            self.sBindViewDisplay = ">>> ERROR: NO Endpoint is marked 'active'!"; 

        }

        self.nsTFBindMainViewDisplay.stringValue = self.sBindViewDisplay;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' 'sBindViewDisplay' was [\(sBindViewDisplay)]...");

    } // End of func updateBindViewDisplay().

    func loadBindViewForAllItems()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
        
        if (self.asCxDataBindIds.count > 0)
        {
            
            self.nsOVBindIdDisplay.removeItems(at: IndexSet(integersIn: (0..<self.asCxDataBindIds.count)), inParent: nil, withAnimation: NSTableView.AnimationOptions.effectFade);
            
        }
        
        self.nsCBBindEndpointDisplay.removeAllItems();

        self.nsCBBindEndpointDisplay.delegate             = self;
        self.nsCBBindEndpointDisplay.numberOfVisibleItems = 3;
        self.nsCBBindEndpointDisplay.completes            = false;

        self.indexBindSelected                            = 0;
        self.sCurrentBindEndpointKey                      = "";

        self.asCxDataBindIds.removeAll();

        self.indexBindSelected = 0;

        if (CxDataRepo.sharedCxDataRepo.cxDataBinds!.binds!.count > 0)
        {

            for (i, bindEntry) in CxDataRepo.sharedCxDataRepo.cxDataBinds!.binds!.enumerated()
            {

                let bind:Bind = bindEntry;

                self.asCxDataBindIds.append(bind.id);

                if (i == 0)
                {

                    self.nsTFBindKeyDisplay.stringValue       = bind.key;
                    self.nsTFBindProjectIdDisplay.stringValue = "\(bind.cxProjectId)";
                    self.nsTFBindOriginDisplay.stringValue    = bind.cxBindOrigin;

                    self.sCurrentBindEndpointKey              = bind.cxProjectName;

                }

            }

        }

        if (self.sCurrentBindEndpointKey.count < 1)
        {

            let cxActiveDataEndpoint:CxDataEndpoint? = CxDataRepo.sharedCxDataRepo.retrieveActiveCxDataEndpoint();

            if (cxActiveDataEndpoint != nil)
            {

                self.sCurrentBindEndpointKey = cxActiveDataEndpoint!.sCxEndpointName ?? "";

            }
            else
            {

                self.sCurrentBindEndpointKey = "";

            }

        }

        if (CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints.count > 0)
        {

            for (i, dictEntry) in CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints.enumerated()
            {

                let cxDataEndpoint:CxDataEndpoint = dictEntry.value;

                self.nsCBBindEndpointDisplay.addItem(withObjectValue: cxDataEndpoint.sCxEndpointName!);

                if (cxDataEndpoint.sCxEndpointName! == self.sCurrentBindEndpointKey)
                {

                    self.nsCBBindEndpointDisplay.selectItem(at: i);

                }

            }

        }

        self.nsOVBindIdDisplay.reloadData();

        self.nsOVBindIdDisplay.needsDisplay = true;

        self.nsOVBindIdDisplay.display();

    } // End of func loadBindViewForAllItems().
    
//  func loadBindViewForItem(atKey:String)
//  {
//
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'atKey' [\(atKey)]...");
//
//      let sNotificationKey:String        = atKey;
//      let cxDataEndpoint:CxDataEndpoint? = CxDataRepo.sharedCxDataRepo.dictCxDataEndpoints[sNotificationKey];
//
//      if (cxDataEndpoint != nil)
//      {
//
//          self.nsTFBindKeyDisplay.stringValue = cxDataEndpoint!.sCxEndpointName!;
//          self.nsChkBBindEndpointActive.state       = (cxDataEndpoint!.bCxEndpointActive == true) ? NSControl.StateValue.on : NSControl.StateValue.off;
//
//          if (cxDataEndpoint!.bCxEndpointActive == true)
//          {
//
//              _ = CxDataRepo.sharedCxDataRepo.resetAllCxDataEndpointsToInactive(sActiveEndpointKey: cxDataEndpoint!.sCxEndpointName!);
//
//          }
//
//          if (cxDataEndpoint!.sHttpProtocol == "https")
//          {
//
//              self.nsCBBindEndpointDisplay.selectItem(at: 1);
//
//          }
//          else
//          {
//
//              self.nsCBBindEndpointDisplay.selectItem(at: 0);
//
//          }
//
//          self.nsTFBindHostDisplay.stringValue     = cxDataEndpoint!.sHttpHost!;
//          self.nsTFBindPortDisplay.stringValue     = cxDataEndpoint!.sHttpPort!;
//          self.nsTFBindUsernameDisplay.stringValue = cxDataEndpoint!.sUsername!;
//          self.nsTFBindPasswordDisplay.stringValue = cxDataEndpoint!.sPassword!;
//
//          let atIndex:Int = self.asCxDataBindIds.firstIndex(of: cxDataEndpoint!.sCxEndpointName!)!;
//
//          self.cxCurrentDataEndpoint     = cxDataEndpoint!;
//          self.sCurrentBindEndpointKey  = cxDataEndpoint!.sCxEndpointName!;
//          self.indexBindSelected = atIndex;
//
//          self.nsOVBindIdDisplay.needsDisplay = true;
//
//          self.nsOVBindIdDisplay.display();
//
//          return;
//
//      }
//
//      self.nsTFBindHostDisplay.stringValue     = "";                         
//      self.nsTFBindPortDisplay.stringValue     = "";                         
//      self.nsTFBindUsernameDisplay.stringValue = "";                         
//      self.nsTFBindPasswordDisplay.stringValue = "";                         
//
//      self.cxCurrentDataEndpoint     = nil;
//      self.sCurrentBindEndpointKey  = "";
//      self.indexBindSelected = -1;
//
//  } // End of func loadBindViewForItem().
//
//  func updateCxDataEndpointFromBindView(cxDataEndpoint:CxDataEndpoint?)
//  {
//
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'cxDataEndpoint' [\(String(describing: cxDataEndpoint))]...");
//
//      if (cxDataEndpoint != nil)
//      {
//
//          let sCurrentHttpHost = self.nsTFBindHostDisplay.stringValue; 
//
//          if (sCurrentHttpHost.count > 0)
//          {
//
//              let indexOfFwdSlash = sCurrentHttpHost.indexOfString(target: "/");
//
//              if (indexOfFwdSlash >= 0)
//              {
//
//                  self.nsTFBindHostDisplay.stringValue = sCurrentHttpHost.subString(startIndex: 0, length: indexOfFwdSlash); 
//
//                  self.sBindViewDisplay = ">>> ERROR: Endpoint contains a '/' - it and all trailing data removed..."; 
//
//              }
//
//          }
//
//          cxDataEndpoint!.bCxEndpointActive = (self.nsChkBBindEndpointActive.state == NSControl.StateValue.on) ? true : false;
//          cxDataEndpoint!.sHttpProtocol     = (self.nsCBBindEndpointDisplay.indexOfSelectedItem == 0) ? "http" : "https";
//          cxDataEndpoint!.sHttpHost         = self.nsTFBindHostDisplay.stringValue;
//          cxDataEndpoint!.sHttpPort         = self.nsTFBindPortDisplay.stringValue;
//          cxDataEndpoint!.sUsername         = self.nsTFBindUsernameDisplay.stringValue;
//          cxDataEndpoint!.sPassword         = self.nsTFBindPasswordDisplay.stringValue;
//
//          let atIndex:Int = self.asCxDataBindIds.firstIndex(of: cxDataEndpoint!.sCxEndpointName!)!;
//
//          self.cxCurrentDataEndpoint     = cxDataEndpoint;
//          self.sCurrentBindEndpointKey  = cxDataEndpoint!.sCxEndpointName!;
//          self.indexBindSelected = atIndex;
//
//          return;
//
//      }
//
//      self.nsTFBindHostDisplay.stringValue     = "";                         
//      self.nsTFBindPortDisplay.stringValue     = "";                         
//      self.nsTFBindUsernameDisplay.stringValue = "";                         
//      self.nsTFBindPasswordDisplay.stringValue = "";                         
//
//      self.cxCurrentDataEndpoint     = nil;
//      self.sCurrentBindEndpointKey  = "";
//      self.indexBindSelected = -1;
//
//  } // End of func updateCxDataEndpointFromBindView().

    @IBAction func buttonBindApplyPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

    } // End of func buttonBindApplyPressed().
    
    @IBAction func buttonBindCancelPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

    } // End of func buttonBindCancelPressed().
    
    @IBAction func buttonBindIdPlusPressed(_ sender: Any) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

    } // End of func buttonBindIdPlusPressed().
    
    @IBAction func buttonBindIdMinusPressed(_ sender: Any)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' [\(sender)]...");

    } // End of func buttonBindIdMinusPressed().
    
} // End of class BindViewController.

extension BindViewController: NSOutlineViewDataSource
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

        let cCxDataBinds = CxDataRepo.sharedCxDataRepo.cxDataBinds!.binds!.count;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] that is 'nil' (ROOT item) returning 'numberOfChildrenOfItem' as (\(cCxDataBinds))...");

        return cCxDataBinds;

    } // End of func outlineView().

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'outlineView' [\(String(describing: outlineView))] - 'index' [\(String(describing: index))] - 'item' [\(String(describing: item))]...");

        if (self.asCxDataBindIds.count < 1)
        {

            return "";

        }

        let sCxDataBindId = self.asCxDataBindIds[index];

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'index' [\(String(describing: index))] - 'item' [\(String(describing: item))] - returning a value of 'sCxDataBindId' [\(sCxDataBindId)]...");

        return sCxDataBindId as Any;

    } // End of func outlineView().

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'outlineView' [\(String(describing: outlineView))] - 'item' [\(String(describing: item))] - returning 'isItemExpandable?' of [false]...");

        return false;

    } // End of func outlineView().

} // End of extension BindViewController().

extension BindViewController: NSOutlineViewDelegate 
{
		
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'outlineView' [\(String(describing: outlineView))] - 'tableColumn' [\(String(describing: tableColumn))] - 'item' [\(String(describing: item))]...");

        let nsTCVCxDataBind:NSTableCellView? = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CxDataBindCell"), owner: self) as? NSTableCellView;

        if (nsTCVCxDataBind == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] the constructed view for identifier 'CxDataBindCell' is 'nil' - Warning...");

        }
        else
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] the constructed view for identifier 'CxDataBindCell' is NOT 'nil' - 'nsTCVCxDataBind' [\(String(describing: nsTCVCxDataBind))]...");

            var nsTFCxDataBind:NSTextField? = nil;

            if (nsTCVCxDataBind!.textField != nil)
            {

                nsTFCxDataBind = nsTCVCxDataBind!.textField!;

            }
            else
            {

                let nsView:NSView = nsTCVCxDataBind! as NSView;
                
                nsTFCxDataBind = nsView.subviews[0] as? NSTextField;

            }

            if (nsTFCxDataBind != nil)
            {

                nsTFCxDataBind!.stringValue = item as! String;

                nsTFCxDataBind!.sizeToFit();

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] updated (2) textField value(s)...");

            }
            else
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For an 'item' [\(String(describing: item))] the constructed view did NOT return a textField object...");

            }

        }

        return nsTCVCxDataBind;

    } // End of func outlineView().

//  func outlineViewSelectionDidChange(_ notification: Notification)
//  {
//
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'notification' [\(String(describing: notification))]...");
//
//      guard let outlineView = notification.object as? NSOutlineView else
//      {
//
//          return;
//
//      }
//
//      let selectedIndex = outlineView.selectedRow;
//
//      if let sCxDataEndpointName = outlineView.item(atRow: selectedIndex) as? String
//      {
//      
//          self.loadBindViewForItem(atKey: sCxDataEndpointName);
//
//          self.updatePrefsViewDisplay();
//
//      }
//
//  } // End of func outlineViewSelectionDidChange().

} // End of extension BindViewController.

