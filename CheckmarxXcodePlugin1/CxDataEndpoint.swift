//
//  CxDataEndpoint.swift
//  Swift_CommandLine_Library
//
//  Created by Daryl Cox on 2/17/2019.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation

// A 'singleton' class acting as a repository of Checkmarx endpoint data:

public class CxDataEndpoint: NSObject
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "CxDataEndpoint";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    } // End of struct ClassInfo.

    // Cx Endpoint 'name' (Dictionary KEY):
    
    var sCxEndpointName:String? = nil;

    // Cx Endpoint is 'currently active'?

    var bCxEndpointActive:Bool  = false;

    // Cx Endpoint URL:

    var sHttpProtocol:String?   = nil;
    var sHttpHost:String?       = nil;
    var sHttpPort:String?       = nil;

    // Cx Endpoint (default) Credentials (UserID/Pswd):

    var sUsername:String?       = nil;
    var sPassword:String?       = nil;

    // Cx Endpoint operational field(s):

    var sURLAccessToken:String  = "";
    
    let jsTraceLog:JsTraceLog   = JsTraceLog.sharedJsTraceLog;
    let sTraceCls               = ClassInfo.sClsDisp;

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
        asToString.append("'sCxEndpointName': [\(String(describing: self.sCxEndpointName))],");
        asToString.append("'bCxEndpointActive': [\(String(describing: self.bCxEndpointActive))],");
        asToString.append("'sHttpProtocol': [\(String(describing: self.sHttpProtocol))],");
        asToString.append("'sHttpHost': [\(String(describing: self.sHttpHost))],");
        asToString.append("'sHttpPort': [\(String(describing: self.sHttpPort))],");
        asToString.append("'sUsername': [\(String(describing: self.sUsername))],");
        asToString.append("'sPassword': [\(String(describing: self.sPassword))],");
        asToString.append("'sURLAccessToken': [\(String(describing: self.sURLAccessToken))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog)],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");
        
        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";
        
        return sContents;
        
    } // End of public func toString().
    
    override init()
    {
        
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        super.init();
        
    } // End of (override) init().
    
    convenience init(name:String, active: Bool, httpProtocol:String, httpHost:String, httpPort:String?, user:String, password:String)
    {
        
        self.init();
        
        self.sCxEndpointName   = name;
        self.bCxEndpointActive = active;
        self.sHttpProtocol     = httpProtocol;
        self.sHttpHost         = httpHost;
        self.sHttpPort         = httpPort;
        self.sUsername         = user;
        self.sPassword         = password;

    } // End of (convenience) init().

    convenience init(cxDataEndpoint:CxDataEndpoint)
    {
        
        self.init();
        
        self.sCxEndpointName   = cxDataEndpoint.sCxEndpointName;  
        self.bCxEndpointActive = cxDataEndpoint.bCxEndpointActive;
        self.sHttpProtocol     = cxDataEndpoint.sHttpProtocol;    
        self.sHttpHost         = cxDataEndpoint.sHttpHost;        
        self.sHttpPort         = cxDataEndpoint.sHttpPort;        
        self.sUsername         = cxDataEndpoint.sUsername;        
        self.sPassword         = cxDataEndpoint.sPassword;        

    } // End of (convenience) init().

    init?(plistEntry: [String: AnyObject])
    {

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        guard let name = plistEntry["Name"] as? String else { return nil };

        self.sCxEndpointName   = name;
        let cxEndpointActive   = plistEntry["Active"]   as? String ?? "false";
        self.bCxEndpointActive = (cxEndpointActive == "true");
        self.sHttpProtocol     = plistEntry["Protocol"] as? String ?? "";
        self.sHttpHost         = plistEntry["Host"]     as? String ?? "";
        self.sHttpPort         = plistEntry["Port"]     as? String ?? "";
        self.sUsername         = plistEntry["Username"] as? String ?? "";
        self.sPassword         = plistEntry["Password"] as? String ?? "";

        super.init();

    } // End of init?().

    class public func splitHttpURLToComponentParts(sHttpURL:String)->(httpProtocol:String, httpHost:String, httpPort:String?)
    {
        
        var sHttpProtocol     = "http";
        var sHttpHost         = "localhost";
        var sHttpPort:String? = nil;

        if (sHttpURL.count > 0)
        {

            var sWorkHttpURL:String = sHttpURL;
            var asHttpURL:[String]? = sWorkHttpURL.leftPartitionStrings(target: "://")!;
            
            if (asHttpURL != nil)
            {
                
                sHttpProtocol = asHttpURL![0];
                sWorkHttpURL  = asHttpURL![2];
                
            }
            
             if (sWorkHttpURL.count > 0)
            {
                
                asHttpURL = sWorkHttpURL.leftPartitionStrings(target: ":")!;
                
                if (asHttpURL != nil)
                {
                    
                    sHttpHost = asHttpURL![0];
                    sHttpPort = asHttpURL![2];
                    
                }
                else
                {
                    
                    sHttpHost = sWorkHttpURL;
                    
                }
                
            }
            
        }

        return (sHttpProtocol, sHttpHost, sHttpPort);
        
    } // End of class public func splitHttpURLToComponentParts().
    
    class public func joinHttpURLFromComponentParts(httpProtocol:String?, httpHost:String?, httpPort:String?)->String?
    {
        
        var sHttpURL:String? = nil;
        var sHttpProtocol    = "http";
        var sHttpHost        = "localhost";
 
        if (httpProtocol!.count > 0)
        {
            
            sHttpProtocol = httpProtocol!;
            
        }
        if (httpHost!.count > 0)
        {
            
            sHttpHost = httpHost!;
            
        }
        
        let sHttpURLPrefix = "\(sHttpProtocol)://\(sHttpHost)";
        
        if (httpPort        != nil &&
            httpPort!.count > 0)
        {
            
            sHttpURL = "\(sHttpURLPrefix):\(httpPort!)";
            
        }
        else
        {
            
            sHttpURL = sHttpURLPrefix;
            
        }
        
        return sHttpURL;
        
    } // End of class public func joinHttpURLFromComponentParts().
    
} // End of public class CxDataEndpoint.
