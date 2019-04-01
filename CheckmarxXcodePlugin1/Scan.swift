//
//  Scan.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 12/29/18.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Cocoa

@objc(Scan) class Scan: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "Scan";
        static let sClsVers        = "v1.0401";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    // Variables that are used in scripting (and saved to the plist file):

    @objc var id:String;

    @objc var title:String 
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var daysUntilDue:Int 
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var completed:Bool 
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var fullScan:Bool
    {
        didSet { postNotificationOfChanges() }
    };

    @objc var attrs:[Attr]
    {
        didSet { postNotificationOfChanges() }
    }

    // Variables that are NOT used in scripting (nor are saved to the plist):

    var sAppXcodeWSDocFilespec:String         = "";
    var sAppUploadZipFilespec:String          = "";
    var sAppCxProjectName:String              = "";
    var cAppCxProjectId:Int                   = 0;

    var sAppLastSASTScanId:String             = "";
    var idAppLastSASTScanStatus:Int           = 0;
    var sAppLastSASTScanStatus:String         = "";
    var sAppLastSASTScanStage:String          = "";

    var sAppLastSASTScanReportType:String     = "";
    var sAppLastSASTScanReportId:String       = "";
    var idAppLastSASTScanReportStatus:Int     = 0;
    var sAppLastSASTScanReportValue:String    = "";
    var sAppLastSASTScanReportFilespec:String = "";

    let jsTraceLog:JsTraceLog = JsTraceLog.sharedJsTraceLog;
    let sTraceCls             = ClassInfo.sClsDisp;

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
        asToString.append("'title': [\(self.title)],");
        asToString.append("'daysUntilDue': [\(self.daysUntilDue)],");
        asToString.append("'completed': [\(self.completed)],");
        asToString.append("'fullScan': [\(self.fullScan)],");
        asToString.append("'sAppXcodeWSDocFilespec': [\(self.sAppXcodeWSDocFilespec)],");
        asToString.append("'sAppUploadZipFilespec': [\(self.sAppUploadZipFilespec)],");
        asToString.append("'sAppCxProjectName': [\(self.sAppCxProjectName)],");
        asToString.append("'cAppCxProjectId': [\(self.cAppCxProjectId)],");
        asToString.append("'sAppLastSASTScanId': [\(self.sAppLastSASTScanId)],");
        asToString.append("'idAppLastSASTScanStatus': (\(self.idAppLastSASTScanStatus)),");
        asToString.append("'sAppLastSASTScanStatus': [\(self.sAppLastSASTScanStatus)],");
        asToString.append("'sAppLastSASTScanStage': [\(self.sAppLastSASTScanStage)],");
        asToString.append("'sAppLastSASTScanReportType': [\(self.sAppLastSASTScanReportType)],");
        asToString.append("'sAppLastSASTScanReportId': [\(self.sAppLastSASTScanReportId)],");
        asToString.append("'idAppLastSASTScanReportStatus': [\(self.idAppLastSASTScanReportStatus)],");
        asToString.append("'sAppLastSASTScanReportValue': [\(self.sAppLastSASTScanReportValue)],");
        asToString.append("'sAppLastSASTScanReportFilespec': [\(self.sAppLastSASTScanReportFilespec)],");
        asToString.append("'attrs': [\(self.attrs)],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog)],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of (open) func toString().

    override init()
    {

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.id                             = UUID().uuidString;
        self.title                          = "";
        self.daysUntilDue                   = 0;
        self.completed                      = false;
        self.fullScan                       = true;
        self.attrs                          = [];
        self.sAppXcodeWSDocFilespec         = "";
        self.sAppUploadZipFilespec          = "";
        self.sAppLastSASTScanId             = "";
        self.idAppLastSASTScanStatus        = 0;
        self.sAppLastSASTScanStatus         = "";
        self.sAppLastSASTScanStage          = "";
        self.sAppLastSASTScanReportType     = "";
        self.sAppLastSASTScanReportId       = "";
        self.idAppLastSASTScanReportStatus  = 0;
        self.sAppLastSASTScanReportValue    = "";
        self.sAppLastSASTScanReportFilespec = "";

        super.init();

    } // End of (override) init().

    convenience init(scan:Scan)
    {

        self.init();
        
        self.title                          = "\(scan.title) Sub #(\((CxDataRepo.sharedCxDataRepo.cxDataScans!.scans!.count + 1)))";
        self.daysUntilDue                   = 0;
        self.completed                      = false;
        self.fullScan                       = scan.fullScan;
        self.attrs                          = Array(scan.attrs);
        self.sAppXcodeWSDocFilespec         = scan.sAppXcodeWSDocFilespec;
        self.sAppUploadZipFilespec          = "";
        self.sAppLastSASTScanId             = "";
        self.idAppLastSASTScanStatus        = 0;
        self.sAppLastSASTScanStatus         = "";
        self.sAppLastSASTScanStage          = "";
        self.sAppLastSASTScanReportType     = "";
        self.sAppLastSASTScanReportId       = "";
        self.idAppLastSASTScanReportStatus  = 0;
        self.sAppLastSASTScanReportValue    = "";
        self.sAppLastSASTScanReportFilespec = "";

    } // End of (override) init().

    init?(plistEntry: [String: AnyObject])
    {

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        guard let title = plistEntry["Title"] as? String else { return nil };

        self.id                             = UUID().uuidString;
        self.title                          = title;
        let dueInDaysEntry                  = plistEntry["Due In"]    as? String ?? "3";
        let dueInDays                       = Int(dueInDaysEntry) ?? 3;
        self.daysUntilDue                   = dueInDays;
        let completedEntry                  = plistEntry["Completed"] as? String ?? "false";
        self.completed                      = (completedEntry == "true");
        let fullScanEntry                   = plistEntry["FullScan"]  as? String ?? "false";
        self.fullScan                       = (fullScanEntry  == "true");
        self.attrs                          = [];
        self.sAppXcodeWSDocFilespec         = "";
        self.sAppUploadZipFilespec          = "";
        self.sAppLastSASTScanId             = "";
        self.idAppLastSASTScanStatus        = 0;
        self.sAppLastSASTScanStatus         = "";
        self.sAppLastSASTScanStage          = "";
        self.sAppLastSASTScanReportType     = "";
        self.sAppLastSASTScanReportId       = "";
        self.idAppLastSASTScanReportStatus  = 0;
        self.sAppLastSASTScanReportValue    = "";
        self.sAppLastSASTScanReportFilespec = "";
        
        super.init();

        if let attrString = plistEntry["Attrs"] as? String 
        {

            if (attrString.count > 0)
            {

                let attrNames = attrString.components(separatedBy: ",");

                for attr in attrNames 
                {

                    let attrFields = attr.components(separatedBy: ":");
                    let newAttr    = Attr(name: attrFields[0], value: attrFields[1]);

                    if (newAttr.name == "CxXcodeWSDocFilespec")
                    {

                        self.sAppXcodeWSDocFilespec = newAttr.value;

                        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:"init?()", sTraceClsMsg:"'newAttr' [\(newAttr.toString())] exists in the 'attrs' of the loading 'Scan'...");

                    }

                    self.appendUniqueAttr(attr: newAttr);

                }

            }
        }

    } // End of init?().

    func attrNamesAsString() -> String
    {

        let attrNamesArray = attrs.map {$0.name};

        return attrNamesArray.joined(separator: ", ");

    } // End of func attrNamesAsString().

    func attrValuesAsString() -> String
    {

        let attrValuesArray = attrs.map {$0.value};

        return attrValuesArray.joined(separator: ", ");

    } // End of func attrValuesAsString().

    func appendUniqueAttr(attr:Attr)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'attr' is [\(attr)]...");

        for (i, scanAttr) in self.attrs.enumerated()
        {

        //  self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)]...");

            if (scanAttr.name == attr.name)
            {

                self.attrs.remove(at: i);

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)] - has been removed from the array...");

            }

        }

        self.attrs.append(attr);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'new' Scan.attr Named [\(attr.name)], Value [\(attr.value)] - has been added to the array...");

    } // End of appendUniqueAttr().

    func locateUniqueAttr(name:String) -> Attr?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'name' is [\(name)]...");

        for (i, scanAttr) in self.attrs.enumerated()
        {

        //  self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)]...");

            if (scanAttr.name == name)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)] - matches the requested 'name' of [\(name)] - returning this element...");

                return scanAttr;

            }

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The Scan.attr Named [\(name)] was NOT found in the array - returning 'nil'...");

        return nil;

    } // End of locateUniqueAttr().

    func removeUniqueAttr(name:String) -> Attr?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'name' is [\(name)]...");

        for (i, scanAttr) in self.attrs.enumerated()
        {

        //  self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)]...");

            if (scanAttr.name == name)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)] - matches the requested 'name' of [\(name)] - returning this 'removed' element...");

                self.attrs.remove(at: i);

                return scanAttr;

            }

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The Scan.attr Named [\(name)] was NOT found in the array - returning 'nil'...");

        return nil;

    } // End of removeUniqueAttr().

    func removeUniqueAttr(attr:Attr) -> Attr?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'attr' is [\(attr)]...");

        for (i, scanAttr) in self.attrs.enumerated()
        {

        //  self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)]...");

            if (scanAttr.name == attr.name)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Scan.attr #(\(i)): Name [\(scanAttr.name)], Value [\(scanAttr.value)] - matches the requested 'name' of [\(attr.name)] - returning this 'removed' element...");

                self.attrs.remove(at: i);

                return scanAttr;

            }

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The Scan.attr Named [\(attr.name)], Value [\(attr.value)] was NOT found in the array - returning 'nil'...");

        return nil;

    } // End of removeUniqueAttr().

    func postNotificationOfChanges() 
    {

        NotificationCenter.default.post(name: Notification.Name(rawValue: "SingleScanDataChanged"), object: ["newScanData": self]);

    } // End of func postNotificationOfChanges().

    override var objectSpecifier: NSScriptObjectSpecifier
    {

        let appDescription = NSApplication.shared.classDescription as! NSScriptClassDescription;
        let specifier      = NSUniqueIDSpecifier(containerClassDescription: appDescription, containerSpecifier: nil, key: "scans", uniqueID: self.id);

        return specifier;

    } // End of (override) var objectSpecifier.

    override func newScriptingObject(of objectClass: AnyClass, forValueForKey key: String, withContentsValue contentsValue: Any?, properties: [String: Any]) -> Any?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'objectClass' [\(objectClass)] - 'key' [\(key)] - 'contentsValue' [\(String(describing: contentsValue))] - 'properties' [\(properties)]...");

        let attr:Attr = super.newScriptingObject(of: objectClass, forValueForKey: key, withContentsValue: contentsValue, properties: properties) as! Attr;

        attr.scan = self;

        return attr;

    } // End of (override) func newScriptingObject().
    
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

    @objc func markAsCompleted(_ command: NSScriptCommand) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'command' [\(command)]...");

        if let scan          = command.evaluatedReceivers as? Scan,
           let completedFlag = command.evaluatedArguments?["completedFlag"] as? String 
        {

            if self == scan
            {

                // if completedFlag doesn't match either string, leave un-changed:

                if completedFlag == "complete"
                {

                    self.completed = true;

                } 
                else if completedFlag == "not complete"
                {

                    self.completed = false;

                }

            }

        }

    } // End of func markAsCompleted().
  
    @objc func submitAsIndicated(_ command: NSScriptCommand) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'command' [\(command)]...");

        if let scan         = command.evaluatedReceivers as? Scan,
           let fullScanFlag = command.evaluatedArguments?["fullScanFlag"] as? String 
        {

            if self == scan
            {

                // if fullScanFlag doesn't match either string, leave un-changed:

                if fullScanFlag == "full"
                {

                    self.fullScan = true;

                } 
                else if fullScanFlag == "incremental"
                {

                    self.fullScan = false;

                }

                let cxAppDelegate:AppDelegate = AppDelegate.ClassSingleton.cxAppDelegate!;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Calling the 'cxAppDelegate' [\(cxAppDelegate)]...");

                _ = cxAppDelegate.invokeScanSubmitViaAPICall(scan: self);

            }

        }

    } // End of func submitAsIndicated().

} // End of class Scan.

