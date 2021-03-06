//
//  LevelViewController.swift
//  SpiderColor
//
//  Created by Ailton Vieira Pinto Filho on 16/03/20.
//  Copyright © 2020 Veevaz. All rights reserved.
//

import UIKit

protocol LevelViewDelegate {
    func complete(level: Level, completion: @escaping () -> Void)
}

class LevelViewController: UIViewController {
    //MARK: - Outlets

    @IBOutlet var backgroundGradientView: GradientView!
    @IBOutlet var pageControl: PageDotView!
    @IBOutlet var containerPageView: UIView!
    @IBOutlet var bgGradientTopContraint: NSLayoutConstraint!

    //MARK: - Variables

    var pageViewController: UIPageViewController!

    private var indexPage = 0
    private var numberOfPages: Int { GameManager.shared.pages }

    private var page: UIViewController { page(from: indexPage)! }

    var swipingToPage: Int = 0

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        containerPageView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerPageView.bounds
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self)

        goTo(indexPage: GameManager.shared.lastPageCompleted)

        let level = GameManager.shared.lastLevelCompleted
        if level.value > 0 {
            backgroundGradientView.colors = level.colors
        } else {
            backgroundGradientView.backgroundColor = .black
        }

        pageControl.numberOfPages = GameManager.shared.pages
        pageControl.setInitial(page: GameManager.shared.lastPageCompleted)
    }

    override var prefersStatusBarHidden: Bool { true }

    private func goTo(indexPage: Int, revealFirst: Bool = false) {
        if let page = page(from: indexPage) {
            if let levelPage = page as? LevelPageCollectionViewController {
                levelPage.revealFirst = revealFirst
            }

            let direction: UIPageViewController.NavigationDirection
            if view.isRTL {
                direction = indexPage > self.indexPage ? .reverse : .forward
            } else {
                direction = indexPage > self.indexPage ? .forward : .reverse
            }

            if (pageViewController.viewControllers?.first as? LevelPageCollectionViewController)?.page != indexPage {
                pageViewController.setViewControllers([page], direction: direction, animated: true, completion: nil)
            }
            self.indexPage = indexPage
        }
    }

    private func page(from index: Int) -> UIViewController? {
        let levels = Array(GameManager.shared.levelsFor(page: index))
        let page = LevelPageCollectionViewController(page: index, levels: levels, parent: self)
        page.delegate = self
        page.levelViewDelegate = self
        return page
    }

    //MARK: - Actions

    @IBAction func onTapHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onTapPrevious(_ sender: Any?) {
        if indexPage > 0 {
            AnalyticsUtils.tapButton("previous_level")
            goTo(indexPage: indexPage - 1)
            pageControl.previous()
        } else {
            AnalyticsUtils.tapButton("back_home")
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onTapNext(_ sender: Any?) {
        AnalyticsUtils.tapButton("next_level")
        if indexPage < numberOfPages - 1 {
            goTo(indexPage: indexPage + 1)
            pageControl.next()
        }
    }
}

//MARK: - UIPageViewControllerDelegate

extension LevelViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let levelPage = pendingViewControllers.first as? LevelPageCollectionViewController {
            swipingToPage = levelPage.page
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if swipingToPage > indexPage {
                pageControl.next()
            } else {
                pageControl.previous()
            }
            goTo(indexPage: swipingToPage)
        }
    }
}

//MARK: - UIPageViewControllerDataSource

extension LevelViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        indexPage == 0 ? nil : page(from: indexPage - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        indexPage == numberOfPages - 1 ? nil : page(from: indexPage + 1)
    }
}

//MARK: - LevelPageDelegate

extension LevelViewController: LevelPageDelegate {
    func nextPage(revealFirst: Bool) {
        if indexPage < numberOfPages - 1 {
            goTo(indexPage: indexPage + 1, revealFirst: revealFirst)
            pageControl.next()
        }
    }
}

//MARK: - GameDelegate

extension LevelViewController: LevelViewDelegate {
    func complete(level: Level, completion: @escaping () -> Void) {
        if level.value - 1 == GameManager.shared.lastValueLevelCompleted {
            let auxBG = GradientView()
            auxBG.colors = level.colors
            auxBG.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(auxBG, aboveSubview: backgroundGradientView)

            NSLayoutConstraint.activate([
                auxBG.widthAnchor.constraint(equalTo: backgroundGradientView.widthAnchor),
                auxBG.heightAnchor.constraint(equalTo: backgroundGradientView.heightAnchor),
                auxBG.centerXAnchor.constraint(equalTo: backgroundGradientView.centerXAnchor),
                auxBG.topAnchor.constraint(equalTo: backgroundGradientView.bottomAnchor)
            ])

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                UIView.animate(withDuration: 2.0, animations: {
                    self.bgGradientTopContraint.constant = -self.backgroundGradientView.frame.height
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.bgGradientTopContraint.constant = 0
                    self.backgroundGradientView.colors = level.colors
                    auxBG.removeFromSuperview()
                    completion()
                }
            }
        } else {
            completion()
        }
    }
}
