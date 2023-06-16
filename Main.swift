import Cocoa;
import AppKit;
import ChangeColor;

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength);
    let changeColor = ChangeColor();

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let button = statusItem.button {
            button.title = "App";
            button.action = #selector(showMenu(_:));
        }
    }
    
    @objc func showMenu(_ sender: Any?) {
        guard let button = statusItem.button else {
            return;
        }
        
        let menu = NSMenu();
        menu.addItem(NSMenuItem(title: "Change Color", action: #selector(changeColor.showWindow()), keyEquivalent: ""));
        menu.addItem(NSMenuItem.separator());
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"));
        
        menu.popUp(
            positioning: nil, 
            at: NSPoint(
                x: button.window?.frame.origin.x ?? 0, 
                y: button.window?.frame.origin.y ?? 0),
            in: button
        );
    }
    
    @objc func doAction1(_ sender: Any?) {
        print("Performing Action 1");
    }
    
    @objc func doAction2(_ sender: Any?) {
        print("Performing Action 2");
    }
}

let app = NSApplication.shared;
let delegate = AppDelegate();

app.delegate = delegate;
app.run();
