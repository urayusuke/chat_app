import Cocoa
import FlutterMacOS
import WebKit // 1. フレームワークをインポート

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  var popover = NSPopover()
  var statusBarItem: NSStatusItem?
  var webView: WKWebView! // 2. WKWebViewのインスタンスを追加

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let mainWindow = NSApplication.shared.mainWindow {
        mainWindow.orderOut(nil)
    }

    // ステータスバーアイコンの初期化と設定
    statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    if let button = statusBarItem?.button {
        button.image = NSImage(named: "g-solid")
        button.action = #selector(togglePopover)
    }

    let flutterProject = FlutterDartProject.init()
    let flutterEngine = FlutterEngine(name: "my flutter engine", project: flutterProject)
    flutterEngine.run(withEntrypoint: nil)
    let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    
    // WKWebViewの初期化
    webView = WKWebView(frame: .zero) // 3. WKWebViewを初期化

    if webView.superview == nil {
        popover.contentViewController?.view.addSubview(webView)
    }

    // MethodChannelのセットアップ
    let channel = FlutterMethodChannel(name: "com.example.openwebpage", binaryMessenger: flutterViewController.engine.binaryMessenger)
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "openWebPage" {
            if let urlStr = call.arguments as? String, let url = URL(string: urlStr) {
                self.webView.load(URLRequest(url: url)) // 4. WebViewを表示
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_URL", message: "Invalid URL provided", details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    })
    
    popover.contentViewController = flutterViewController
  }

  @objc func togglePopover() {
    if popover.isShown {
        popover.performClose(nil)
    } else {
        if let button = statusBarItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }
}

extension AppDelegate: WKNavigationDelegate {
    // 5. WebViewの動作をカスタマイズするためのメソッドをここに追加
}
