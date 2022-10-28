//
//  ViewController.swift
//  EmitterAnimate
//
//  Created by 张泽群 on 2022/10/28.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        print("status", sender.isSelected)
    }
}

class EmitterButton: UIButton {
    var emitterLayer: CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterMode = .points
        emitterLayer.renderMode = .oldestFirst
        emitterLayer.emitterShape = .point
        emitterLayer.emitterSize = CGSize(width: 1, height: 1)
        emitterLayer.position = CGPoint(x: bounds.width / 2, y: 0)
        emitterLayer.emitterCells = creatCells()
        emitterLayer.birthRate = 0
        return emitterLayer
    }

    var lastClickTime: TimeInterval = 0
    /// 毫秒
    var delayTime: TimeInterval = 500

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return false
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        print("endTracking")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("停止动画")
        emitterLayer.birthRate = 0
    }
}

private extension EmitterButton {
    func prepare() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)

        let long = UILongPressGestureRecognizer(target: self, action: #selector(longAction))
        addGestureRecognizer(long)
    }

    func creatCells() -> [CAEmitterCell] {
        let cells = (0...11).map { index -> CAEmitterCell in
            let image = UIImage(named: "smiley_\(index)")
            let cell = CAEmitterCell()
            cell.birthRate = 1
            cell.lifetime = 2
            cell.lifetimeRange = 2
            cell.scale = 0.35
            cell.alphaRange = 1
            cell.alphaSpeed = -1
            cell.yAcceleration = 450
            cell.velocity = 450
            cell.velocityRange = 50
            cell.emissionRange = CGFloat.pi / 2
            cell.emissionLongitude = CGFloat.pi*3/2
            cell.contents = image?.cgImage
            return cell
        }
        return cells
    }

    func startEmitter(emitterLayer: CAEmitterLayer) {
        layer.addSublayer(emitterLayer)
        emitterLayer.birthRate = 0.5
    }

    @objc func stopEmittter(emitterLayer: CAEmitterLayer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned emitterLayer] in
            emitterLayer.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                emitterLayer.removeFromSuperlayer()
            }
        }
    }

    @objc func tapAction() {
        let layer = emitterLayer

        startEmitter(emitterLayer: layer)
        stopEmittter(emitterLayer: layer)

        if isSelected {
            print("点击 - 取消选中")
            sendActions(for: .touchUpInside)
        } else {
            print("点击 - 选中")
        }
    }

    @objc func longAction(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            print("开始长按")
            if !isSelected {
                sendActions(for: .touchUpInside)
            }
        case .ended:
            print("停止长按")
        default:
            break
        }
    }
}
