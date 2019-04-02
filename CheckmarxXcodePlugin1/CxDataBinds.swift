//
//  CxDataBinds.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 03/10/19.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation

class CxDataBinds: NSObject
{

    struct ClassInfo
    {
        
        static let sClsId          = "CxDataBinds";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    var binds:[Bind]!;

    var cxAppleScriptProcessor:CxAppleScriptProcessor = CxAppleScriptProcessor();
    var sBindXcodeWSDocFilespec:String?               = nil;
    var currentActiveBind:Bind?                       = nil;
    var currentScanOnHold:Scan?                       = nil;

    let jsTraceLog:JsTraceLog                         = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                                     = ClassInfo.sClsDisp;

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
        asToString.append("'binds': [\(String(describing: self.binds))],");
        asToString.append("'cxAppleScriptProcessor': [\(String(describing: self.cxAppleScriptProcessor))],");
        asToString.append("'sBindXcodeWSDocFilespec': [\(String(describing: self.sBindXcodeWSDocFilespec))],");
        asToString.append("'currentActiveBind': [\(String(describing: self.currentActiveBind))],");
        asToString.append("'currentScanOnHold': [\(String(describing: self.currentScanOnHold))],");
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

        self.binds = [];

    //  binds = createSampleData();
    
        postNotificationOfChanges();

    } // End of init().

    func postNotificationOfChanges() 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)]...");

        NotificationCenter.default.post(name: Notification.Name(rawValue: "CxDataBindsChanged"), object: ["newCxDataBinds": binds]);

    } // End of func postNotificationOfChanges().

    func insertBind(bind: Bind, at index: Int) -> [Bind] 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'bind' [\(bind)] - 'key' [\(bind.key)] - 'index' [\(index)]...");

        if self.bindExists(key: bind.key)
        {

            let command = NSScriptCommand.current();

            command?.scriptErrorNumber = errOSACantAssign;
            command?.scriptErrorString = "Bind with the key '\(bind.key)' already exists";

        } 
        else
        {

            if index >= self.binds.count
            {

                self.binds.append(bind);

            }
            else
            {

                self.binds.insert(bind, at: index);

            }

            postNotificationOfChanges();

        }

        return self.binds;

    } // End of func insertBind().

    func deleteBind(at index: Int) -> [Bind]
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'index' [\(index)]...");

        if index < self.binds.count
        {

            self.binds.remove(at: index);

        }

        postNotificationOfChanges();

        return self.binds;

    } // End of func deleteBind().

    func deleteBind(bind:Bind) -> [Bind]
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'bind' [\(bind)]...");

        for (index, cxDataBind) in self.binds.enumerated()
        {

            if (bind.id == cxDataBind.id)     
            {

                self.binds.remove(at: index);

            }

        }

        postNotificationOfChanges();

        return self.binds;

    } // End of func deleteBind().

    func bindExists(key: String) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'key' [\(key)]...");

        if (self.binds.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'bind(s)' array is 'empty' - returning 'false'...");

            return false;

        }

        for cxDataBind in self.binds
        {

            if (key == cxDataBind.key)     
            {

                return true;

            }

        }

        return false;

    } // End of func bindExists().

    func findBind(key: String) -> Bind?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'key' [\(key)]...");

        if (self.binds.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'bind(s)' array is 'empty' - returning 'nil'...");

            return nil;

        }

        for cxDataBind in self.binds
        {

            if (key == cxDataBind.key)     
            {

                return cxDataBind;

            }

        }

        return nil;

    } // End of func findBind().

    func findBindForCxDataEndpoint(key: String, cxEndpointKey: String) -> Bind?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'key' [\(key)] - 'cxEndpointKey' [\(cxEndpointKey)]...");

        if (self.binds.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'bind(s)' array is 'empty' - returning 'nil'...");

            return nil;

        }

        for cxDataBind in self.binds
        {

            if (key           == cxDataBind.key &&     
                cxEndpointKey == cxDataBind.cxEndpointKey)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'bind' of 'key' [\(key)] - 'cxEndpointKey' [\(cxEndpointKey)] matched - returning 'cxDataBind' [\(cxDataBind)]...");

                return cxDataBind;

            }

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'bind' of 'key' [\(key)] - 'cxEndpointKey' [\(cxEndpointKey)] FAILED to match - returning 'nil'...");

        return nil;

    } // End of func findBind().

    func determineBindXcodeWSDocFile(bind:Bind) -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        var sBindXcodeWSDocFilespec:String? = nil;
        var bBindOriginIsXcode:Bool         = false;

        if (bind.cxBindOrigin == "CxBindSourceIsXcode")
        {

            bBindOriginIsXcode = true;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bBindOriginIsXcode' [\(bBindOriginIsXcode)]...");

        if (bBindOriginIsXcode == true)
        {

            let (bDetermineCurrentXcodeWSDocFileOk, sCurrentXcodeWSDocFilespec) = self.cxAppleScriptProcessor.determineCurrentXcodeWSDocFile();

            if (bDetermineCurrentXcodeWSDocFileOk == false ||
                sCurrentXcodeWSDocFilespec        == nil   ||
                sCurrentXcodeWSDocFilespec!.count < 1)
            {

                sBindXcodeWSDocFilespec = nil;

            }
            else
            {

                sBindXcodeWSDocFilespec = sCurrentXcodeWSDocFilespec;

            }

        }

        if (sBindXcodeWSDocFilespec == nil)
        {

            self.sBindXcodeWSDocFilespec = "";

        }
        else
        {

            self.sBindXcodeWSDocFilespec = sBindXcodeWSDocFilespec!;

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Bind's 'sBindXcodeWSDocFilespec' [\(String(describing: self.sBindXcodeWSDocFilespec))]...");

        }

        // Note: All we care about here, is if we already know a filespec, then does it exist.

        if (self.sBindXcodeWSDocFilespec!.count > 1)
        {

            if (JsFileIO.fileExists(sFilespec: self.sBindXcodeWSDocFilespec!) == false)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Bind's 'sBindXcodeWSDocFilespec' [\(String(describing: self.sBindXcodeWSDocFilespec))] does NOT exist - setting the field to \"\"...");

                self.sBindXcodeWSDocFilespec = "";

            }
            else
            {

                return true;

            }

        }

        return false;
       
    } // End of func determineBindXcodeWSDocFile().

} // End of class CxDataBinds.

