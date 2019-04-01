//
//  AppDelegate.swift
//  CheckmarxXcodePlugin1
//
//  Created by Daryl Cox on 12/13/18.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Cocoa

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate
{

    struct ClassInfo
    {
        
        static let sClsId          = "AppDelegate";
        static let sClsVers        = "v1.0401";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    struct ClassSingleton
    {

        static var cxAppDelegate:AppDelegate? = nil;

    }

    @IBOutlet weak var appWindow:NSWindow!;
    
    @objc var scans:[Scan]!;
    @objc var binds:[Bind]!;

    let sApplicationName             = "CheckmarxXcodePlugin1";
    var cTestApi                     = 0;

    var cxDataRepo:CxDataRepo        = CxDataRepo.sharedCxDataRepo;
    var scanValidator:ScanValidator? = nil;

    let jsTraceLog:JsTraceLog        = JsTraceLog.sharedJsTraceLog;
    let sTraceCls                    = ClassInfo.sClsDisp;

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
        asToString.append("'appWindow': [\(String(describing: self.appWindow))],");
        asToString.append("'scans': [\(String(describing: self.scans))],");
        asToString.append("'binds': [\(String(describing: self.binds))],");
        asToString.append("'sApplicationName': [\(self.sApplicationName)],");
        asToString.append("'cTestApi': [\(self.cTestApi)],");
        asToString.append("'cxDataRepo': [\(self.cxDataRepo))],");
        asToString.append("'scanValidator': [\(String(describing: self.scanValidator))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog.toString())],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of public func toString().
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        ClassSingleton.cxAppDelegate = self;
        
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

    //  appWindow.setIsVisible(false);

        self.jsTraceLog.jsTraceLogSayStart(sTraceCls: sTraceCls);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'aNotification' is [\(aNotification)] - 'sApplicationName' is [\(self.sApplicationName)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' (Main) Window is [\(String(describing: appWindow))]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"");

        _ = self.dumpAppInfoPlistToLog();

        self.scans = self.cxDataRepo.cxDataScans!.scans;
        self.binds = self.cxDataRepo.cxDataBinds!.binds;

        self.updateAppDelegateDisplay();
        
    } // End of func applicationDidFinishLaunching().

    func applicationWillTerminate(_ aNotification: Notification) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'aNotification' is [\(aNotification)]...");

        self.cxDataRepo.saveCxDataRepoToPlists();

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"");
        self.jsTraceLog.jsTraceLogSayStop(sTraceCls: sTraceCls);

        ClassSingleton.cxAppDelegate = nil;

    } // End of func applicationWillTerminate().

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = 
    {

        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */

        let container = NSPersistentContainer(name: "CheckmarxXcodePlugin1");

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error 
            {

                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                fatalError("Unresolved error \(error)");

            }

        });

        return container;

    }(); // End of closure NSPersistentContainer.persistentContainer.

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(String(describing: sender))]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"");

        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.

        let context = persistentContainer.viewContext;

        if !context.commitEditing() 
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Unable to commit editing before saving - [\((NSStringFromClass(type(of: self))))]...");

        }

        if context.hasChanges 
        {

            do 
            {

                try context.save();

            } 
            catch 
            {

                // Customize this code block to include application-specific recovery steps.

                let nserror = error as NSError;

                NSApplication.shared.presentError(nserror);

            }

        }

    } // End of func saveAction().

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'window' is [\(window)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"");

        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.

        return persistentContainer.viewContext.undoManager;

    } // End of func windowWillReturnUndoManager().

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sender' is [\(sender)]...");
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"");

        // Save changes in the application's managed object context before the application terminates.

        let context = persistentContainer.viewContext;
        
        if !context.commitEditing() 
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Unable to commit editing to terminate - [\((NSStringFromClass(type(of: self))))] - Terminating anyway...");

        //  return .terminateCancel;
            return .terminateNow;

        }
        
        if !context.hasChanges 
        {

            return .terminateNow;

        }
        
        do 
        {

            try context.save()

        } 
        catch 
        {

            let nserror = error as NSError;

            // Customize this code block to include application-specific recovery steps.

            let result = sender.presentError(nserror);

            if (result) 
            {

                return .terminateCancel;

            }
            
            let question     = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message");
            let info         = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton   = NSLocalizedString("Quit anyway", comment: "Quit anyway button title");
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title");
            let alert        = NSAlert();

            alert.messageText     = question;
            alert.informativeText = info;

            alert.addButton(withTitle: quitButton);
            alert.addButton(withTitle: cancelButton);
            
            let answer = alert.runModal();

            if answer == .alertSecondButtonReturn 
            {

                return .terminateCancel;

            }

        }

        // If we got here, it is time to quit.

        return .terminateNow;

    } // End of func applicationShouldTerminate().

    open func dumpAppInfoPlistToLog() -> Bool
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
        
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        var infoFileURL = Bundle.main.url(forResource: "Info", withExtension: "plist");

        if (infoFileURL == nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Locating the 'resource' URL for the 'Info.plist' (in Bundle.Resources) failed - Warning!");

            let sampleFileURL = Bundle.main.url(forResource: "ScansSample", withExtension: "plist");

            if (sampleFileURL != nil)
            {

                let sSampleFilespec      = sampleFileURL?.absoluteString;
                let sSampleFilePath      = (sSampleFilespec! as NSString).deletingLastPathComponent;
                let sContentsFilePath    = (sSampleFilePath as NSString).deletingLastPathComponent;
                let sContentsFilePathURL = "file://\(sContentsFilePath)/Info.plist";

            //  infoFileURL = URL(string: "file:///Users/dcox/Library/Developer/Xcode/DerivedData/CheckmarxXcodePlugin1-dtbullqpburzjgbeoneljwdwmwez/Build/Products/Debug/CheckmarxXcodePlugin1.app/Contents/Info.plist");
                infoFileURL = URL(string: sContentsFilePathURL);

                if (infoFileURL == nil)
                {

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Locating the 'resource' URL for the 'Info.plist' (in the level above Bundle.Resources as [\(sContentsFilePathURL)]) failed - Warning!");

                    return false;

                }

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Locating the 'resource' URL for the 'Info.plist' (in the level above Bundle.Resources as [\(sContentsFilePathURL)]) was successful...");

            }
            else
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Locating the 'resource' URL for the 'ScansSample.plist' (in Bundle.Resources) failed - Warning!");

                return false;

            }

        }

        var formatinfoplist                  = PropertyListSerialization.PropertyListFormat.xml;
        var dictInfoPlist:[String:AnyObject] = [:];

        do 
        {

            let pListInfo = try Data(contentsOf: infoFileURL!);
          
            dictInfoPlist = try PropertyListSerialization.propertyList(from:    pListInfo,
                                                                       options: PropertyListSerialization.ReadOptions.mutableContainersAndLeaves,
                                                                       format:  &formatinfoplist) as! [String:AnyObject];

        }
        catch
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Error reading plist: \(error), format: \(formatinfoplist)...");

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Read the dictionary 'dictInfoPlist' with (\(dictInfoPlist.count)) element(s) of [\(dictInfoPlist)] from file [\(String(describing: infoFileURL))]...");

        return true;

    } // End of func dumpAppInfoPlistToLog().

    open func invokeScanSubmitViaAPICall(scan: Scan) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'scan' is [\(scan)]...");

        cTestApi += 1;

        let currScan = scan;

        return self.processScanSubmit(scan: currScan);

    } // End of func invokeScanSubmitViaAPICall().

    open func invokeBindOrUnbindViaAPICall(bind: Bind, bCallIsForReportView:Bool) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'bind' is [\(bind)] - 'bCallIsForView' [\(bCallIsForReportView)]...");

        cTestApi += 1;

        var currBind = bind;

        // If the 'current' Bind does NOT have a WorkSpace Document or Directory, try to find one:

        if (currBind.key.count < 1)
        {

            let bDetermineBindXcodeWSDocFileOk = self.cxDataRepo.cxDataBinds!.determineBindXcodeWSDocFile(bind: currBind);

            if (bDetermineBindXcodeWSDocFileOk == true)
            {

                if (self.cxDataRepo.cxDataBinds!.sBindXcodeWSDocFilespec       != nil &&
                    self.cxDataRepo.cxDataBinds!.sBindXcodeWSDocFilespec!.count > 0)
                {

                    currBind.key = self.cxDataRepo.cxDataBinds!.sBindXcodeWSDocFilespec!;

                }
                else
                {

                    let sCurrentBindStatusMsg = " - - - - - - - - - -\nERROR: NO 'Bind' key is available (from either Xcode or AppleScript)!";

                    self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sCurrentBindStatusMsg);

                    self.updateAppStatusView(sAppStatusView: sCurrentBindStatusMsg);
                    self.updateAppDelegateDisplay();

                //  _ = self.cxDataRepo.cxDataBinds!.deleteBind(bind: currBind);
                    _ = self.removeObjectFromBinds(bind: currBind);


                    self.cxDataRepo.cxDataBinds!.currentActiveBind = nil;

                    return false;

                }

            }

        }

        // Given that we have a WS Doc file/directory, determine if we have an 'active' Endpoint:

        var cxActiveDataEndpoint = self.cxDataRepo.retrieveActiveCxDataEndpoint();

        if (cxActiveDataEndpoint != nil)
        {

            if (cxActiveDataEndpoint!.sCxEndpointName        != nil &&
                cxActiveDataEndpoint!.sCxEndpointName!.count > 0)
            {

                currBind.cxEndpointKey = cxActiveDataEndpoint!.sCxEndpointName!;

            }
            else
            {

                cxActiveDataEndpoint = nil;

            }

        }

        if (cxActiveDataEndpoint == nil)
        {

            let sCurrentBindStatusMsg = " - - - - - - - - - -\nERROR: NO CxDataEndpoint is 'active' - the CxAPI cannot be used - use the 'Preferences' to select an 'active' CxDataEndpoint!";

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:sCurrentBindStatusMsg);

            self.updateAppStatusView(sAppStatusView: sCurrentBindStatusMsg);
            self.updateAppDelegateDisplay();

            _ = self.removeObjectFromBinds(bind: currBind);

            self.cxDataRepo.cxDataBinds!.currentActiveBind = nil;

            return false;

        }

        // We look in the 'Binds' array to see if this 'key'/'Endpoint' pair exists, if it does (and it's NOT the same as this Bind), 
        // then delete this Bind and reuse the one that's already in the array:

        let cxActiveDataBind:Bind? = CxDataRepo.sharedCxDataRepo.cxDataBinds!.findBindForCxDataEndpoint(key: currBind.key, cxEndpointKey: currBind.cxEndpointKey);

        if (cxActiveDataBind != nil)
        {

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"An 'active' Bind for 'key' [\(currBind.key)] and 'endpoint' [\(currBind.cxEndpointKey)] already exists - switching to it...");

            if (currBind.id != cxActiveDataBind!.id)
            {

                // If the current 'Bind' origin is 'Xcode', then override the 'active' before the swap:

                if (currBind.cxBindOrigin == "CxBindSourceIsXcode")
                {

                    cxActiveDataBind!.cxBindOrigin = currBind.cxBindOrigin;

                }

                _ = self.removeObjectFromBinds(bind: currBind);

            }

            currBind = cxActiveDataBind!;

        }

        // Determine if the 'Bind' origin is 'Xcode':

        var bBindOriginIsXcode:Bool = false;

        if (currBind.cxBindOrigin == "CxBindSourceIsXcode")
        {

            bBindOriginIsXcode = true;

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'bBindOriginIsXcode' [\(bBindOriginIsXcode)]...");

        // If this 'Bind' was for a 'Report' View (only), then handle it:

        if (bCallIsForReportView == true)
        {

            if (bBindOriginIsXcode == true)
            {

                if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
                {

                    MainViewController.ClassSingleton.cxAppMainViewController!.sMainViewLastReportFilespec = currBind.cxLastSASTScanReportFilespec;

                    MainViewController.ClassSingleton.cxAppMainViewController!.handleMainViewLastReport();

                }

            }

            self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' Bind 'currBind' [\(currBind.toString())] was a transport for a 'Report' view but was NOT 'Xcode' - returning...");

            return true;

        }

        // If the 'Bind' origin is NOT 'Xcode', then we check to see if there's enough information in the 'Bind' to run a 'Scan',
        // if not then we display the 'Bind-Report' screen (if it came from 'Xcode' then we always display the screen (because they might want to 'unbind')):

        if (bBindOriginIsXcode == false)
        {

            if (currBind.cxProjectName.count > 0 &&
                currBind.cxProjectId         >= 0)
            {

                self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"The 'current' Bind 'currBind' [\(currBind.toString())] already has the Project Name/Id - returning...");

                return true;

            }

        }

        // Display the 'Bind-Report' screen:

        self.cxDataRepo.cxDataBinds!.currentActiveBind = currBind;

        var nsVCBindReportView:BindReportViewController? = BindReportViewController.ClassSingleton.cxAppBindReportViewController;

        if (nsVCBindReportView == nil)
        {

            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main);
            let nsWCWindow = storyboard.instantiateController(withIdentifier: "BindReportViewWindow") as! NSWindowController;

            nsVCBindReportView = storyboard.instantiateController(withIdentifier: "BindReportViewController") as? BindReportViewController;
            
            nsWCWindow.contentViewController = nsVCBindReportView;
            
            nsWCWindow.showWindow(self);

        }

        self.updateAppDelegateDisplay();

        return true;

    } // End of func invokeBindOrUnbindViaAPICall().

    func processScanSubmit(scan:Scan) -> Bool
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'scan' is [\(scan)]...");

        let currScan = scan;

        if (self.scanValidator == nil)
        {

            self.scanValidator = ScanValidator();

        }

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoking 'ScanValidator.performScanValidation()' - 'currScan' is [\(currScan)]...");

        let bScanValidatedOk = self.scanValidator!.performScanValidation(scan: currScan);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Return from 'ScanValidator.performScanValidation()' - 'bScanValidatedOk' is [\(bScanValidatedOk)]...");

        self.updateAppStatusView(sAppStatusView: " - - - - - - - - - -\nScan is 'processing' on a background thread - 'bScanValidatedOk' is [\(bScanValidatedOk)]...");
        self.updateAppDelegateDisplay();
        
        return bScanValidatedOk;

    } // End of func processScanSubmit().

    func updateAppDelegateDisplay()
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
        {

            MainViewController.ClassSingleton.cxAppMainViewController!.updateMainViewDisplay();

        }

        if (LogHistoryViewController.ClassSingleton.cxLogHistoryViewController != nil)
        {

            LogHistoryViewController.ClassSingleton.cxLogHistoryViewController!.updateLogHistoryDisplay();

        }
       
    } // End of func updateAppDelegateDisplay().

    func updateAppStatusView(sAppStatusView: String)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'sAppStatusView' [\(sAppStatusView)]...");

        if (MainViewController.ClassSingleton.cxAppMainViewController != nil)
        {

            MainViewController.ClassSingleton.cxAppMainViewController!.updateMainStatusView(sMainStatusView: sAppStatusView);

        }

    } // End of func updateMainStatusView().

} // End of class AppDelegate.

