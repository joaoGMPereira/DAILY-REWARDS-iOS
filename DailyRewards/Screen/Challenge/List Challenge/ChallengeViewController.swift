//
//  ChallengeViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures
import FirebaseAuth

protocol ChallengeViewControllerDelegate: class {
    func selectedCell(cellType: ChallengeCellType, challenge: Challenge?)
}

protocol ChallengeViewControllerProtocol: class {
    func displayProfile(image: UIImage)
    func displayProfile(name: String)
    func displayProfile(error: String)
    func displayNew()
    func displayDetail(challenge: Challenge)

}

class ChallengeViewController: UIViewController {
    
    //MARK: UIProperties
    public let myChallengesScalingCarousel = ScalingCarouselView(withFrame: .zero, andInset: 50)
    var myChallengesSelectedAnimationView: SelectedAnimationView?
    public var groupsChallengesScalingCarousel = ScalingCarouselView(withFrame: .zero, andInset: 50)
    var groupsChallengesSelectedAnimationView: SelectedAnimationView?
    var scrollableStackView: ScrollableStackView = ScrollableStackView(frame: .zero)
    var headerView:ExpandableView = ExpandableView(frame: .zero, titleFont: .JEW16Bold(), color: .JEWBackground(), textColor: .white)
    var popupMessageView: JEWPopupMessage? = nil
    
