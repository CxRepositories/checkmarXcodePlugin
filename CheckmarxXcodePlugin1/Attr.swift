//
//  Attr.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 12/29/18.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation

@objc(Attr) class Attr: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "Attr";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    @objc var  id:String;
    @objc var  name:String;
    @objc var  value:String;
    @objc weak var scan:Scan?;

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
        asToString.append("'name': [\(self.name)],");
        asToString.append("'value': [\(self.value)],");
        asToString.append("'scan': [\(String(describing: self.scan))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog)],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of (open) func toString().

    override init()
    {

    //  self.init(name:"", value:"");

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);
      
        self.id    = UUID().uuidString;
        self.name  = "";
        self.value = "";
        
        super.init();

    } // End of (override) init().

    convenience init(name:String)
    {

        self.init(name:name, value:"");

    } // End of (convenience) init().

    convenience init(name:String, value:String)
    {
        
        self.init();
        
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

    //  self.id    = UUID().uuidString;
        self.name  = name;
        self.value = value;

    } // End of (convenience) init().

    override var objectSpecifier: NSScriptObjectSpecifier 
    {

        guard let scan = scan else { return NSScriptObjectSpecifier() };

        guard let scanClassDescription = scan.classDescription as? NSScriptClassDescription else
            {

                return NSScriptObjectSpecifier();

            }

        let scanSpecifier = scan.objectSpecifier;

        let specifier = NSUniqueIDSpecifier(containerClassDescription: scanClassDescription, containerSpecifier: scanSpecifier, key: "tags", uniqueID: id);

        return specifier;

    } // End of (override) var objectSpecifier.
  
} // End of class Attr.

