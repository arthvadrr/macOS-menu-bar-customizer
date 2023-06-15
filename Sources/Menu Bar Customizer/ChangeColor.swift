import Cocoa

class ColorPickerView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // Create a color panel
        let colorPanel = NSColorPanel.shared
        
        // Set the color panel frame to fill the view bounds
        colorPanel.setFrameOrigin(NSPoint.zero)
        colorPanel.setFrameTopLeftPoint(frameRect.origin)
        
        // Disable color panel resizing
        colorPanel.isFloatingPanel = false
        colorPanel.isMovable = false
        
        // Add the color panel as a child window
        if let window = self.window {
            window.addChildWindow(colorPanel, ordered: .above)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChangeColor: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Create a new window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        // Create a color picker view
        let contentRect = window.contentRect(forFrameRect: window.frame)
        let colorPickerView = ColorPickerView(frame: contentRect)
        
        // Set the color picker view as the content view of the window
        window.contentView = colorPickerView
        
        // Display the window
        window.makeKeyAndOrderFront(nil)
        
        // Set the window controller's window
        self.window = window
    }
}
