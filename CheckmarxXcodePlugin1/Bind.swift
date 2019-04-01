//
//  Bind.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 03/10/19.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Cocoa

@objc(Bind) class Bind: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "Bind";
        static let sClsVers        = "v1.0401";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    @objc var id:String;

    @objc var key:String 
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var cxEndpointKey:String
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var cxProjectName:String
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var cxProjectId:Int 
    {
        didSet { postNotificationOfChanges() }
    };

    // A value of "CxBindSourceIsXcode" indicates that the 'bind' came from a direct Xcode call:

    @objc var cxBindOrigin:String
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var cxLastSASTScanReportFilespec:String
    {
        didSet { postNotificationOfChanges() }
    };

    // Bind 'Report' settings - these override 'Scan' attributes:

    @objc var bCxBindGenerateReport:Bool
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var cxBindReportType:String
    {
        didSet { postNotificationOfChanges() }
    };

    let jsTraceLog:JsTraceLog     = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                 = ClassInfo.sClsDisp;

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
        asToString.append("'key': [\(self.key)],");
        asToString.append("'cxEndpointKey': [\(self.cxEndpointKey)],");
        asToString.append("'cxProjectName': [\(self.cxProjectName)],");
        asToString.append("'cxProjectId': [\(self.cxProjectId)],");
        asToString.append("'cxBindOrigin': [\(self.cxBindOrigin)],");
        asToString.append("'cxLastSASTScanReportFilespec': [\(self.cxLastSASTScanReportFilespec)],");
        asToString.append("'bCxBindGenerateReport': [\(self.bCxBindGenerateReport)],");
        asToString.append("'cxBindReportType': [\(self.cxBindReportType)],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog)],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of (open) func toString().

    override init()
    {

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.id                           = UUID().uuidString;
        self.key                          = "";
        self.cxEndpointKey                = "";
        self.cxProjectName                = "";
        self.cxProjectId                  = 0;
        self.cxBindOrigin                 = "";
        self.cxLastSASTScanReportFilespec = "";
        self.bCxBindGenerateReport        = false;
        self.cxBindReportType             = "";

        super.init();

    } // End of (override) init().

    convenience init(bind:Bind)
    {

        self.init();
        
        self.key                          = bind.key;
        self.cxEndpointKey                = bind.cxEndpointKey;
        self.cxProjectName                = bind.cxProjectName;
        self.cxProjectId                  = bind.cxProjectId;
        self.cxBindOrigin                 = bind.cxBindOrigin;
        self.cxLastSASTScanReportFilespec = bind.cxLastSASTScanReportFilespec;
        self.bCxBindGenerateReport        = bind.bCxBindGenerateReport;
        self.cxBindReportType             = bind.cxBindReportType;

    } // End of (override) init().

    init?(plistEntry: [String: AnyObject])
    {

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        guard let key = plistEntry["Key"] as? String else { return nil };

        self.id                           = UUID().uuidString;
        self.key                          = key;
        self.cxEndpointKey                = plistEntry["CxDataEndpointKey"]            as? String ?? "";
        self.cxProjectName                = plistEntry["CxProjectName"]                as? String ?? "";
        let cxProjectIdEntry              = plistEntry["CxProjectId"]                  as? String ?? "0";
        let cxProjectIdValue              = Int(cxProjectIdEntry) ?? 0;
        self.cxProjectId                  = cxProjectIdValue;
        self.cxBindOrigin                 = plistEntry["CxBindOrigin"]                 as? String ?? "";
        self.cxLastSASTScanReportFilespec = plistEntry["CxLastSASTScanReportFilespec"] as? String ?? "";
        let cxBindGenerateReport          = plistEntry["CxBindGenerateReport"]         as? String ?? "";
        self.bCxBindGenerateReport        = (cxBindGenerateReport == "true");
        self.cxBindReportType             = plistEntry["CxBindReportType"]             as? String ?? ""; 
        
        super.init();

    } // End of init?().

    func postNotificationOfChanges() 
    {

        NotificationCenter.default.post(name: Notification.Name(rawValue: "SingleBindDataChanged"), object: ["newBindData": self]);

    } // End of func postNotificationOfChanges().

    override var objectSpecifier: NSScriptObjectSpecifier
    {

        let appDescription = NSApplication.shared.classDescription as! NSScriptClassDescription;
        let specifier      = NSUniqueIDSpecifier(containerClassDescription: appDescription, containerSpecifier: nil, key: "binds", uniqueID: self.id);

        return specifier;

    } // End of (override) var objectSpecifier.

//  override func newScriptingObject(of objectClass: AnyClass, forValueForKey key: String, withContentsValue contentsValue: Any?, properties: [String: Any]) -> Any?
//  {
//
//      let sCurrMethod:String = #function;
//      let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
//
//      self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'objectClass' [\(objectClass)] - 'key' [\(key)] - 'contentsValue' [\(String(describing: contentsValue))] - 'properties' [\(properties)]...");
//
//      let attr:Attr = super.newScriptingObject(of: objectClass, forValueForKey: key, withContentsValue: contentsValue, properties: properties) as! Attr;
//
//      attr.scan = self;
//
//      return attr;
//
//  } // End of (override) func newScriptingObject().
    
    override func insertValue(_ value: Any, at index: Int, inPropertyWithKey key: String)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'value' [\(value)] - 'index' [\(index)] - 'key' [\(key)]...");
        
        return super.insertValue(value, at:index, inPropertyWithKey:key);
        
    } // End of (override) func insertValue().

    override func insertValue(_ value: Any, inPropertyWithKey key: String)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'value' [\(value)] - 'key' [\(key)]...");
        
        return super.insertValue(value, inPropertyWithKey:key);
        
    } // End of (override) func insertValue(). 

    @objc func tagBindOrigin(_ command: NSScriptCommand) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'command' [\(command)]...");

        if let bind          = command.evaluatedReceivers as? Bind,
           let bindOriginSrc = command.evaluatedArguments?["bindOriginSrc"] as? String 
        {

            if self == bind
            {

                self.cxBindOrigin = bindOriginSrc;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Tagged the 'cxBindOrigin' as [\(self.cxBindOrigin)]...");

            }

        }

    } // End of func tagBindOrigin().

    @objc func viewBindLastSASTScanReport(_ command: NSScriptCommand) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'command' [\(command)]...");

        if let bind = command.evaluatedReceivers as? Bind
        {

            if self == bind
            {

                let cxAppDelegate:AppDelegate = AppDelegate.ClassSingleton.cxAppDelegate!;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Calling the 'cxAppDelegate' [\(cxAppDelegate)]...");

                CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentScanOnHold = nil;

                _ = cxAppDelegate.invokeBindOrUnbindViaAPICall(bind: self, bCallIsForReportView: true);

            }

        }

    } // End of func viewBindLastSASTScanReport().

    @objc func handleBindOrUnbind(_ command: NSScriptCommand) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'command' [\(command)]...");

        if let bind = command.evaluatedReceivers as? Bind
        {

            if self == bind
            {

                let cxAppDelegate:AppDelegate = AppDelegate.ClassSingleton.cxAppDelegate!;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Calling the 'cxAppDelegate' [\(cxAppDelegate)]...");

                CxDataRepo.sharedCxDataRepo.cxDataBinds!.currentScanOnHold = nil;

                _ = cxAppDelegate.invokeBindOrUnbindViaAPICall(bind: self, bCallIsForReportView: false);

            }

        }

    } // End of func handleBindOrUnbind().

} // End of class Bind.

