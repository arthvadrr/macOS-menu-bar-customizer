import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let changeColor = ChangeColor(windowNibName: NSNib.Name("ChangeColor"))

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let button = statusItem.button {

            let image = NSImage(named: "Assets/Images/mmbc-icon-dark-50x50.png")

            button.image = image
            button.title = "Menu Bar Customizer"
            button.action = #selector(showMenu(_:))
        }
    }

    @objc func showMenu(_ sender: Any?) {
        guard let button = statusItem.button else {
            return
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Change Color", action: #selector(changeColor.showWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        menu.popUp(
            positioning: nil,
            at: NSPoint(
                x: button.window?.frame.origin.x ?? 0,
                y: button.window?.frame.origin.y ?? 0),
            in: button
        )
    }

    @objc func doAction1(_ sender: Any?) {
        print("Performing Action 1")
    }

    @objc func doAction2(_ sender: Any?) {
        print("Performing Action 2")
    }
}

func main() {
    let app = NSApplication.shared
    let delegate = AppDelegate()

    app.delegate = delegate
    app.run()
}

main()