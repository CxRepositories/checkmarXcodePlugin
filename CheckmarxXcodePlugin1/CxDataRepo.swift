//
//  CxDataRepo.swift
//  Swift_CommandLine_Library
//
//  Created by Daryl Cox on 2/17/2019.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation

// A 'singleton' class acting as a repository of Checkmarx endpoint data:

public class CxDataRepo: NSObject
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "CxDataRepo";
        static let sClsVers        = "v1.0401";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    } // End of struct ClassInfo.
    
    var dictJsonAPIRespByEndpoint:[String:[String:AnyObject]] = [:];
    var dictCxDataCache:[String:AnyObject]                    = [:];
    var dictCxDataEndpoints:[String:CxDataEndpoint]           = [:];
    var cxDataScans:CxDataScans!;
    var cxDataBinds:CxDataBinds!;

    let sCxDataEndpointsFilespec = "~/Checkmarx/CxDataEndpoints.plist";
    let sCxDataScansFilespec     = "~/Checkmarx/CxDataScans.plist";
    let sCxDataBindsFilespec     = "~/Checkmarx/CxDataBinds.plist";

    var cxActiveDataEndpoint:CxDataEndpoint? = nil;
    var restURLProcessor:RestURLProcessor?   = nil;
    var restURLResponse:RestURLResponse?     = nil;

    let jsTraceLog:JsTraceLog    = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                = ClassInfo.sClsDisp;

    class public var sharedCxDataRepo:CxDataRepo
    {
        
        struct Singleton
        {
            
            static let cxDataRepoInstance = CxDataRepo();
            
        }
        
        return Singleton.cxDataRepoInstance;
        
    } // End of class public var sharedCxDataRepo.
    
    override init()
    {
        
        super.init();
        
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.cxDataScans = CxDataScans();
        self.cxDataBinds = CxDataBinds();

        self.loadCxDataRepoFromPlists();
        self.loadCxDataToCache();
        self.loadInitialDataForActiveCxDataEndpoint();

    } // End of (override) init().
    
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
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)]");
        asToString.append("'sClsLogFilespec': [\(ClassInfo.sClsLogFilespec)]");
        asToString.append("],");
        asToString.append("'dictCxDataCache': [\(self.dictCxDataCache)],");
        asToString.append("'dictJsonAPIRespByEndpoint': [\(self.dictJsonAPIRespByEndpoint)],");
        asToString.append("'dictCxDataEndpoints': [\(self.dictCxDataEndpoints)],");
        asToString.append("'cxDataScans': [\(String(describing: self.cxDataScans))],");
        asToString.append("'cxDataBinds': [\(String(describing: self.cxDataBinds))],");
        asToString.append("'sCxDataEndpointsFilespec': [\(String(describing: self.sCxDataEndpointsFilespec))],");
        asToString.append("'sCxDataScansFilespec': [\(String(describing: self.sCxDataScansFilespec))],");
        asToString.append("'sCxDataBindsFilespec': [\(String(describing: self.sCxDataBindsFilespec))],");
        asToString.append("'cxActiveDataEndpoint': [\(String(describing: self.cxActiveDataEndpoint))],");
        asToString.append("'restURLProcessor': [\(String(describing: self.restURLProcessor))],");
        asToString.append("'restURLResponse': [\(String(describing: self.restURLResponse))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog)],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");
        
        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";
        
        return sContents;
        
    } // End of public func toString().

    public func storeCxDataToCacheInCxDataRepo(sCxDataCacheKey:String, cxDataToCache:AnyObject)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sCxDataCacheKey' [\(sCxDataCacheKey)]...");

        self.dictCxDataCache[sCxDataCacheKey] = cxDataToCache;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For the 'sCxDataCacheKey' of [\(sCxDataCacheKey)] stored a 'cxDataToCache' of [\(cxDataToCache)]...");

    } // End of func storeCxDataToCacheInCxDataRepo().
    
    public func retrieveCxDataToCacheFromCxDataRepo(sCxDataCacheKey:String) -> AnyObject?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sCxDataCacheKey' [\(sCxDataCacheKey)]...");

        let cxDataToCache:AnyObject? = self.dictCxDataCache[sCxDataCacheKey];

        if (cxDataToCache == nil)
        {

            return nil;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For the 'sCxDataCacheKey' of [\(sCxDataCacheKey)] returning a stored 'cxDataToCache'...");

        return cxDataToCache;

    } // End of func retrieveCxDataToCacheFromCxDataRepo().

    public func loadCxDataToCache()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let urlCxExtTxtFile = Bundle.main.url(forResource: "CxExt", withExtension: "txt");

        if (urlCxExtTxtFile == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Locating the 'resource' URL for the 'CxExt.txt' (in Bundle.Resources) failed - Warning!");

            return;

        }

        var dataCxExtTxt:Data? = nil;

        do 
        {

            dataCxExtTxt = try Data(contentsOf: urlCxExtTxtFile!);

        }
        catch
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Error reading the 'resource' CxExt.txt: \(error)...");

            return;

        }

        let sCxExtTxt:String        = NSString(data: dataCxExtTxt!, encoding:String.Encoding.utf8.rawValue)! as String;
        let sCxExtTxtRead:String    = (sCxExtTxt.stringByReplacingAllOccurrencesOfString(target: "\r", withString: ""));
        let asCxExtTxtRead:[String] = sCxExtTxtRead.components(separatedBy: "\n");
        var asCxExtTxt:[String]     = [];

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The converted Data response 'sCxExtTxtRead' is (\(sCxExtTxtRead.count)) byte(s) and 'asCxExtTxtRead' contains (\(asCxExtTxtRead.count)) lines...");

        for sCxExtTxtLine in asCxExtTxtRead
        {

            var sCxExtTxtLineTrimmed = sCxExtTxtLine.trimmingCharacters(in: .whitespaces);

            if (sCxExtTxtLineTrimmed.count < 1)
            {

                continue;

            }

            if (sCxExtTxtLineTrimmed.hasPrefix(".") == true ||
                sCxExtTxtLineTrimmed.hasPrefix("-") == true)
            {

                sCxExtTxtLineTrimmed = "*\(sCxExtTxtLineTrimmed)";

            }

            asCxExtTxt.append(sCxExtTxtLineTrimmed);

        }

        let sCxExtTxtToCache = asCxExtTxt.joined(separator: ";");

        self.storeCxDataToCacheInCxDataRepo(sCxDataCacheKey: "CxExt.txt", cxDataToCache: sCxExtTxtToCache as AnyObject);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Read (\(sCxExtTxt.count)) byte(s) from the file [\(String(describing: urlCxExtTxtFile))] and cached it as a string of (\(sCxExtTxtToCache.count)) byte(s)...");

    } // End of func loadCxDataToCache().
    
    public func storeJsonAPIResponseInCxDataRepo(sCxDataEndpointKey: String, sJsonAPIKey:String, jsonAPIResponse:AnyObject)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sCxDataEndpointKey' [\(sCxDataEndpointKey)] - 'sJsonAPIKey' [\(sJsonAPIKey)]...");

        var dictJsonAPIResp:[String:AnyObject]? = self.dictJsonAPIRespByEndpoint[sCxDataEndpointKey];
        
        if (dictJsonAPIResp == nil)
        {
            
            dictJsonAPIResp = [:];
            
        }
        
        dictJsonAPIResp![sJsonAPIKey] = jsonAPIResponse;

        self.dictJsonAPIRespByEndpoint[sCxDataEndpointKey] = dictJsonAPIResp!;

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For the 'sCxDataEndpointKey' of [\(sCxDataEndpointKey)] using a 'sJsonAPIKey' of [\(sJsonAPIKey)] stored a 'jsonAPIResponse' of [\(jsonAPIResponse)]...");

    } // End of func storeJsonAPIResponseInCxDataRepo().
    
    public func retrieveJsonAPIResponseFromCxDataRepo(sCxDataEndpointKey: String, sJsonAPIKey:String) -> AnyObject?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sCxDataEndpointKey' [\(sCxDataEndpointKey)] - 'sJsonAPIKey' [\(sJsonAPIKey)]...");

        let dictJsonAPIResp:[String:AnyObject]? = self.dictJsonAPIRespByEndpoint[sCxDataEndpointKey];
        
        if (dictJsonAPIResp == nil)
        {
            
            return nil;
            
        }
        
        let jsonAPIResponse:AnyObject? = dictJsonAPIResp![sJsonAPIKey];

        if (jsonAPIResponse == nil)
        {

            return nil;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"For the 'sCxDataEndpointKey' of [\(sCxDataEndpointKey)] using a 'sJsonAPIKey' of [\(sJsonAPIKey)] returning a stored 'jsonAPIResponse'...");

        return jsonAPIResponse;

    } // End of func retrieveJsonAPIResponseFromCxDataRepo().
    
    public func loadCxDataRepoFromPlists()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        self.loadCxDataBinds();
        self.loadCxDataEndpoints();
        self.loadCxDataScans();

    } // End of func loadCxDataRepoFromPlists().
    
    public func saveCxDataRepoToPlists()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Current 'CxDataRepo' is [\(self.toString())]...");

        self.saveCxDataScans();
        self.saveCxDataEndpoints();
        self.saveCxDataBinds();

    } // End of func saveCxDataRepoToPlists().

    public func loadCxDataEndpoints()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let sCxDataEndpointsPlist = JsFileIO.readFile(sFilespec: self.sCxDataEndpointsFilespec);

        if (sCxDataEndpointsPlist == nil)
        {

            return;

        }

        let aPlistSavedEndpoints = sCxDataEndpointsPlist?.propertyList() as! [[String:AnyObject]];
        
        if (aPlistSavedEndpoints.count > 1)
        {

            for entry in aPlistSavedEndpoints
            {

                if let cxDataEndpoint = CxDataEndpoint(plistEntry: entry)
                {

                    _ = self.registerCxDataEndpoint(cxDataEndpoint: cxDataEndpoint);

                }

            }

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Read the array of 'saved' Endpoint(s) with (\(self.dictCxDataEndpoints.count)) element(s) of [\(self.dictCxDataEndpoints)] from file [\(self.sCxDataEndpointsFilespec)]...");

    } // End of func loadCxDataEndpoints().
    
    public func loadCxDataScans()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let sCxDataScansPlist = JsFileIO.readFile(sFilespec: self.sCxDataScansFilespec);

        if (sCxDataScansPlist == nil)
        {

            return;

        }

        var aSavedScans:[Scan] = [];
        let aPlistSavedScans   = sCxDataScansPlist?.propertyList() as! [[String:AnyObject]];
        
        if (aPlistSavedScans.count > 1)
        {

            for entry in aPlistSavedScans
            {

                if let scan = Scan(plistEntry: entry)
                {

                    _ = scan.removeUniqueAttr(name: "CxScanSourceIsXcode");

                    aSavedScans.append(scan);

                }

            }

        }
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Read the array of 'saved' Scan(s) with (\(aSavedScans.count)) element(s) of [\(aSavedScans)] from file [\(self.sCxDataScansFilespec)]...");

        self.cxDataScans.scans = aSavedScans;

    } // End of func loadCxDataScans().
    
    public func loadCxDataBinds()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let sCxDataBindsPlist = JsFileIO.readFile(sFilespec: self.sCxDataBindsFilespec);

        if (sCxDataBindsPlist == nil)
        {

            return;

        }

        var aSavedBinds:[Bind] = [];
        let aPlistSavedBinds   = sCxDataBindsPlist?.propertyList() as! [[String:AnyObject]];
        
        if (aPlistSavedBinds.count > 1)
        {

            for entry in aPlistSavedBinds
            {

                if let bind = Bind(plistEntry: entry)
                {

                    aSavedBinds.append(bind);

                }

            }

        }
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Read the array of 'saved' Bind(s) with (\(aSavedBinds.count)) element(s) of [\(aSavedBinds)] from file [\(self.sCxDataBindsFilespec)]...");

        self.cxDataBinds.binds = aSavedBinds;

    } // End of func loadCxDataBinds().
    
    public func saveCxDataEndpoints()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.dictCxDataEndpoints.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The CxDataEndpoints dictionary is 'empty' - returning...");

            return;

        }

        let nsMACxDataEndpoints:NSMutableArray = [];

        for (_, dictEntry) in self.dictCxDataEndpoints.enumerated()
        {

            let cxDataEndpoint:CxDataEndpoint          = dictEntry.value;
            let nsMDCxDataEndpoint:NSMutableDictionary = [:];

            nsMDCxDataEndpoint["Name"]     = cxDataEndpoint.sCxEndpointName;
            nsMDCxDataEndpoint["Active"]   = (cxDataEndpoint.bCxEndpointActive == true) ? "true" : "false";
            nsMDCxDataEndpoint["Protocol"] = cxDataEndpoint.sHttpProtocol;    
            nsMDCxDataEndpoint["Host"]     = cxDataEndpoint.sHttpHost;        
            nsMDCxDataEndpoint["Port"]     = cxDataEndpoint.sHttpPort;        
            nsMDCxDataEndpoint["Username"] = cxDataEndpoint.sUsername;        
            nsMDCxDataEndpoint["Password"] = cxDataEndpoint.sPassword;        

            nsMACxDataEndpoints.add(nsMDCxDataEndpoint);
 
        }

        var sCurrFilespec = self.sCxDataEndpointsFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        let sCurrFilepath = (sCurrFilespec as NSString).deletingLastPathComponent;

        do
        {

            try FileManager.default.createDirectory(atPath: sCurrFilepath, withIntermediateDirectories: true, attributes: nil)

        }
        catch
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Failed to create the 'path' of [\(sCurrFilepath)] - Error: \(error)...");

        }

        nsMACxDataEndpoints.write(toFile: sCurrFilespec, atomically: false);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'saved' the array of Endpoint(s) with (\(nsMACxDataEndpoints.count)) element(s) of [\(nsMACxDataEndpoints)] to the file [\(self.sCxDataEndpointsFilespec)]...");

    } // End of func saveCxDataEndpoints().
    
    public func saveCxDataScans()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.cxDataScans!.scans!.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The CxDataScans 'scan(s)' array is 'empty' - returning...");

            return;

        }

        let nsMACxDataScans:NSMutableArray = [];

        for cxDataScan in self.cxDataScans!.scans!
        {

            let nsMDCxDataScan:NSMutableDictionary = [:];

            nsMDCxDataScan["Title"]     = cxDataScan.title;     
            nsMDCxDataScan["Due In"]    = "\(cxDataScan.daysUntilDue)"; 
            nsMDCxDataScan["Completed"] = (cxDataScan.completed == true) ? "true" : "false";    
            nsMDCxDataScan["FullScan"]  = (cxDataScan.fullScan  == true) ? "true" : "false";     

            if (cxDataScan.attrs.count < 1)
            {

                nsMDCxDataScan["Attrs"] = "";        

            }
            else
            {

                var aCxDataScanAttrs:[String] = [];

                for cxScanAttr in cxDataScan.attrs
                {

                    if (cxScanAttr.name == "CxScanSourceIsXcode")
                    {

                        continue;

                    }

                    aCxDataScanAttrs.append("\(cxScanAttr.name):\(cxScanAttr.value)");

                }

                nsMDCxDataScan["Attrs"] = aCxDataScanAttrs.joined(separator: ",");        

            }

            nsMACxDataScans.add(nsMDCxDataScan);

        }

        var sCurrFilespec = self.sCxDataScansFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        let sCurrFilepath = (sCurrFilespec as NSString).deletingLastPathComponent;

        do
        {

            try FileManager.default.createDirectory(atPath: sCurrFilepath, withIntermediateDirectories: true, attributes: nil)

        }
        catch
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Failed to create the 'path' of [\(sCurrFilepath)] - Error: \(error)...");

        }

        nsMACxDataScans.write(toFile: sCurrFilespec, atomically: false);

    //  self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'saved' Scan(s) array with (\(self.cxDataScans!.scans!.count)) element(s) of [\(self.cxDataScans!.scans!)] to the file [\(self.sCxDataScansFilespec)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'saved' Scan(s) array with (\(self.cxDataScans!.scans!.count)) element(s) of [\(nsMACxDataScans)] to the file [\(self.sCxDataScansFilespec)]...");

    } // End of func saveCxDataScans().
    
    public func saveCxDataBinds()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.cxDataBinds!.binds!.count < 1)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The CxDataBinds 'bind(s)' array is 'empty' - returning...");

            return;

        }

        let nsMACxDataBinds:NSMutableArray = [];

        for cxDataBind in self.cxDataBinds!.binds!
        {

            let nsMDCxDataBind:NSMutableDictionary = [:];

            nsMDCxDataBind["Key"]                  = cxDataBind.key;     
            nsMDCxDataBind["CxProjectId"]          = "\(cxDataBind.cxProjectId)"; 
            nsMDCxDataBind["CxProjectName"]        = cxDataBind.cxProjectName;
            nsMDCxDataBind["CxDataEndpointKey"]    = cxDataBind.cxEndpointKey;
            nsMDCxDataBind["CxBindGenerateReport"] = (cxDataBind.bCxBindGenerateReport == true) ? "true" : "false";
            nsMDCxDataBind["CxBindReportType"]     = cxDataBind.cxBindReportType;

            var sCxBindOrigin = cxDataBind.cxBindOrigin;

            if (sCxBindOrigin == "CxBindSourceIsXcode")
            {

                sCxBindOrigin = "Xcode";

            }

            nsMDCxDataBind["CxBindOrigin"]                 = sCxBindOrigin;
            nsMDCxDataBind["CxLastSASTScanReportFilespec"] = cxDataBind.cxLastSASTScanReportFilespec;

            nsMACxDataBinds.add(nsMDCxDataBind);

        }

        var sCurrFilespec = self.sCxDataBindsFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        let sCurrFilepath = (sCurrFilespec as NSString).deletingLastPathComponent;

        do
        {

            try FileManager.default.createDirectory(atPath: sCurrFilepath, withIntermediateDirectories: true, attributes: nil)

        }
        catch
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Failed to create the 'path' of [\(sCurrFilepath)] - Error: \(error)...");

        }

        nsMACxDataBinds.write(toFile: sCurrFilespec, atomically: false);

    //  self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'saved' bind(s) array with (\(self.cxDataBinds!.binds!.count)) element(s) of [\(self.cxDataBinds!.binds!)] to the file [\(self.sCxDataBindsFilespec)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'saved' bind(s) array with (\(self.cxDataBinds!.binds!.count)) element(s) of [\(nsMACxDataBinds)] to the file [\(self.sCxDataBindsFilespec)]...");

    } // End of func saveCxDataBinds().
    
    public func registerCxDataEndpoint(name:String, active:Bool, httpProtocol:String, httpHost:String, httpPort:String?, user:String, password:String)->CxDataEndpoint
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'name' [\(name)] - 'httpProtocol' [\(httpProtocol)] - 'httpHost' [\(httpHost)] - 'httpPort' [\(String(describing: httpPort))] - 'user' [\(user)] - 'password' [\(password)]...");

        let cxDataEndpoint:CxDataEndpoint = CxDataEndpoint(name:name, active:active, httpProtocol:httpProtocol, httpHost:httpHost, httpPort:httpPort, user:user, password:password);
        
        return registerCxDataEndpoint(cxDataEndpoint: cxDataEndpoint);
            
    } // End of public func registerCxDataEndpoint().
    
    public func registerCxDataEndpoint(cxDataEndpoint:CxDataEndpoint) -> CxDataEndpoint
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'cxDataEndpoint' [\(cxDataEndpoint)]...");

        self.dictCxDataEndpoints[cxDataEndpoint.sCxEndpointName!] = cxDataEndpoint;

        return cxDataEndpoint;
            
    } // End of public func registerCxDataEndpoint().
    
    public func deregisterCxDataEndpointClass(name:String)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'name' [\(name)]...");

        if (self.dictCxDataEndpoints[name] != nil)
        {
            
            self.dictCxDataEndpoints.removeValue(forKey: name);
            
        }
        
    } // End of public func deregisterCxDataEndpointClass().
    
    public func retrieveActiveCxDataEndpoint() -> CxDataEndpoint?
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.dictCxDataEndpoints.count > 0)
        {

            for (i, dictEntry) in self.dictCxDataEndpoints.enumerated()
            {
                
                let cxDataEndpoint:CxDataEndpoint = dictEntry.value;

                if (cxDataEndpoint.bCxEndpointActive == true)
                {

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Element #(\(i)) is 'active' CxDataEndpoint named [\(String(describing: cxDataEndpoint.sCxEndpointName))]...");

                    return cxDataEndpoint;

                }

            }

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"NO 'active' CxDataEndpoint was found - returning 'nil'...");

        return nil;

    } // End of func retrieveActiveCxDataEndpoint();

    public func resetAllCxDataEndpointsToInactive(sActiveEndpointKey:String?) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (self.dictCxDataEndpoints.count > 0)
        {

            for (i, dictEntry) in self.dictCxDataEndpoints.enumerated()
            {
                
                let cxDataEndpoint:CxDataEndpoint = dictEntry.value;

                cxDataEndpoint.bCxEndpointActive  = false;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Element #(\(i)) a CxDataEndpoint named [\(String(describing: cxDataEndpoint.sCxEndpointName!))] has been marked 'inactive'...");

            }

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"ALL CxDataEndpoint(s) were marked as 'Inactive'...");

        if (sActiveEndpointKey != nil &&
            sActiveEndpointKey!.count > 0)
        {
            
            let cxDataEndpoint:CxDataEndpoint? = self.dictCxDataEndpoints[sActiveEndpointKey!];

            if (cxDataEndpoint != nil)
            {

                cxDataEndpoint!.bCxEndpointActive = true;

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"CxDataEndpoint named [\(String(describing: cxDataEndpoint!.sCxEndpointName!))] was marked as 'Active'...");

            }

        }

        return true;

    } // End of func resetAllCxDataEndpointsToInactive();

    public func loadInitialDataForActiveCxDataEndpoint()
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        var cxActiveDataEndpoint:CxDataEndpoint? = self.retrieveActiveCxDataEndpoint();

        if (cxActiveDataEndpoint != nil)
        {

            if (cxActiveDataEndpoint!.sCxEndpointName        == nil ||
                cxActiveDataEndpoint!.sCxEndpointName!.count < 1)
            {

                cxActiveDataEndpoint = nil;

            }

        }

        if (cxActiveDataEndpoint == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'initial' Data load for the 'active' CxDataEndpoint failed - there is NO 'active' CxDataEndpoint to load for - Warning!");

            return;

        }

        let dispatchGroup = DispatchGroup();

        do
        {
            
            dispatchGroup.enter();
  
            let dispatchQueue = DispatchQueue(label: "InitialDataLoadBackgroundThread", qos: .userInitiated);

            dispatchQueue.async
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoking 'performInitialLoadProcessing()'...");

                let bLoadProcessedOk = self.performInitialLoadProcessing(cxDataEndpoint: cxActiveDataEndpoint!);

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Return from 'performInitialLoadProcessing()' - 'bLoadProcessedOk' is [\(bLoadProcessedOk)]...");

                dispatchGroup.notify(queue: DispatchQueue.main, execute:
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppDelegateDisplay();

                });

            }

            dispatchGroup.leave();
            
        }
        
        return;

    } // End of func loadInitialDataForActiveCxDataEndpoint();

    public func performInitialLoadProcessing(cxDataEndpoint:CxDataEndpoint) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        self.cxActiveDataEndpoint = cxDataEndpoint;

        if (self.restURLProcessor == nil)
        {

            self.restURLProcessor = RestURLProcessor();

        }

        if (self.restURLProcessor?.restURLData == nil)
        {

            self.restURLProcessor?.restURLData = RestURLData();

            self.restURLProcessor?.restURLData?.cxDataEndpoint = self.cxActiveDataEndpoint;

        }

        return self.performInitialLoadProcessingViaRestAPI();

    } // End of func loadInitialDataForActiveCxDataEndpoint();

    private func traceLastCxAPIOutput(adJsonAPIRespResult:[NSDictionary]? = nil, sJsonAPIName:String = "") -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sJsonAPIName' [\(sJsonAPIName)]...");

        var sCxDataEndpointKey = "Unknown";

        if (self.cxActiveDataEndpoint != nil)
        {

            sCxDataEndpointKey = self.cxActiveDataEndpoint!.sCxEndpointName!;

        }

        if (adJsonAPIRespResult != nil &&
            adJsonAPIRespResult!.count > 0)
        {

            CxDataRepo.sharedCxDataRepo.storeJsonAPIResponseInCxDataRepo(sCxDataEndpointKey: sCxDataEndpointKey, sJsonAPIKey: sJsonAPIName, jsonAPIResponse: adJsonAPIRespResult as AnyObject);

        }

        return true;
       
    } // End of func traceLastCxAPIOutput().

    func performInitialLoadProcessingViaRestAPI() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'active' Endpoint [\(String(describing: self.cxActiveDataEndpoint))]...");

        if (self.cxActiveDataEndpoint!.sURLAccessToken.count < 1)
        {

            let bCxAPILoginOk = self.issueCxAPITokenAuth();

            if (bCxAPILoginOk == false)
            {

                let sLoadProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'active' Endpoint named [\(String(describing: self.cxActiveDataEndpoint!.sCxEndpointName))] 'login' Request failed - Error:");

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sLoadProcessorStatusMsg);

                self.cxActiveDataEndpoint = nil;

                DispatchQueue.main.async
                {

                    _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sLoadProcessorStatusMsg);

                }   

                return false;

            }

        }

        let bCxAPIProjectDetailsOk = self.issueCxAPIGetAllProjectDetails();
      
        if (bCxAPIProjectDetailsOk == false)
        {
      
            let sLoadProcessorStatusMsg = self.restURLResponse!.toDisplayString(sRestURLStatusMsg: " - - - - - - - - - -\nThe CxAPI Sast 'active' Endpoint named [\(String(describing: self.cxActiveDataEndpoint!.sCxEndpointName))] 'get' ALL Project Detail(s) Request failed - Error:");

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sLoadProcessorStatusMsg);

            DispatchQueue.main.async
            {

                _ = AppDelegate.ClassSingleton.cxAppDelegate!.updateAppStatusView(sAppStatusView: sLoadProcessorStatusMsg);

            }   

            return false;
      
        }
      
        return true;
       
    } // End of func performInitialLoadProcessingViaRestAPI().

    func issueCxAPITokenAuth() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = 
        [
            "Content-Type":  "application/x-www-form-urlencoded",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
        ];

        let sUsername = self.cxActiveDataEndpoint!.sUsername ?? "";
        let sPassword = self.cxActiveDataEndpoint!.sPassword ?? "";

        let postJsonData = NSMutableData(data: "username=\(sUsername)".data(using: String.Encoding.utf8)!);

        postJsonData.append("&password=\(sPassword)".data(using: String.Encoding.utf8)!);
        postJsonData.append("&grant_type=password".data(using: String.Encoding.utf8)!);
        postJsonData.append("&scope=sast_rest_api".data(using: String.Encoding.utf8)!);
        postJsonData.append("&client_id=resource_owner_client".data(using: String.Encoding.utf8)!);
        postJsonData.append("&client_secret=014DF517-39D1-4453-B7B3-9930C563627C".data(using: String.Encoding.utf8)!);

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/auth/identity/connect/token";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "POST";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;
        postJsonRequest.httpBody            = postJsonData as Data;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200, 500];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: true);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "AuthIdentityToken");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

        //  self.sRestURLAccessToken = "";
            self.cxActiveDataEndpoint = nil;

            return false;

        }

        if (self.restURLProcessor!.adJsonResult.count > 0)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'deserialized' JSON result array 'adJsonResult' contains (\(self.restURLProcessor!.adJsonResult.count)) lines...");

            for (i, dictJsonResult) in self.restURLProcessor!.adJsonResult.enumerated()
            {

                var j = 0;

                for (dictJsonKey, dictJsonValue) in dictJsonResult
                {

                    j += 1;

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"JSON result #(\(i + 1):\(j)): Key [\(dictJsonKey)], Value [\(dictJsonValue)]...");

                    if (dictJsonKey as! String == "access_token")
                    {
                  
                        self.cxActiveDataEndpoint!.sURLAccessToken = dictJsonValue as! String;
                  
                    }

                }

            }

        }

        return true;
       
    } // End of func issueCxAPITokenAuth().

    func issueCxAPIGetAllProjectDetails() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        let asJsonHeaders = 
        [
            "Content-Type":  "application/json;v1.0 / 2.0",
            "Authorization": "Bearer \(self.cxActiveDataEndpoint!.sURLAccessToken)",
            "cxOrigin":      "CheckmarxXcodePlugin1",
            "cache-control": "no-cache"
        ];

        self.restURLProcessor!.restURLData!.sHttpURI    = "cxrestapi/projects";
        self.restURLProcessor!.restURLData!.sHttpParams = "";

        _ = self.restURLProcessor!.restURLData!.generateHttpURL();

        let postJsonRequest = NSMutableURLRequest(url:       NSURL(string: self.restURLProcessor!.restURLData!.sHttpGeneratedURL)! as URL,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                            timeoutInterval: 30.0);

        postJsonRequest.httpMethod          = "GET";
        postJsonRequest.allHTTPHeaderFields = asJsonHeaders;

        self.restURLProcessor!.jsonRequest               = postJsonRequest;
        self.restURLProcessor!.aiJsonResponseStatusCodes = [200];

        self.restURLResponse = self.restURLProcessor!.handleURLRequestWithJsonResponse(reset: false);

        defer
        {

            _ = self.traceLastCxAPIOutput(adJsonAPIRespResult: self.restURLProcessor!.adJsonResult, sJsonAPIName: "GetAllProjectDetails");

        }

        if (self.restURLResponse!.bRestURLQueryOk == false)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The JSON Request 'postJsonRequest' [\(postJsonRequest)] failed - 'restURLResponse' was [\(self.restURLResponse!)] - Error!");

            return false;

        }
        
        if (self.restURLProcessor!.adJsonResult.count > 0)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'deserialized' JSON result array 'adJsonResult' contains (\(self.restURLProcessor!.adJsonResult.count)) lines...");

        }

        return true;
       
    } // End of func issueCxAPIGetAllProjectDetails().

} // End of public class CxDataRepo.

