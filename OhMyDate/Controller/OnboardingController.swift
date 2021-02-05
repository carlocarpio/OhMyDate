//
//  OnboardingController.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 2/5/21.
//

import UIKit
import paper_onboarding

class OnboardingController: UIViewController {
    
    //MARK: Properties
    
    private var onboardingItems = [OnboardingItemInfo]()
    private var onboardingView = PaperOnboarding()
    
    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.alpha = 0
        button.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifeycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureOnboardingDataSource()
    }
    
    //MARK: Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(onboardingView)
        onboardingView.fillSuperview()
        onboardingView.delegate = self
        
        view.addSubview(getStartedButton)
        getStartedButton.centerX(inView: view)
        getStartedButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 128)
    }
    
    func configureOnboardingDataSource() {
        let item1 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "baseline_insert_chart_white_48pt_2x").withRenderingMode(.alwaysOriginal), title: MSG_FIND, description: "Some description here.", pageIcon: UIImage(), color: .systemPurple, titleColor: .white, descriptionColor: .white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 16))
        
        let item2 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "baseline_insert_chart_white_48pt_2x").withRenderingMode(.alwaysOriginal), title: MSG_KNOW, description: "Some description here.", pageIcon: UIImage(), color: .systemBlue, titleColor: .white, descriptionColor: .white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 16))
        
        let item3 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "baseline_insert_chart_white_48pt_2x").withRenderingMode(.alwaysOriginal), title: MSG_DATE, description: "Some description here.", pageIcon: UIImage(), color: .systemPink, titleColor: .white, descriptionColor: .white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 16))
        
        onboardingItems.append(item1)
        onboardingItems.append(item2)
        onboardingItems.append(item3)
        
        onboardingView.dataSource = self
        onboardingView.reloadInputViews()
    }
    
    func animatedGetStartedButton(_ shouldShow: Bool) {
        let alpha:CGFloat = shouldShow ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.getStartedButton.alpha = alpha
        }
    }
    
    //MARK:  Selectors
    
    @objc func dismissOnboarding() {
        print("DEBUG: 123")
    }
}

extension OnboardingController: PaperOnboardingDataSource {
    func onboardingItemsCount() -> Int {
        return onboardingItems.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItems[index]
    }
}

extension OnboardingController: PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        print("DEBUG: index = \(index)")
        
        let shouldShow = index == onboardingItems.count - 1 ? true : false
        animatedGetStartedButton(shouldShow)
    }
}

