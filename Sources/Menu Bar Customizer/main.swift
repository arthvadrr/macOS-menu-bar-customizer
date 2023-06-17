import Cocoa
import AppKit

class ColorPickerWindowController: NSWindowController {
    var colorWell: NSColorWell!

    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        self.init(window: window)

        colorWell = NSColorWell(frame: NSRect(x: 50, y: 100, width: 200, height: 50))
        window.contentView?.addSubview(colorWell)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        // Additional setup code for the window
    }

    // Other methods and actions related to the color picker window
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var colorPickerWindowController: NSWindowController?


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
        if colorPickerWindowController == nil {
            colorPickerWindowController = ColorPickerWindowController()
        }

        colorPickerWindowController?.showWindow(nil)
        colorPickerWindowController?.window?.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
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
