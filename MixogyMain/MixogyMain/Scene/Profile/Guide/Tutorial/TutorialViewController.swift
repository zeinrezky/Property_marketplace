//
//  TutorialViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 09/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Cartography
import RxCocoa
import RxSwift
import UIKit

protocol TutorialViewControllerDelegate: class {
    func tutorialViewController(didExit tutorialViewController: TutorialViewController)
}

class TutorialViewController: UIPageViewController {
    
    var viewModel = TutorialViewModel()
    var pages: [TutorialItemViewController] = []
    var disposeBag = DisposeBag()
    var pageControl = UIPageControl()
    
    weak var pageDelegate: TutorialViewControllerDelegate?
    
    var backgroundImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.setImage(UIImage(named: "Guide") ?? UIImage())
        image.alpha = 0.5
        return image
    }()
    
    var nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor(hexString: "#393939"), for: .normal)
        button.setTitle("next".localized(), for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Light", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor(hexString: "#393939"), for: .normal)
        button.setTitle("back".localized(), for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Light", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subView in view.subviews {
            if  subView is  UIPageControl {
                subView.frame.origin.y = self.view.frame.size.height - 120
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        pageControl.customPageControl(dotFillColor: UIColor.greenApp, dotBorderColor: UIColor.greenApp, dotBorderWidth: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Private Extension

fileprivate extension TutorialViewController {
    
    func setupUI() {
        setupPage()
        view.backgroundColor = .white
        self.setViewControllers(
            [pages[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )
        
        view.insertSubview(backgroundImage, at: 0)
        setupPageControl()
        view.addSubview(nextButton)
        view.addSubview(backButton)
        
        constrain(view, nextButton) { view, nextButton in
            nextButton.right == view.right - 49
            nextButton.bottom == view.bottom - 34
        }
        
        constrain(view, backButton) { view, backButton in
            backButton.left == view.left + 49
            backButton.bottom == view.bottom - 34
        }
        
        constrain(view, backgroundImage) { view, backgroundImage in
            backgroundImage.width == view.width * 4 / 3
            backgroundImage.height == backgroundImage.width * 1132 / 1117
            backgroundImage.centerX == view.centerX
            backgroundImage.topMargin == view.top
        }
        
        backButton.isHidden = true
        pageControl.isUserInteractionEnabled = false
    }
    
    func setupBinding() {
        viewModel.mode.subscribe(onNext: { mode in
            self.title = mode.title
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        nextButton.rx.tap.subscribe(onNext: {
            if self.nextButton.titleLabel?.text == "exit".localized() {
                if self.view.tag == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    Preference.buyGuideOpened = true
                    self.dismiss(animated: true, completion: nil)
                    self.pageDelegate?.tutorialViewController(didExit: self)
                }
            } else {
                guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }

                guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController) else { return }

                let index = self.viewControllers?.last?.view.tag ?? 0
                self.pageControl.currentPage = nextViewController.view.tag
                let reachNextLimit = index == self.viewModel.mode.value.infos.count - 2
                self.nextButton.setTitle(reachNextLimit ? "exit".localized() : "next".localized(), for: .normal)
                self.backButton.isHidden = false
                self.setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: {
            guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }

            guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerBefore: currentViewController) else { return }
            
            let index = self.viewControllers?.last?.view.tag ?? 0
            self.pageControl.currentPage = nextViewController.view.tag
            let reachNextLimit = index == 1
            self.backButton.isHidden = reachNextLimit
            self.nextButton.setTitle("next".localized(), for: .normal)
            self.setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func setupPage() {
        for info in viewModel.mode.value.infos {
            let tutorialItemViewController = TutorialItemViewController(nibName: "TutorialItemViewController", bundle: nil)
            tutorialItemViewController.viewModel.image.accept(UIImage(named: "Buy0"))
            tutorialItemViewController.viewModel.info.accept(info)
            pages.append(tutorialItemViewController)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = pages.count
        pageControl.backgroundColor = UIColor.clear
        let image = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: .greenApp)
        self.pageControl.pageIndicatorTintColor = UIColor.init(patternImage: image!)
        self.pageControl.currentPageIndicatorTintColor = .greenApp
        self.view.addSubview(pageControl)
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
    }
}

// MARK: - UIPageViewControllerDataSource

extension TutorialViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag - 1
        
        guard index >= 0 else {
            return nil
        }
        
        let tutorialItemViewController = TutorialItemViewController(nibName: "TutorialItemViewController", bundle: nil)
        tutorialItemViewController.viewModel.image.accept(UIImage(named: viewModel.mode.value.images[index]))
        tutorialItemViewController.viewModel.info.accept(viewModel.mode.value.infos[index])
        tutorialItemViewController.view.tag = index
        return tutorialItemViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag + 1
        
        guard viewModel.mode.value.infos.count > index else {
            return nil
        }
        
        let tutorialItemViewController = TutorialItemViewController(nibName: "TutorialItemViewController", bundle: nil)
        tutorialItemViewController.viewModel.image.accept(UIImage(named: viewModel.mode.value.images[index]))
        tutorialItemViewController.viewModel.info.accept(viewModel.mode.value.infos[index])
        tutorialItemViewController.view.tag = index
        return tutorialItemViewController
    }
}

// MARK: - UIPageViewControllerDelegate

extension TutorialViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = pageViewController.viewControllers?.last?.view.tag ?? 0
        let reachNextLimit = index == viewModel.mode.value.infos.count - 1
        nextButton.setTitle(reachNextLimit ? "exit".localized() : "next".localized(), for: .normal)
        backButton.isHidden = index == 0
        self.pageControl.currentPage = index
    }
}
