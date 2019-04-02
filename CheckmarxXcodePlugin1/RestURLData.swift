//
//  RestURLData.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 01/20/19.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation

class RestURLData: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "RestURLData";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    var cxDataEndpoint:CxDataEndpoint?  = nil;
    var sHttpURI:String                 = "";
    var sHttpParams:String              = "";

    var sHttpGeneratedURL:String        = "";

    var sLastJsonAPIRequestURL          = "";
    var bLastJsonAPIQueryOk             = false;
    var iLastJsonAPIResponseStatus      = 0;
    var sLastJsonAPIResponseError       = "";

    var svJsonAPIResponseStack:[String] = Array();

    let jsTraceLog:JsTraceLog           = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                       = ClassInfo.sClsDisp;

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
        asToString.append("'cxDataEndpoint': [\(String(describing: self.cxDataEndpoint!.toString()))],");
        asToString.append("'sHttpURI': [\(String(describing: self.sHttpURI))],");
        asToString.append("'sHttpParams': [\(String(describing: self.sHttpParams))],");
        asToString.append("'sHttpGeneratedURL': [\(String(describing: self.sHttpGeneratedURL))],");
        asToString.append("'sLastJsonAPIRequestURL': [\(self.sLastJsonAPIRequestURL))],");
        asToString.append("'bLastJsonAPIQueryOk': [\(self.bLastJsonAPIQueryOk))],");
        asToString.append("'iLastJsonAPIResponseStatus': [\(self.iLastJsonAPIResponseStatus))],");
        asToString.append("'sLastJsonAPIResponseError': [\(String(describing: self.sLastJsonAPIResponseError))],");
        asToString.append("'svJsonAPIResponseStack': [\(String(describing: svJsonAPIResponseStack))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog.toString())],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of (public) func toString().

    override init()
    {
        
        super.init();

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

    } // End of init().

    func generateHttpURL() -> (bGenerateHttpURLOk:Bool, sGeneratedHttpURL:String)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'cxDataEndpoint' [\(self.cxDataEndpoint!.toString())] - 'sHttpURI' [\(self.sHttpURI)] - 'sHttpParams' [\(self.sHttpParams)]...");

        var sHttpURLPrefix = "\(self.cxDataEndpoint!.sHttpProtocol!)://\(self.cxDataEndpoint!.sHttpHost!)";

        if self.cxDataEndpoint!.sHttpPort!.count > 0
        {

            sHttpURLPrefix = "\(sHttpURLPrefix):\(self.cxDataEndpoint!.sHttpPort!)";

        }

        sHttpURLPrefix = "\(sHttpURLPrefix)/";

        if (self.sHttpURI.count > 0)
        {

            sHttpURLPrefix = "\(sHttpURLPrefix)\(self.sHttpURI)";

        }

        if (self.sHttpParams.count > 0)
        {

            sHttpURLPrefix = "\(sHttpURLPrefix)?\(self.sHttpParams)";

        }

        self.sHttpGeneratedURL = sHttpURLPrefix;

        return (true, self.sHttpGeneratedURL);

    } // End of func generateHttpURL().

    func addJsonAPIResponse(bJsonAPIQueryOk:Bool = false, jsonAPIReqURL:URLRequest? = nil, iJsonAPIRespStatus:Int = 0, sJsonAPIRespError:String = "", adJsonAPIRespResult:[NSDictionary]? = nil) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        var cdJsonAPIRespResults = 0;

        if (adJsonAPIRespResult != nil)
        {

            cdJsonAPIRespResults = adJsonAPIRespResult!.count;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'bJsonAPIQueryOk' [\(bJsonAPIQueryOk)] - 'jsonAPIReqURL' [\(String(describing: jsonAPIReqURL))] - 'iJsonAPIRespStatus' [\(iJsonAPIRespStatus)] - 'sJsonAPIRespError' [\(String(describing: sJsonAPIRespError))] - 'adJsonAPIRespResult' (\(cdJsonAPIRespResults)) element(s)...");

        self.sLastJsonAPIRequestURL = "-N/A";

        if (jsonAPIReqURL != nil)
        {

            self.sLastJsonAPIRequestURL = "\(jsonAPIReqURL!.httpMethod!):\(String(describing: jsonAPIReqURL!))";
 
        }

        self.bLastJsonAPIQueryOk        = bJsonAPIQueryOk;
        self.iLastJsonAPIResponseStatus = iJsonAPIRespStatus;
        self.sLastJsonAPIResponseError  = sJsonAPIRespError;

        var asLastJsonAPIRespResult:[String] = Array();

        asLastJsonAPIRespResult.append(" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ");
        asLastJsonAPIRespResult.append("The 'last' Json API 'sLastJsonAPIRequestURL' is [\(self.sLastJsonAPIRequestURL)]...");
        asLastJsonAPIRespResult.append("The 'last' Json API 'bLastJsonAPIQueryOk' is [\(self.bLastJsonAPIQueryOk)]...");
        asLastJsonAPIRespResult.append("The 'last' Json API 'iLastJsonAPIResponseStatus' is [\(self.iLastJsonAPIResponseStatus)]...");
        asLastJsonAPIRespResult.append("The 'last' Json API 'sLastJsonAPIResponseError' is [\(self.sLastJsonAPIResponseError)]...");

        if (adJsonAPIRespResult != nil &&
            adJsonAPIRespResult!.count > 0)
        {

            asLastJsonAPIRespResult.append("The 'last' Json API response data contains (\(adJsonAPIRespResult!.count)) lines:");

            for (i, dictJsonResult) in adJsonAPIRespResult!.enumerated()
            {
                
                var j = 0;

                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {

                    j += 1;
                    
                    asLastJsonAPIRespResult.append("JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");

                }
                
            }

        }

        self.svJsonAPIResponseStack.append(asLastJsonAPIRespResult.joined(separator: "\n"));

        return true;

    } // End of func addJsonAPIResponse().

    func clearJsonAPIResponses() -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'svJsonAPIResponseStack' contains (\(self.svJsonAPIResponseStack.count)) element(s)...");

        self.svJsonAPIResponseStack = Array();

        return true;

    } // End of func clearJsonAPIResponses().

    func renderJsonAPIResponsesToString() -> String
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'svJsonAPIResponseStack' contains (\(self.svJsonAPIResponseStack.count)) element(s)...");

        return (self.svJsonAPIResponseStack.joined(separator: "\n"));

    } // End of func renderJsonAPIResponsesToString().

} // End of class RestURLData.

