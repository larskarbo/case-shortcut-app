//
//  AppDelegate.swift
//  caseshortcut
//
//  Created by Lars Karbø on 26/02/2021.
//

import Cocoa
import SwiftUI

import HotKey


private func copyToClipBoard(textToCopy: String) {
    let pasteBoard = NSPasteboard.general
    pasteBoard.clearContents()
    pasteBoard.setString(textToCopy, forType: .string)
}

private func getContents() -> String {
    NSPasteboard.general.clearContents()
    copy()
    print("Pressed at \(Date())")
    usleep(50 * 1000)
    let pasteboard = NSPasteboard.general
    
    let contents = pasteboard.string(forType: NSPasteboard.PasteboardType.string)
    
    if(contents != nil){
        return (contents ?? "") as String
        
    } else {
        return ""
    }
}

private func pasteReplace(str: String){
    
    let length = str.count
    copyToClipBoard(textToCopy: str)
    paste()
    usleep(200 * 1000)
    markBackwards(length: length)
}

private func markBackwards(length: Int){
    let arrowLeftKeyDown = CGEvent(keyboardEventSource: nil, virtualKey: 0x7B, keyDown: true)
    let arrowLeftKeyUp = CGEvent(keyboardEventSource: nil, virtualKey: 0x7B, keyDown: false)
    
    for _ in 0..<length {
        arrowLeftKeyDown?.flags = CGEventFlags.maskShift
        arrowLeftKeyDown?.post(tap:CGEventTapLocation.cghidEventTap)
        
        arrowLeftKeyUp?.post(tap:CGEventTapLocation.cghidEventTap)
        usleep(6 * 1000)
    }
}

private func transformer(step: Int, str: String) -> String {
    if(step == 0){
        return str.uppercased()
    } else if(step == 1){
        return str.capitalized
    } else if(step == 2){
        return str.localizedTitleCasedString
    } else if(step == 3){
        return str.lowercased()
    }
    return ""
}

private func copy() {
    let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x08, keyDown: true); // cmd-v down
    event1?.flags = CGEventFlags.maskCommand;
    event1?.post(tap: CGEventTapLocation.cghidEventTap);
    
    let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x08, keyDown: false) // cmd-v up
    
    event2?.post(tap: CGEventTapLocation.cghidEventTap)
}

private func paste() {
    let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: true); // cmd-v down
    event1?.flags = CGEventFlags.maskCommand;
    event1?.post(tap: CGEventTapLocation.cghidEventTap);
    
    let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: false) // cmd-v up
    
    event2?.post(tap: CGEventTapLocation.cghidEventTap)
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    var statusBarItem: NSStatusItem!
    
    var hotKeyUp: HotKey = HotKey(key: .upArrow, modifiers: [.option, .command, .control])
    var hotKeyDown: HotKey = HotKey(key: .downArrow, modifiers: [.option, .command, .control])
    @State var step: Int = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "🌯"
        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu
        
//        statusBarMenu.addItem(
//            withTitle: "Order a burrito",
//            action: #selector(AppDelegate.orderABurrito),
//            keyEquivalent: "")
//
        statusBarMenu.addItem(
            withTitle: "Quit Case Shortcut",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "")
        
        self.hotKeyUp.keyDownHandler = {
            if(self.step > 0){
                self.step = self.step - 1
            }
            let str = getContents()
            pasteReplace(str: transformer(step: self.step, str: str))
        }
        
        self.hotKeyDown.keyDownHandler = {
            if(self.step < 3){
                self.step = self.step + 1
            }
            let str = getContents()
            pasteReplace(str: transformer(step: self.step, str: str))
        }
        
    }
    
    @objc func orderABurrito() {
        print("Ordering a burrito!")
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

