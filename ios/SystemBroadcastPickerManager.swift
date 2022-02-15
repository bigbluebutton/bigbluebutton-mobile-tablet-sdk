import ReplayKit
import os

@objc(SystemBroadcastPickerManager)
class SystemBroadcastPickerManager: RCTViewManager {
    override func view() -> (SystemBroadcastPicker) {
        return SystemBroadcastPicker();
    }
}

class SystemBroadcastPicker : UIView {
    
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "SystemBroadcastPicker")
    
    // Reference to the broadcast screen picker
    private var broadcastPicker: RPSystemBroadcastPickerView?
    
    // The bundle-id of our the broadcast application (so system only offers BBB in the list)
    private var broadcastAppBundleId: String = ""
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /**
     * Adds RPSystemBroadcastPickerView to the view
     */
    private func setupView() {
        logger.info("Initializing SystemBroadcastPickerManager")
        let pickerFrame = CGRect(x: 30, y: 30, width: 100, height: 100)
        broadcastPicker = RPSystemBroadcastPickerView(frame: pickerFrame)
        broadcastPicker?.showsMicrophoneButton=false
        broadcastPicker?.isHidden=true
        
        self.addSubview(broadcastPicker!)
    }
    
    /**
     * Receive this property from react
     */
    @objc(setBroadcastAppBundleId:)
    public func setBroadcastAppBundleId(newBroadcastAppBundleId: String) {
        logger.info("setBroadcastAppBundleId called \(newBroadcastAppBundleId)")
        self.broadcastAppBundleId = newBroadcastAppBundleId
        broadcastPicker?.preferredExtension = self.broadcastAppBundleId
        
        self.requestBroadcast() // REMOVE THIS WHEN WE EXPOSE TO REACT (now it's requesting to share screen on app load)
    }
    
    /**
     * Automatize the action of broadcast picker click
     */
    private func requestBroadcast() {
        for view in broadcastPicker?.subviews ?? [] {
            if let button = view as? UIButton {
                button.sendActions(for: .allEvents)
            }
        }
    }
    
}