    //MARK: Properties
    var delegate: ChallengeViewControllerDelegate?
    var myChallengesCollectionViewDataSource: MyChallengesCollectionViewDataSource?
    var groupChallengesCollectionViewDataSource: GroupChallengesCollectionViewDataSource?
    var headerHeightConstraint:NSLayoutConstraint!
    private var lastContentOffset: CGFloat = 0
    var interactor: ChallengeInteractorProtocol?
    let router: DailyRewardsRouterProtocol = DailyRewardsRouter()
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        self.setup()
        self.setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popupMessageView = JEWPopupMessage(parentViewController: self)
        scrollToSelectedIndex()
    }
    
    func scrollToSelectedIndex() {
        if let myChallengesSelectedAnimationView = myChallengesSelectedAnimationView {
            if myChallengesSelectedAnimationView.isExpanded {
                self.myChallengesCollectionViewDataSource?.scrollToSelectedIndex()
            }
        }
        if let groupsChallengesSelectedAnimationView = groupsChallengesSelectedAnimationView {
            if groupsChallengesSelectedAnimationView.isExpanded {
                self.groupChallengesCollectionViewDataSource?.scrollToSelectedIndex()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideSelectedAnimationView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        groupsChallengesScalingCarousel.reloadData()
        myChallengesScalingCarousel.reloadData()
    }
    
    func hideSelectedAnimationView() {
        if let myChallengesSelectedAnimationView = myChallengesSelectedAnimationView {
            if myChallengesSelectedAnimationView.isExpanded {
                myChallengesSelectedAnimationView.hide { (finished) in }
            }
        }
        
        if let groupsChallengesSelectedAnimationView = groupsChallengesSelectedAnimationView {
            if groupsChallengesSelectedAnimationView.isExpanded {
                groupsChallengesSelectedAnimationView.hide { (finished) in }
            }
        }
    }
    
    //MARK: Setup
    func setup() {
//        let interactor = ChallengeInteractor()
//        self.interactor = interactor
//        let presenter = ChallengePresenter()
//        presenter.viewController = self
//        interactor.presenter = presenter
//        delegate = self
//        interactor.downloadProfileImage()
//        interactor.setUserName()
    }
    
    //MARK: SetupUI
    func setupUI() {
        view.backgroundColor = .JEWBackground()
        setUpHeader()
        addCarousel()
    }
    
    func setUpHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 150)
        headerHeightConstraint.isActive = true
        let constraints:[NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        headerView.expandHeaderCallback = {
            self.animateExpandHeader()
        }
        
        headerView.collapseHeaderCallback = {
            self.animateCollapseHeader()
        }
        
        headerView.imageCallback = {(imageView) in
            self.router.setupProfileViewController(withParentViewController: self, heroImageView: self.headerView.iconImageView)
        }
    }
    
    private func addCarousel() {
        myChallengesSelectedAnimationView = SelectedAnimationView(frame: .zero, superView: myChallengesScalingCarousel, parentView: view)
        groupsChallengesSelectedAnimationView = SelectedAnimationView(frame: .zero, superView: groupsChallengesScalingCarousel, parentView: view)
        let titleMyRewardsLabel = self.setupMyChallengesTitle()
        let titleGroupsChallegens = self.setupGroupsChallengesTitle()
        interactor?.setMyChallenges()
        setupMyChallengesCollectionView()
        setupGroupsChallengesCollectionView()
        scrollableStackView.delegate = self
        scrollableStackView.setup(subViews: [titleMyRewardsLabel, myChallengesScalingCarousel, titleGroupsChallegens, groupsChallengesScalingCarousel], axis: .vertical, spacing: 8, alwaysBounce: true)
        setupScrollableConstraints()
    }
    
    func setupMyChallengesTitle() -> UILabel {
        let titleMyRewardsLabel = UILabel(frame: .zero)
        titleMyRewardsLabel.backgroundColor = .clear
        titleMyRewardsLabel.text = ChallengeConstants.myChallenges.rawValue
        titleMyRewardsLabel.textColor = .JEWDefault()
        titleMyRewardsLabel.font = .JEW16Bold()
        return titleMyRewardsLabel
    }
    
    func setupGroupsChallengesTitle() -> UILabel {
        let titleGroupsRewardsLabel = UILabel(frame: .zero)
        titleGroupsRewardsLabel.backgroundColor = .clear
        titleGroupsRewardsLabel.text = ChallengeConstants.groupChallenges.rawValue
        titleGroupsRewardsLabel.textColor = .JEWDefault()
        titleGroupsRewardsLabel.font = .JEW16Bold()
        return titleGroupsRewardsLabel
    }
    
    func setupMyChallengesCollectionView() {
        myChallengesCollectionViewDataSource = MyChallengesCollectionViewDataSource.init(challenges: interactor?.myChallenges ?? [], scrollableStackView: scrollableStackView, collectionView: myChallengesScalingCarousel, viewControllerDelegate: delegate, animationView: myChallengesSelectedAnimationView)
        myChallengesScalingCarousel.translatesAutoresizingMaskIntoConstraints = false
        myChallengesScalingCarousel.backgroundColor = .clear
        myChallengesScalingCarousel.register(ChallengeNewCell.self, forCellWithReuseIdentifier: String(describing: type(of: ChallengeNewCell.self)))
        myChallengesScalingCarousel.register(ChallengeInfoCell.self, forCellWithReuseIdentifier: String(describing: type(of: ChallengeInfoCell.self)))
        myChallengesScalingCarousel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupGroupsChallengesCollectionView() {
        groupChallengesCollectionViewDataSource = GroupChallengesCollectionViewDataSource.init(challenges: interactor?.groupChallenges ?? [], scrollableStackView: scrollableStackView, collectionView: groupsChallengesScalingCarousel, viewControllerDelegate: delegate, animationView: groupsChallengesSelectedAnimationView)
        groupsChallengesScalingCarousel.translatesAutoresizingMaskIntoConstraints = false
        groupsChallengesScalingCarousel.backgroundColor = .clear
        groupsChallengesScalingCarousel.register(ChallengeNewCell.self, forCellWithReuseIdentifier: String(describing: type(of: ChallengeNewCell.self)))
        groupsChallengesScalingCarousel.register(ChallengeInfoCell.self, forCellWithReuseIdentifier: String(describing: type(of: ChallengeInfoCell.self)))
        groupsChallengesScalingCarousel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupScrollableConstraints() {
        view.addSubview(scrollableStackView)
        scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollableStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollableStackView.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.bottomAnchor),
            scrollableStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollableStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        self.interactor?.setMyChallenges()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.myChallengesScalingCarousel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.myChallengesScalingCarousel.reloadData()
            self.groupsChallengesScalingCarousel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            self.groupsChallengesScalingCarousel.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.myChallengesCollectionViewDataSource?.collectionViewScrollPosition()
                self.groupChallengesCollectionViewDataSource?.collectionViewScrollPosition()
            }
        }
    }
}

extension ChallengeViewController: ChallengeViewControllerProtocol {
    
    func displayProfile(image: UIImage) {
        headerView.iconImageView.image = image
    }
    
    func displayProfile(error: String) {
        popupMessageView?.show(withTextMessage: error, title: "\(JEWConstants.Default.title)\n", popupType: .error)
    }
    
    func displayProfile(name: String) {
        headerView.titleLabel.text = name
    }
    
    func displayNew() {
        router.setupNewChallengeViewController(withParentViewController: self)
    }
    
    func displayDetail(challenge: Challenge) {
        router.setupEditChallengeViewController(withParentViewController: self, challenge: challenge)
    }
}

extension ChallengeViewController: ChallengeViewControllerDelegate {
    func selectedCell(cellType: ChallengeCellType, challenge: Challenge?) {
        interactor?.selectedCell(cellType: cellType, challenge: challenge)
    }
}
