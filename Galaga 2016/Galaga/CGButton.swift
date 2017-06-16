import SpriteKit
import Foundation

class CGButton: SKNode {
    var defaultButton: SKLabelNode
    var colorActive : UIColor
    var activeText : String
    var colorInactive: UIColor
    var inactiveText : String
    var action: () -> Void
    
    init(defaultButtonText: String, activeButtonText: String, colorInactive: UIColor, colorActive: UIColor, buttonAction: () -> Void) {
        defaultButton = SKLabelNode(text: defaultButtonText)
        self.colorActive = colorActive
        activeText = activeButtonText
        self.inactiveText = defaultButtonText
        self.colorInactive = colorInactive
        
        action = buttonAction
        
        super.init()
        
        userInteractionEnabled = true
        addChild(defaultButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        defaultButton.color = colorActive
        defaultButton.text = activeText
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        defaultButton.color = colorInactive
        defaultButton.text = inactiveText
        action()
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
  