//
//  CxDataScans.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 12/29/18.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation

class CxDataScans: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "CxDataScans";
        static let sClsVers        = "v1.0401";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    var scans:[Scan]!;

    let jsTraceLog:JsTraceLog = JsTraceLog.sharedJsTraceLog;
    let sTraceCls             = ClassInfo.sClsDisp;

    public func toString()->String
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
        asToString.append("'scans': [\(String(describing: self.scans))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog)],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of (public) func toString().

    override init()
    {
        
        super.init();

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.scans = [];

        postNotificationOfChanges();

    } // End of init().

    func postNotificationOfChanges() 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)]...");

        NotificationCenter.default.post(name: Notification.Name(rawValue: "CxDataScansChanged"), object: ["newCxDataScans": scans]);

    } // End of func postNotificationOfChanges().

    func insertScan(scan: Scan, at index: Int) -> [Scan] 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'scan' [\(scan)] - 'title' [\(scan.title)] - 'index' [\(index)]...");

        if self.scanExists(withTitle: scan.title)
        {

            let command = NSScriptCommand.current();

            command?.scriptErrorNumber = errOSACantAssign;
            command?.scriptErrorString = "Scan with the title '\(scan.title)' already exists";

        } 
        else
        {

            if index >= self.scans.count
            {

                self.scans.append(scan);

            }
            else
            {

                self.scans.insert(scan, at: index);

            }

            postNotificationOfChanges();

        }

        return self.scans;

    } // End of func insertScan().

    func deleteScan(at index: Int) -> [Scan]
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'index' [\(index)]...");

        if index < self.scans.count
        {

            self.scans.remove(at: index);

        }

        postNotificationOfChanges();

        return self.scans;

    } // End of func deleteScan().

    func scanExists(withTitle title: String) -> Bool 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'title' [\(title)]...");

        let titles      = self.scans.map {$0.title};
        let bScanExists = titles.contains(title);

        return bScanExists;

    } // End of func scanExists().

} // End of class CxDataScans.

