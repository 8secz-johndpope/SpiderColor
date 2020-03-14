//
//  GameViewController.swift
//  SpiderColor
//
//  Created by Ailton Vieira Pinto Filho on 04/03/20.
//  Copyright © 2020 Veevaz. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {
    @IBOutlet var sceneView: SKView!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!

    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        scene = GameScene(size: view.frame.size, top: topView.frame.maxY, bottom: view.frame.height - bottomView.frame.minY)
        scene.scaleMode = .resizeFill

        // Present the scene
        sceneView.presentScene(scene)
        sceneView.allowsTransparency = true

//        sceneView.ignoresSiblingOrder = true
//
//        sceneView.showsFPS = true
//        sceneView.showsNodeCount = true
//        sceneView.showsFields = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func onTapUndo(_ sender: Any) {
        scene.undoMovement()
    }
}
