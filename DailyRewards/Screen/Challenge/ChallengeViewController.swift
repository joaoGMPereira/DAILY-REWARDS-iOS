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

protocol ChallengeViewControllerProtocol: class {
    func displayProfile(image: UIImage)
    func displayProfile(error: String)
}

class ChallengeViewController: UIViewController {
    
    //MARK: UIProperties
    @IBOutlet weak var signOutButton: UIButton!
    var tableView:UITableView = UITableView()
    var headerView:ExpandableHeaderView = ExpandableHeaderView(frame: .zero, titleFont: .JEW16Bold(), color: .JEWBlack(), textColor: .white)
    var popupMessageView: JEWPopupMessage? = nil
    
    //MARK: Properties
    var headerHeightConstraint:NSLayoutConstraint!
    private var lastContentOffset: CGFloat = 0
    var interactor: ChallengeInteractorProtocol?
    let router: DailyRewardsRouterProtocol = DailyRewardsRouter()
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Challenge"
        popupMessageView = JEWPopupMessage(parentViewController: self)
    }
    
    //MARK: Setup
    func setup() {
        let interactor = ChallengeInteractor()
        self.interactor = interactor
        let presenter = ChallengePresenter()
        presenter.viewController = self
        interactor.presenter = presenter
        interactor.downloadProfileImage()
    }
    
    //MARK: SetupUI
    func setupUI() {
        view.backgroundColor = .JEWBlack()
        signOutButton.tintColor = .JEWDefault()
        setUpHeader()
        setUpTableView()
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
            print("chegou aqui")
        }
    }
    
    func setUpTableView() {
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let constraints:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ]
        NSLayoutConstraint.activate(constraints)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            router.setupLoginViewController()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ChallengeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Teste\(indexPath.row)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.tintColor = .clear
        cell.backgroundView?.backgroundColor = .clear
        return cell
    }
    
    
}

extension ChallengeViewController:UITableViewDelegate {
}


extension ChallengeViewController: ChallengeViewControllerProtocol {
    func displayProfile(image: UIImage) {
        headerView.iconImageView.image = image
        headerView.titleLabel.text = "Bem Vindo: \(JEWSession.session.user?.fullName?.capitalized ?? String())" 
    }
    
    func displayProfile(error: String) {
        popupMessageView?.show(withTextMessage: error, title: "\(JEWConstants.Default.title)\n", popupType: .error)
    }
    
    
}
