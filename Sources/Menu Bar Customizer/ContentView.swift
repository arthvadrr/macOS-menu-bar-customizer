import SwiftUI

struct ContentView: View {
    @State private var menuColor = NSColor.white
    @State private var textColor = NSColor.black
    
    var menuColorCallback: ((NSColor) -> Void)?
    var textColorCallback: ((NSColor) -> Void)?
    
    init(menuColor: ((NSColor) -> Void)?, textColor: ((NSColor) -> Void)?) {
        self.menuColorCallback = menuColor
        self.textColorCallback = textColor
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ColorWellView(color: $menuColor, label: "Menu Color", callback: menuColorCallback)
            ColorWellView(color: $textColor, label: "Text Color", callback: textColorCallback)
        }
        .padding()
    }
}

struct ColorWellView: View {
    @Binding var color: NSColor
    var label: String
    var callback: ((NSColor) -> Void)?
    
    var body: some View {
        HStack {
            ColorWell(color: $color)
            Text(label)
            Spacer()
        }
        .frame(height: 28)
    }
}

struct ColorWell: NSViewRepresentable {
    @Binding var color: NSColor
    
    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell()
        colorWell.target = context.coordinator
        colorWell.action = #selector(Coordinator.colorChanged(_:))
        return colorWell
    }
    
    func updateNSView(_ nsView: NSColorWell, context: Context) {
        nsView.color = color
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(color: $color)
    }
    
    class Coordinator: NSObject {
        @Binding var color: NSColor
        
        init(color: Binding<NSColor>) {
            _color = color
        }
        
        @objc func colorChanged(_ sender: NSColorWell) {
            color = sender.color
        }
    }
}
