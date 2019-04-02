//
//  RestURLResponse.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 03/02/19.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation

class RestURLResponse: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "RestURLResponse";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    var bRestURLQueryOk                        = false;
    var sRestURLRequest                        = "";
    var iRestURLResponseStatus                 = 0;
    var sRestURLResponseError                  = "";
    var sRestURLResponseData                   = "";
    var adRestURLResponseResult:[NSDictionary] = Array();
    var nsRestURLResponseData:NSData?          = nil;

    let jsTraceLog:JsTraceLog                  = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                              = ClassInfo.sClsDisp;

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
        asToString.append("'bRestURLQueryOk': [\(self.bRestURLQueryOk))],");
        asToString.append("'sRestURLRequest': [\(self.sRestURLRequest))],");
        asToString.append("'iRestURLResponseStatus': [\(self.iRestURLResponseStatus))],");
        asToString.append("'sRestURLResponseError': [\(String(describing: self.sRestURLResponseError))],");
        asToString.append("'sRestURLResponseData': [\(String(describing: self.sRestURLResponseData))],");
        asToString.append("'adRestURLResponseResult': [\(String(describing: self.adRestURLResponseResult))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog.toString())],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of (public) func toString().

    public func toDisplayString(sRestURLStatusMsg:String?)->String
    {

        var asToString:[String] = Array();

        if (sRestURLStatusMsg != nil)
        {

            asToString.append(sRestURLStatusMsg!);

        }

        asToString.append("'bRestURLQueryOk': [\(self.bRestURLQueryOk))],");
        asToString.append("'sRestURLRequest': [\(self.sRestURLRequest))],");
        asToString.append("'iRestURLResponseStatus': [\(self.iRestURLResponseStatus))],");
        asToString.append("'sRestURLResponseError': [\(String(describing: self.sRestURLResponseError))],");
        asToString.append("'sRestURLResponseData': [\(String(describing: self.sRestURLResponseData))],");
        asToString.append("'adRestURLResponseResult': contains (\(self.adRestURLResponseResult.count)) element(s)");

        let sContents:String = asToString.joined(separator: "\n");

        return sContents;

    } // End of (public) func toDisplayString().

    override init()
    {
        
        super.init();

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

    } // End of init().

    convenience init(bHandleURLRequestOk:Bool, sURLRequest:String, iURLResponseStatus:Int, sURLResponseMsg:String, sURLResponseData:String? = nil, adJsonAPIRespResult:[NSDictionary]? = nil, nsURLResponseData:NSData? = nil)
    {

        self.init();
        
        self.bRestURLQueryOk         = bHandleURLRequestOk;
        self.sRestURLRequest         = sURLRequest;
        self.iRestURLResponseStatus  = iURLResponseStatus;
        self.sRestURLResponseError   = sURLResponseMsg;
        self.sRestURLResponseData    = "";
        self.nsRestURLResponseData   = nil;

        if (sURLResponseData != nil)
        {

            self.sRestURLResponseData = sURLResponseData!;

        }
        
        if (adJsonAPIRespResult != nil)
        {
            
            self.adRestURLResponseResult = adJsonAPIRespResult!;
            
        }

        if (nsURLResponseData != nil)
        {

            self.nsRestURLResponseData = nsURLResponseData;

        }
        
    } // End of init().

} // End of class RestURLResponse.