extension AppDelegate
{
    
//  <<< pre-Swift-4.2 >>> override func application(_ sender: NSApplication, delegateHandlesKey key: String) -> Bool
    func application(_ sender: NSApplication, delegateHandlesKey key: String) -> Bool
    {
  
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'sender' [\(sender)] - 'key' [\(key)]...");

        if (key == "scans" ||
            key == "binds")
        {

            return true;

        }

        return false;
  
    } // End of (override) func application().
    
    @objc func insertObject(_ object:Scan, inScansAtIndex index:Int)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'object' [\(object)] - 'index' [\(index)]...");

        self.scans = self.cxDataRepo.cxDataScans!.insertScan(scan: object, at: index);

    } // End of func insertObject().

    @objc func insertObject(_ object:Attr, inAttrsAtIndex index:Int)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'object' [\(object)] - 'index' [\(index)]...");

        return;

    } // End of func insertObject().

    @objc func insertObject(_ object:Bind, inBindsAtIndex index:Int)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'object' [\(object)] - 'index' [\(index)]...");

        self.binds = self.cxDataRepo.cxDataBinds!.insertBind(bind: object, at: index);

    } // End of func insertObject().

    @objc func removeObjectFromScansAtIndex(_ index:Int)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'index' [\(index)]...");

        self.scans = self.cxDataRepo.cxDataScans!.deleteScan(at: index);

    } // End of func removeObjectFromScansAtIndex().

    @objc func removeObjectFromBindsAtIndex(_ index:Int)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'index' [\(index)]...");

        self.binds = self.cxDataRepo.cxDataBinds!.deleteBind(at: index);

    } // End of func removeObjectFromBindsAtIndex().

    @objc func removeObjectFromBinds(bind:Bind)
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked - 'self' is [\(self)] - 'bind' [\(bind)]...");

        self.binds = self.cxDataRepo.cxDataBinds!.deleteBind(bind: bind);

    } // End of func removeObjectFromBinds().

} // End of extension AppDelegate.

