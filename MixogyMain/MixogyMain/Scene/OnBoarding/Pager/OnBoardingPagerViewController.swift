//
//  OnBoardingPagerViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Cartography
import FirebaseAuth
import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit

class OnBoardingPagerViewController: UIPageViewController {

    var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var maskView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = "What kind of ticket are you searching for?"
        label.numberOfLines = 0
        label.font = UIFont(name: "Nunito-ExtraLight", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("select".localized(), for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.clipsToBounds = true
        return button
    }()
    
    var disposeBag = DisposeBag()
    var viewModel = OnBoardingPagerViewModel()
    var pages: [OnBoardingViewController] = []
    var startOffset = CGFloat(0)
    var currentIndex = 0
    var prevIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if view.tag == 0 {
            viewModel.fetchData()
//        }
    }
    
    @objc
    func routeToHome() {
        guard !viewModel.data.value.isEmpty else {
            return
        }
        
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        mainViewController.selectedId = viewModel.data.value[selectButton.tag].id
        mainViewController.selectedIndex = selectButton.tag
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.tintColor = UIColor(hexString: "#898989")
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Nunito-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#393939")
        ]
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}

// MARK: - Private Extension

fileprivate extension OnBoardingPagerViewController {
    
    func setupUI() {
        view.insertSubview(titleLabel, at: 0)
        view.insertSubview(maskView, at: 0)
        view.insertSubview(backgroundImageView, at: 0)
        view.addSubview(selectButton)
        
        constrain(view, backgroundImageView) { view, backgroundImageView in
            view.top == backgroundImageView.top
            view.left == backgroundImageView.left
            view.right == backgroundImageView.right
            view.bottom == backgroundImageView.bottom
        }
        
        constrain(view, maskView) { view, maskView in
            view.top == maskView.top
            view.left == maskView.left
            view.right == maskView.right
            view.bottom == maskView.bottom
        }
        
        constrain(view, titleLabel) { view, label in
            label.top == view.top + 52
            label.left == view.left + 35
            label.right == view.right - 35
        }
        
        constrain(view, selectButton) { view, selectButton in
            selectButton.bottom == view.bottom - 24
            selectButton.left == view.left + 35
            selectButton.right == view.right - 35
        }
        
        for v in view.subviews{
            if v is UIScrollView {
                (v as! UIScrollView).delegate = self
            }
        }
    }
    
    func setupBinding() {
        selectButton.rx.tap.subscribe(onNext: {
            self.routeToHome()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.data.subscribe(onNext: { list in
            
            for i in 0..<list.count {
                let onBoardingViewController = OnBoardingViewController(
                    nibName: "OnBoardingViewController",
                    bundle: nil
                )
                
                onBoardingViewController.modalPresentationStyle = .currentContext
                onBoardingViewController.view.backgroundColor = .clear
                onBoardingViewController.categorytitle = list[i].name
                onBoardingViewController.categoryAfterTitle = (i == list.count - 1) ? list[0].name : list[i+1].name
                onBoardingViewController.categoryBeforeTitle = (i == 0) ? list[list.count - 1].name : list[i-1].name
                onBoardingViewController.view.tag = i
                
                if i == 0 {
                    self.backgroundImageView.sd_setImage(
                        with: URL(string: list[i].backgroundURL ?? ""),
                        placeholderImage: nil,
                        options: .refreshCached,
                        completed: nil
                    )
                    
                    self.titleLabel.text = list[i].description
                    
                    self.setViewControllers(
                        [onBoardingViewController],
                        direction: .forward,
                        animated: true,
                        completion: nil
                    )
                }
                
                self.pages.append(onBoardingViewController)
            }
            
//            self.view.tag = 1
            
            if !(Preference.buyGuideOpened ?? false) {
                let tutorialViewController = TutorialViewController(
                    transitionStyle: .scroll,
                    navigationOrientation: .horizontal,
                    options: nil
                )
                tutorialViewController.viewModel.mode.accept(.buy)
                tutorialViewController.modalPresentationStyle = .overCurrentContext
                tutorialViewController.view.tag = 1
                self.present(tutorialViewController, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnBoardingPagerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        self.backgroundImageView.sd_setImage(
            with: URL(string: viewModel.data.value[index].backgroundURL ?? ""),
            placeholderImage: nil,
            options: .refreshCached,
            completed: nil
        )
        self.titleLabel.text = viewModel.data.value[index].description
        let newIndex = index == 0 ? pages.count - 1 : index - 1
        pages[newIndex].isSwpeHide = true
        pages[newIndex].hideAfter = true
        pages[newIndex].hideTitle = true
        currentIndex = newIndex
        prevIndex = index
        return pages[newIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        backgroundImageView.sd_setImage(
            with: URL(string: viewModel.data.value[index].backgroundURL ?? ""),
            placeholderImage: nil,
            options: .refreshCached,
            completed: nil
        )
        titleLabel.text = viewModel.data.value[index].description
        let newIndex = index == pages.count - 1 ? 0 : index + 1
        pages[newIndex].isSwpeHide = true
        pages[newIndex].hideBefore = true
        pages[newIndex].hideTitle = true
        currentIndex = newIndex
        prevIndex = index
        return pages[newIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnBoardingPagerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        selectButton.tag = pageViewController.viewControllers?.last?.view.tag ?? 0
    }
}

extension OnBoardingPagerViewController : UIScrollViewDelegate{

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
    }
    

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction = 0 //scroll stopped
        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage /  self.view.frame.width
        
        if startOffset < scrollView.contentOffset.x {
            direction = 1 //going right
            pages[prevIndex].afterOpacity = 1.0 - percent
            pages[currentIndex].beforeOpacity = percent - 0.5
            pages[currentIndex].afterOpacity = percent - 0.5
        } else if startOffset > scrollView.contentOffset.x {
            direction = -1 //going left
            pages[currentIndex].afterOpacity = percent - 0.5
            pages[currentIndex].beforeOpacity = percent - 0.5
            pages[prevIndex].beforeOpacity = 1.0 - percent
        }
    }
}
