//
//  GuildOverviewViewController.swift
//  Habitica
//
//  Created by Phillip Thelen on 02.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import Habitica_Models
import PinLayout

class GuildOverviewViewController: BaseTableViewController, UISearchBarDelegate {
    
    let segmentedWrapper = UIView()
    let headerImageView = UIImageView()
    let headerSeparator = UIView()
    let segmentedFilterControl = UISegmentedControl(items: [L10n.myGuilds, L10n.discover])
    
    var dataSource = GuildsOverviewDataSource()
    
    let tableHeaderWrapper = UIView()
    let invitationListView = GroupInvitationListView()
    let searchbar = UISearchBar()
    
    var isShowingPrivateGuilds: Bool {
        return segmentedFilterControl.selectedSegmentIndex == 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Titles.guilds
        
        segmentedFilterControl.selectedSegmentIndex = 0
        segmentedFilterControl.addTarget(self, action: #selector(switchFilter), for: .valueChanged)
        segmentedWrapper.addSubview(segmentedFilterControl)
        headerImageView.image = HabiticaIcons.imageOfGuildHeaderCrest()
        headerImageView.contentMode = .center
        segmentedWrapper.addSubview(headerImageView)
        segmentedWrapper.addSubview(headerSeparator)
        layoutHeader()
        topHeaderCoordinator?.alternativeHeader = segmentedWrapper
        topHeaderCoordinator.hideHeader = false
        topHeaderCoordinator.followScrollView = false
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.keyboardDismissMode = .onDrag
        
        dataSource.tableView = tableView
        dataSource.invitationListView = invitationListView
        
        searchbar.placeholder = L10n.search
        searchbar.delegate = self
        
        tableHeaderWrapper.addSubview(searchbar)
        tableHeaderWrapper.addSubview(invitationListView)
        tableView.tableHeaderView = tableHeaderWrapper
        
        dataSource.retrieveData(completed: nil)
    }
    
    override func applyTheme(theme: Theme) {
        super.applyTheme(theme: theme)
        headerSeparator.backgroundColor = theme.separatorColor
    }
    
    override func viewWillLayoutSubviews() {
        layoutHeader()
        searchbar.pin.top().horizontally().height(44)
        let height = invitationListView.intrinsicContentSize.height
        invitationListView.pin.below(of: searchbar).horizontally().height(height)
        tableHeaderWrapper.pin.top().horizontally().height(44 + height)
        super.viewWillLayoutSubviews()
    }
    
    private func layoutHeader() {
        headerImageView.pin.horizontally().top().height(58)
        headerSeparator.pin.below(of: headerImageView).marginTop(12).horizontally().height(2)
        segmentedFilterControl.pin.below(of: headerSeparator).marginTop(8).horizontally(8).sizeToFit(.width)
        segmentedWrapper.pin.horizontally().top().height(segmentedFilterControl.frame.origin.y + segmentedFilterControl.frame.size.height + 8)
    }
    
    @objc
    private func refresh() {
        dataSource.retrieveData(completed: {[weak self] in
            self?.refreshControl?.endRefreshing()
        })
    }
    
    @objc
    private func switchFilter() {
        dataSource.isShowingPrivateGuilds = isShowingPrivateGuilds
        
        if isShowingPrivateGuilds {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.searchText = searchText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Social.showGuildSegue.rawValue, let cell = sender as? UITableViewCell {
            let destViewController = segue.destination as? SplitSocialViewController
            let indexPath = tableView.indexPath(for: cell)
            destViewController?.groupID = dataSource.item(at: indexPath)?.id
        }
    }
    
    @IBAction func createGuildAction(_ sender: Any) {
        let alert = HabiticaAlertController(title: L10n.createGuild, message:  L10n.createGuildDescription)
        alert.addAction(title: L10n.openWebsite, style: .default, isMainAction: true) { _ in
            guard let url = URL(string: "https://habitica.com/groups/myGuilds") else {
                return
            }
            UIApplication.shared.open(url)
        }
        alert.addCloseAction()
        alert.show()
    }
}
