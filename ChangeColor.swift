import Cocoa;

class ChangeColor: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad();
        
        // Create a new window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        // Create a color picker
        let colorPicker = NSColorPickerViewController.shared;
        
        // Set the color picker as the content view controller of the window
        window.contentViewController = colorPicker;
        
        // Display the window
        window.makeKeyAndOrderFront(nil);
        
        // Set the window controller's window
        self.window = window;
    }
}