import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let button = statusItem.button {
            button.action = #selector(showMenu(_:))
            
            let fileManager = FileManager.default
            let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
            let imagesURL = currentDirectoryURL.appendingPathComponent("Images")
            let imageURL = imagesURL.appendingPathComponent("mmbc-icon-light-16x16.png")
            
            if let image = NSImage(contentsOf: imageURL) {
                button.image = image
            } else {
                print("Failed to load the image.")
            }
        }
    }

    @objc func showMenu(_ sender: Any?) {
        guard let button = statusItem.button else {
            return
        }

        let menu = NSMenu()

        let changeColorItem = NSMenuItem(
            title: "Change Top Menu Bar Color",
            action: #selector(openColorPickerWindow(_:)),
            keyEquivalent: ""
        )

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )

        menu.addItem(changeColorItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)
        
        let buttonHeight = button.frame.height
        let offset: CGFloat = 7

        if let view = button.superview {
            let frameOrigin = NSPoint(
                x: button.frame.origin.x, 
                y: view.bounds.size.height - button.frame.origin.y - buttonHeight - offset
            )
            menu.popUp(positioning: nil, at: frameOrigin, in: view)
        }
    }


    @objc func openColorPickerWindow(_ sender: Any?) {
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
