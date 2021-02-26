//
//  ContentView.swift
//  case-shortcut
//
//  Created by Lars Karbø on 23/02/2021.
//

import SwiftUI
import HotKey

private func copyToClipBoard(textToCopy: String) {
    let pasteBoard = NSPasteboard.general
    pasteBoard.clearContents()
    pasteBoard.setString(textToCopy, forType: .string)

}

private func setupHotkey(){

    
    print("horse")
    
}


private func copy() {
    let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x08, keyDown: true); // cmd-v down
        event1?.flags = CGEventFlags.maskCommand;
        event1?.post(tap: CGEventTapLocation.cghidEventTap);

        let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x08, keyDown: false) // cmd-v up
    //    event2?.flags = CGEventFlags.maskCommand
        event2?.post(tap: CGEventTapLocation.cghidEventTap)
}

private func paste() {
    let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: true); // cmd-v down
        event1?.flags = CGEventFlags.maskCommand;
        event1?.post(tap: CGEventTapLocation.cghidEventTap);

        let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: false) // cmd-v up
    //    event2?.flags = CGEventFlags.maskCommand
        event2?.post(tap: CGEventTapLocation.cghidEventTap)
}

struct ContentView: View {
    var hotKeyUp: HotKey = HotKey(key: .upArrow, modifiers: [.option, .command, .control])
    var hotKeyDown: HotKey = HotKey(key: .downArrow, modifiers: [.option, .command, .control])
    
    var body: some View {
        VStack {
            Text("Hello, horse!")
                .padding()
            Text("Hello, grommt!")
                .padding()
            Button("horse", action: {
                print("horse")
                
                //self.hotKey =
                
                self.hotKeyUp.keyDownHandler = {
                    copy()
                    print("Pressed at \(Date())")
                    
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
//                    pasteboard.setString("Good Morning", forType: NSPasteboard.PasteboardType.string)

                    var clipboardItems: [String] = []
                    for element in pasteboard.pasteboardItems! {
                        if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                            clipboardItems.append(str)
                        }
                    }

                    // Access the item in the clipboard
                    if(clipboardItems.count > 0){
                        
                        let firstClipboardItem = clipboardItems[0] // Good Morning
                        print(firstClipboardItem)
                        
                        copyToClipBoard(textToCopy: firstClipboardItem.uppercased())
                        
                        paste()
                    } else {
                        print("fuck")
                    }
                }
                
                self.hotKeyDown.keyDownHandler = {
                    copy()
                    print("Pressed at \(Date())")
                    
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
//                    pasteboard.setString("Good Morning", forType: NSPasteboard.PasteboardType.string)

                    var clipboardItems: [String] = []
                    for element in pasteboard.pasteboardItems! {
                        if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                            clipboardItems.append(str)
                        }
                    }

                    // Access the item in the clipboard
                    if(clipboardItems.count > 0){
                        
                        let firstClipboardItem = clipboardItems[0] // Good Morning
                        print(firstClipboardItem)
                        
                        copyToClipBoard(textToCopy: firstClipboardItem.lowercased())
                        
                        paste()
                    } else {
                        print("fuck")
                    }
                }
                setupHotkey()

                //copyToClipBoard(textToCopy:"horses")
            })
            .frame(width: 100.0)
            //TextField("Placeholder!!", text: binding)
        }
        .frame(maxWidth: 500)
        .padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}


import Cocoa

class PreferencesWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
//        if let vc = self.contentViewController as? PreferencesViewController {
//            if vc.listening {
//                vc.updateGlobalShortcut(event)
//            }
//        }
    }
}
