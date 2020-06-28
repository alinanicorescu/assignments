//
//  TvShowsViewController.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit

class TvShowsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: TvShowsViewModel?
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    private let showDetailsSegue = "showDetails"
    
    private var selectedShowId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = TvShowsViewModel(completion: updateUI(error:))
        configureNavigation()
        configureLogoutButton()
        self.viewModel?.loadTvShows()
    }
    
    private func configureLogoutButton() {
        let image = UIImage(named:"ic-logout")!.withRenderingMode(.alwaysOriginal)
        logoutButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
    }
    
    private func configureTableView() {
        let cellId = TvShowCell.REUSE_ID
        let homeNib = UINib(nibName: cellId, bundle: nil)
        tableView.register(homeNib, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Shows"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func updateUI(error: Error?) {
        if error != nil {
            Common.presentErrorAlert("An error occurred while loading tvShows", fromVC: self)
            return
        } else {
            self.tableView.reloadData()
        }
    }
}

extension TvShowsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfTvShows() ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TvShowCell.REUSE_ID) as? TvShowCell {
            cell.configure(viewModel?.getTvShow(at: indexPath.item))
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension TvShowsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedShowId = viewModel?.getTvShow(at: indexPath.item).id
        self.performSegue(withIdentifier: self.showDetailsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TvShowDetailViewController {
            vc.showId = self.selectedShowId
        }
    }
}
