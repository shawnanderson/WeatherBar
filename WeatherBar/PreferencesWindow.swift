//
//  PreferencesWindow.swift
//  WeatherBar
//
//  Created by Brad Greenlee on 10/13/15.
//  Copyright © 2015 Etsy. All rights reserved.
//
//  Updated to Swift 5 compatiblity by Shawn Anderson on 8/18/2019
//
//  AppIcon made by Freepik from www.flaticon.com

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {
    var delegate: PreferencesWindowDelegate?
    @IBOutlet weak var zipTextField: NSTextField!

    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        let defaults = UserDefaults.standard
        let zip = defaults.string(forKey: "zip") ?? DEFAULT_ZIP
        zipTextField.stringValue = zip
    }
    
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(zipTextField.stringValue, forKey: "zip")
        delegate?.preferencesDidUpdate()
    }
}
