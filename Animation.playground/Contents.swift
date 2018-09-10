/**
 *  Simple dots animation.
 *  Written by @martinsoft.
 *  Based on original CSS animation by @sasha.codes
 */
import UIKit
import PlaygroundSupport

func createDot(position: CGPoint, color: CGColor, size: CGSize) -> CALayer {
    let dot = CALayer()
    dot.cornerRadius = size.height / 2.0
    dot.backgroundColor = color
    dot.bounds = CGRect(origin: .zero, size: size)
    dot.position = position
    return dot
}

extension CAKeyframeAnimation {
    convenience init(keyPath: String, keyFrames: [(time: NSNumber, value: Any)],
                     duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        self.init(keyPath: keyPath)
        (self.duration, self.timingFunction) = (duration, timingFunction)
        (keyTimes, values) = ( keyFrames.map { $0.time }, keyFrames.map { $0.value })
    }
}

// Component setup
let (dotCount, dotSize, dotSpacing) = (5, CGSize(width: 20, height: 20), CGFloat(15))

// View setup for playground
let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .white
PlaygroundPage.current.liveView = view

// Create a layer to contain all the dots - so that we can position the group more easily.
let wrapper = CAReplicatorLayer()
wrapper.bounds = CGRect(origin: .zero,
                          size: CGSize(width: (dotSize.width * CGFloat(dotCount)) +
                                              (dotSpacing * CGFloat(dotCount - 1)),
                                       height: dotSize.height))
wrapper.position = view.center
view.layer.addSublayer(wrapper)

let pulseAnimation = CAAnimationGroup()
pulseAnimation.animations = [
    CAKeyframeAnimation(keyPath: "transform.scale",
                        keyFrames: [ (time: 0, value: 1),
                                     (time: 0.75, value: 2.5),
                                     (time: 1, value: 2.5)],
                        duration: 2,
                        timingFunction: CAMediaTimingFunction(controlPoints: 0, 0, 0.49, 1.02)),
    CAKeyframeAnimation(keyPath: "opacity",
                        keyFrames: [ (time: 0, value: 1),
                                     (time: 0.78, value: 0),
                                     (time: 1, value: 0)],
                        duration: 2,
                        timingFunction: CAMediaTimingFunction(controlPoints: 0, 0, 0.49, 1.02))
]
pulseAnimation.repeatCount = Float.infinity
pulseAnimation.duration = 3

let firstColor = #colorLiteral(red: 0.9333333333, green: 0.8509803922, blue: 0.4078431373, alpha: 1).cgColor
let dotPosition = CGPoint(x: dotSize.width / 2, y: dotSize.height / 2)
let dot = createDot(position: dotPosition, color: firstColor, size: dotSize)
let pulse = createDot(position: dotPosition, color: firstColor, size: dotSize)
pulse.add(pulseAnimation, forKey: nil)

wrapper.instanceCount = dotCount
wrapper.instanceDelay = 0.2
wrapper.instanceGreenOffset = -0.11
wrapper.instanceTransform = CATransform3DMakeTranslation(dotSize.width + dotSpacing, 0, 0)
wrapper.addSublayer(dot)
wrapper.insertSublayer(pulse, below: dot)
