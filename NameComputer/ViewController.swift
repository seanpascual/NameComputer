//
//  ViewController.swift
//  NameComputer
//
//  Created by Sean Pascual on 14/12/2017.
//  Copyright © 2017 Beamly Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var assetTag: NSTextField!
    @IBOutlet weak var department: NSPopUpButton!
    @IBOutlet weak var username: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // Closes the Current Window
    func closeWindow() {
        self.view.window?.close()
    }
    
    // Checks the characters entered into textfields
    override func controlTextDidChange(_ obj: Notification) {
        
        let numberSet: CharacterSet = CharacterSet(charactersIn: "0123456789").inverted
        let alphaCharSet: CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.").inverted
        
        self.assetTag.stringValue = (self.assetTag.stringValue.components(separatedBy: numberSet) as NSArray).componentsJoined(by: "")
        self.username.stringValue = (self.username.stringValue.components(separatedBy: alphaCharSet) as NSArray).componentsJoined(by: "")
    }
    
    // Message that the computer setup is complete
    func completeAlert() {
        
        let alert = NSAlert()
        alert.messageText = "Setup Complete"
        alert.informativeText = "Setup is now complete!"
        alert.addButton(withTitle: "Ok")
        
        alert.beginSheetModal(for: self.view.window!, completionHandler: { (returnCode) -> Void in
            if returnCode == NSApplication.ModalResponse.alertFirstButtonReturn {
            }
        })
    }
    
    func Start() {
        let assetTagValue = self.assetTag.stringValue
        let usernameValue = self.username.stringValue
        let departmentValue = self.department.title
        // _ = departmentValue
        
        // let path = "/bin/bash"
        // let path = "/usr/bin/say"
        // let arguments = ["/Users/Shared/test.sh"]
        // let arguments = ["recon", "-assetTag", "\(assetTagValue)", "-endUsername", "\(fullNameValue)", "-department", "\(departmentValue)"]
        // let arguments = ["recon"]
        
        NSAppleScript(source: "do shell script \"/usr/local/jamf/bin/jamf recon -assetTag \(assetTagValue) -endUsername \(usernameValue) -department \(departmentValue)\" with administrator " + "privileges")!.executeAndReturnError(nil)

        let compPath = "/usr/sbin/scutil"
        let compArguments = ["--set", "ComputerName", "Beamly-\(assetTagValue)"]
        let compTask = Process.launchedProcess(launchPath: compPath, arguments: compArguments)
        compTask.waitUntilExit()
        
        let hostPath = "/usr/sbin/scutil"
        let hostArguments = ["--set", "HostName", "Beamly-\(assetTagValue)"]
        let hostTask = Process.launchedProcess(launchPath: hostPath, arguments: hostArguments)
        hostTask.waitUntilExit()
        
        let localHostPath = "/usr/sbin/scutil"
        let localHostArguments = ["--set", "HostName", "Beamly-\(assetTagValue)"]
        let localHostTask = Process.launchedProcess(launchPath: localHostPath, arguments: localHostArguments)
        localHostTask.waitUntilExit()
    }
    
    @IBAction func finishButton(_ sender: NSButton) {
        // let path = "/usr/bin/say"
        // let arguments = ["hello world"]
        
        // let task = Process.launchedProcess(launchPath: path, arguments: arguments)
        // task.waitUntilExit()
        Start()
        completeAlert()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.closeWindow()
        })
    }
}

