import AppKit
import CoreGraphics
import Vision

func windows(for pid: Int) -> [[String: Any]] {
    let candidates = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
        as? [[String: Any]] ?? []
    return candidates.filter { window in
        let owner = window[kCGWindowOwnerPID as String] as? Int
        let layer = window[kCGWindowLayer as String] as? Int
        let size = window[kCGWindowBounds as String] as? [String: Double] ?? [:]
        return owner == pid && layer == 0 && (size["Width"] ?? 0) >= 400 && (size["Height"] ?? 0) >= 260
    }
}

if CommandLine.arguments[1] == "window" {
    let pid = Int(CommandLine.arguments[2])!
    let visible = windows(for: pid)
    if visible.isEmpty { exit(1) }
    print("Visible OneClient window found for PID \(pid).")
    exit(0)
}

let screenshot = URL(fileURLWithPath: CommandLine.arguments[2])
let request = VNRecognizeTextRequest()
request.recognitionLevel = .accurate
try VNImageRequestHandler(url: screenshot).perform([request])
let labels = (request.results ?? []).compactMap { result -> (String, CGRect)? in
    guard let label = result.topCandidates(1).first?.string else { return nil }
    return (label, result.boundingBox)
}
let screenText = labels.map { $0.0.lowercased() }.joined(separator: " ")
guard screenText.contains("oneclient"),
      (screenText.contains("downloaded from the internet") || screenText.contains("sure you want to open it")),
      let button = labels.first(where: { $0.0.lowercased() == "open" }) else { exit(1) }

let screen = CGDisplayBounds(CGMainDisplayID())
let point = CGPoint(x: screen.minX + button.1.midX * screen.width,
                    y: screen.minY + (1 - button.1.midY) * screen.height)
for kind: CGEventType in [.mouseMoved, .leftMouseDown, .leftMouseUp] {
    CGEvent(mouseEventSource: nil, mouseType: kind, mouseCursorPosition: point, mouseButton: .left)?
        .post(tap: .cghidEventTap)
    usleep(100_000)
}
print("Clicked Open in the macOS first-launch confirmation.")
