/**
 *  Simple dots animation.
 *  Written by @martinsoft.
 *  Based on original CSS animation by @sasha.codes
 */
import UIKit
import PlaygroundSupport

let colors = [
    UIColor(red: 238/255, green: 217/255, blue: 104/255, alpha: 1),
    UIColor(red: 238/255, green: 206/255, blue: 104/255, alpha: 1),
    UIColor(red: 238/255, green: 195/255, blue: 104/255, alpha: 1),
    UIColor(red: 238/255, green: 173/255, blue: 104/255, alpha: 1),
    UIColor(red: 238/255, green: 140/255, blue: 104/255, alpha: 1),
]

func createDot(position: CGPoint, color: CGColor, size: CGSize) -> CAShapeLayer {
    let dot = CAShapeLayer()
    dot.bounds = CGRect(origin: .zero, size: size)
    dot.position = position
    dot.path = UIBezierPath(ovalIn: dot.bounds).cgPath
    dot.fillColor = color
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
let (dotSize, dotCount, dotSpacing) = (CGSize(width: 20, height: 20), colors.count, CGFloat(15))

// View setup for playground
let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .white
PlaygroundPage.current.liveView = view

// Create a layer to contain all the dots - so that we can position the group more easily.
let container = CALayer()
container.bounds = CGRect(origin: .zero,
                          size: CGSize(width: (dotSize.width * CGFloat(dotCount)) +
                                              (dotSpacing * CGFloat(dotCount - 1)),
                                       height: dotSize.height))
container.position = view.center
view.layer.addSublayer(container)

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

for i in (0..<dotCount) {
    let dotColor = colors[i].cgColor
    let dotPosition = CGPoint(x: dotSize.width / 2 + CGFloat(i) * (dotSize.width + dotSpacing),
                              y: dotSize.height / 2)
    
    let dot = createDot(position: dotPosition, color: dotColor, size: dotSize)
    container.addSublayer(dot)

    let pulse = createDot(position: dotPosition, color: dotColor, size: dotSize)
    container.insertSublayer(pulse, below: dot)

    pulseAnimation.beginTime = CACurrentMediaTime() + (Double(i) * 0.2)
    pulse.add(pulseAnimation, forKey: "pulse")
}
