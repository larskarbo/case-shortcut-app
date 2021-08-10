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
    usleep(100 * 1000)
    let pasteboard = NSPasteboard.general
    
    let contents = pasteboard.string(forType: NSPasteboard.PasteboardType.string)
    
    if(contents != nil){
        return (contents ?? "") as String
        
    } else {
        return ""
    }
}

private func pasteReplace(str: String){
    print("pasting " + str)
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
//
//private func transformer(step: Int, str: String) -> String {
//    PRINT(STEP)
//    if(step == 0){
//        return str.uppercased()
//    } else if(step == 1){
//        return str.localizedTitleCasedString
//    } else if(step == 2){
//        return str.lowercased()
//    }
//    return ""
//}

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




//func upper() {
//    let str = getContents()
//    pasteReplace(str: str.uppercased())
//}


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
        statusBarItem.button?.image = NSImage(named:"logo.pdf")
        let statusBarMenu = NSMenu(title: "Case Shortcut Bar Menu")
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(
            withTitle: "UPPERCASE",
            action: #selector(upper),
            keyEquivalent: "")

        statusBarMenu.addItem(
            withTitle: "Title case",
            action: #selector(title),
            keyEquivalent: "")

        statusBarMenu.addItem(
            withTitle: "lowercase",
            action: #selector(lower),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "--------",
            action: #selector(nothing),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "camelCase",
            action: #selector(camel),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "hyphen-case",
            action: #selector(hyphen),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "dot.case",
            action: #selector(dot),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "--------",
            action: #selector(nothing),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "LAUNCH🚀CASE🚀",
            action: #selector(launch),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "CLAP👏CASE👏",
            action: #selector(clap),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "--------",
            action: #selector(nothing),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "Feedback",
            action: #selector(feedback),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "Quit Case Shortcut",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "")

        
        self.hotKeyUp.keyDownHandler = {
            self.upper()
        }
        
        self.hotKeyDown.keyDownHandler = {
            self.lower()
        }
        
        let url = URL(string: "https://caseshortcut.com/welcomescreen")!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
        
        
        
    }
    
    @objc func nothing() {
        
    }
    
    @objc func upper() {
        let str = getContents()
        pasteReplace(str: str.uppercased())
    }
    
    @objc func title() {
        let str = getContents()
        pasteReplace(str: str.localizedTitleCasedString)
    }
    
    @objc func lower() {
        let str = getContents()
        pasteReplace(str: str.lowercased())
    }
    
    @objc func camel() {
        let str = getContents()
        pasteReplace(str: str.camelized)
    }
    @objc func hyphen() {
        let str = getContents()
        pasteReplace(str: str.hyphenized)
    }
    @objc func dot() {
        let str = getContents()
        pasteReplace(str: str.dotized)
    }
    
    @objc func clap() {
        let str = getContents()
        pasteReplace(str: str.uppercased().replacingOccurrences(of: " ", with: "👋") + "👋")
    }
    
    @objc func launch() {
        let str = getContents()
        pasteReplace(str: str.uppercased().replacingOccurrences(of: " ", with: " 🚀 ") + " 🚀")
    }
    
    @objc func feedback() {
        
        let url = URL(string: "https://twitter.com/larskarbo")!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")

        }
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

