//
//  TvShowDetailViewController.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class TvShowDetailViewController: UIViewController {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private static let AddEpisodeSegue = "addEpisode"
    private static let ShowEpisodeSegue = "episodeDetails"
    
    private var viewModel: TvShowDetailViewModel?
    private var selectedEpisodeId: String?
    var showId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if let showId = showId {
            self.viewModel = TvShowDetailViewModel(showId: showId, completion: configureUI(error:), episodesCompletion: loadTableView(error:))
        }
        viewModel?.fetchShowDetails()
        viewModel?.fetchEpisodes()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShowTitleSection.nib, forHeaderFooterViewReuseIdentifier: ShowTitleSection.reuseIdentifier)
        tableView.register(TextCell.nib, forCellReuseIdentifier: TextCell.reuseIdentifier)
        tableView.register(EpisodeCell.nib, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureUI(error: Error?) {
        if error != nil {
            Common.presentErrorAlert("An error occurred while retrieving show details",
                                     fromVC: self)
        } else {
            updateShowImage()
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func loadTableView(error: Error?) {
        if error != nil {
            Common.presentErrorAlert("An error occurred while retrieving episodes",
                                     fromVC: self)
        } else {
            tableView.reloadData()
        }
    }
      
    private func updateShowImage() {
        if let urlString =  viewModel?.getShowDetail()?.imageUrl, let imageUrl = URL(string: urlString)  {
            self.showImage?.af.setImage(withURL: imageUrl)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddTvShowViewController {
            destinationVC.showId = self.viewModel?.getShowDetail()?.id
        }
        if let destinationVC = segue.destination as? EpisodeDetailsViewConroller {
            destinationVC.episodeId = self.selectedEpisodeId
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension TvShowDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShowTitleSection.reuseIdentifier) as? ShowTitleSection {
            switch section {
                case 0:
                    return configureSectionShowDetail(sectionView)
                case 1:
                    return configureSectionNumberOfEpisodes(sectionView)
                default:
                 return sectionView
            }
        }
        return UIView()
    }
    
    private func configureSectionShowDetail(_ s: ShowTitleSection) -> ShowTitleSection {
        s.configure(text: viewModel?.getSectionShowText())
        return s
    }
    
    private func configureSectionNumberOfEpisodes(_ s: ShowTitleSection) -> ShowTitleSection {
        s.configure(viewModel?.getSectionEpisodesText())
        return s
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.getSectionHeight(index: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.getRowHeight(sIndex: indexPath.section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRowsInSection(sIndex: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return dequeTextCell() ?? UITableViewCell()
        } else {
            return dequeEpisodeCell(indexPath) ?? UITableViewCell()
        }
    }
    
    @IBAction public func cancelTvShows(_ unwindSegue: UIStoryboardSegue) {
        self.viewModel?.fetchEpisodes()
    }
    
      private func dequeTextCell() -> TextCell? {
          let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseIdentifier) as? TextCell
          cell?.configure(text: viewModel?.getShowDetail()?.description ?? "")
          return cell
      }
      
      private func dequeEpisodeCell(_ indexPath: IndexPath) -> EpisodeCell? {
          let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier) as? EpisodeCell
          let epText = viewModel?.getEpisodeCellText(indexPath)
          cell?.configure(epText)
          return cell
      }
}

extension TvShowDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEpisodeId = viewModel?.getEpisode(at: indexPath.item).id
        self.performSegue(withIdentifier: TvShowDetailViewController.ShowEpisodeSegue, sender: self)
    }
}
