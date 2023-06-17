import Cocoa
import AppKit
import SwiftUI

class ColorPickerWindowController: NSWindowController {
    var menuColor: ((NSColor) -> Void)?
    var textColor: ((NSColor) -> Void)?
    var menuColorWell: NSColorWell!
    var textColorWell: NSColorWell!
    var menuColorLabel: NSTextField!
    var textColorLabel: NSTextField!
    var progressIndicator: NSProgressIndicator!
    
    convenience init() {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 200, height: 160),
                              styleMask: [.titled, .closable],
                              backing: .buffered,
                              defer: false)
        self.init(window: window)
        
        // Initialize menuColorWell and textColorWell
        menuColorWell = NSColorWell(frame: NSRect(x: 20, y: 90, width: 28, height: 28))
        textColorWell = NSColorWell(frame: NSRect(x: 20, y: 60, width: 28, height: 28))
        
        // Initialize menuColorLabel and textColorLabel
        menuColorLabel = NSTextField(frame: NSRect(x: 55, y: 90, width: 100, height: 20))
        menuColorLabel.stringValue = "Menu Color"
        menuColorLabel.isEditable = false
        menuColorLabel.isBordered = false
        menuColorLabel.backgroundColor = NSColor.clear
        
        textColorLabel = NSTextField(frame: NSRect(x: 55, y: 60, width: 100, height: 20))
        textColorLabel.stringValue = "Text Color"
        textColorLabel.isEditable = false
        textColorLabel.isBordered = false
        textColorLabel.backgroundColor = NSColor.clear
        
        // Initialize progressIndicator
        progressIndicator = NSProgressIndicator(frame: NSRect(x: 20, y: 20, width: 40, height: 40))
        progressIndicator.style = .spinning
        
        // Add menuColorWell, textColorWell, menuColorLabel, and textColorLabel to the window's contentView
        window.contentView?.addSubview(menuColorWell)
        window.contentView?.addSubview(textColorWell)
        window.contentView?.addSubview(menuColorLabel)
        window.contentView?.addSubview(textColorLabel)
        
        window.orderFrontRegardless()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Hide the window
        window?.orderOut(nil)
        
        // Show the progress indicator
        window?.contentView?.addSubview(progressIndicator)
        
        // Observe the isContinuous property of NSColorPanel.shared
        NSColorPanel.shared.addObserver(self, forKeyPath: "isContinuous", options: .new, context: nil)
        
        // Show the color picker
        NSColorPanel.shared.orderFrontRegardless()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isContinuous", let isContinuous = change?[.newKey] as? Bool, !isContinuous {
            // Color picker finished loading
            DispatchQueue.main.async {
                // Remove the progress indicator
                self.progressIndicator.removeFromSuperview()
            }
            
            // Get the selected colors from the color wells
            if let menuColor = self.menuColor {
                menuColor(self.menuColorWell.color)
            }
            
            if let textColor = self.textColor {
                textColor(self.textColorWell.color)
            }
            
            // Stop observing
            NSColorPanel.shared.removeObserver(self, forKeyPath: "isContinuous")
        }
    }
}

class CustomWindowController: NSWindowController {
    var menuColor: ((NSColor) -> Void)?
    var textColor: ((NSColor) -> Void)?
    
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 160),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        self.init(window: window)
        window.center()
        
        let contentView = ContentView(menuColor: menuColor, textColor: textColor)
        window.contentView = NSHostingView(rootView: contentView)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var colorPickerWindowController: CustomWindowController?

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
        let horizontalOffset: CGFloat = 10

        if let view = button.superview {
            let frameOrigin = NSPoint(
                x: button.frame.origin.x - horizontalOffset, 
                y: view.bounds.size.height - button.frame.origin.y - buttonHeight - offset
            )
            menu.popUp(positioning: nil, at: frameOrigin, in: view)
        }
    }

    @objc func openColorPickerWindow(_ sender: Any?) {
        if colorPickerWindowController == nil {
            colorPickerWindowController = CustomWindowController()
        }
        
        colorPickerWindowController?.menuColor = { [weak self] color in
            if let button = self?.statusItem.button {
                button.layer?.backgroundColor = color.cgColor
                button.needsDisplay = true
            }
        }
        
        colorPickerWindowController?.textColor = { [weak self] color in
            if let button = self?.statusItem.button {
                let attributes = [NSAttributedString.Key.foregroundColor: color]
                let attributedTitle = NSAttributedString(string: "Menu", attributes: attributes)
                button.attributedTitle = attributedTitle
                button.needsDisplay = true
            }
        }
        
        colorPickerWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

func main() {
    let app = NSApplication.shared
    let delegate = AppDelegate()

    app.delegate = delegate
    app.run()
}

main()
