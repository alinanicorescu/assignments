//
//  EpisodeDetailsViewController.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit

class EpisodeDetailsViewConroller: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var descriptionTf: UITextField!

    private var viewModel: EpisodeDetailsViewModelProtocol?
    var episodeId: String?
    
    private let ShowCommentsSegue = "showComments"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTf.contentMode = .topLeft
        descriptionTf.contentVerticalAlignment = .top
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        viewModel = EpisodeDetailsViewModel(episodeId: episodeId, completion: updateUI(error:))
        viewModel?.fetchEpisodeDetails()
    }
    
    func updateUI(error: Error?) {
        if error != nil {
            Common.presentErrorAlert("An error occurred while retrieving episode details", fromVC: self)
            return
        }
        let placeholder = UIImage(named: "ic-camera")
        if let imageUrl = viewModel?.getImageUrl() {
            self.imageView?.af.setImage(withURL: imageUrl, placeholderImage: placeholder)
        }
        titleLabel.text = viewModel?.getTitleText()
        episodeLabel.text = viewModel?.getEpisodeText()
        descriptionTf.text = viewModel?.getDescriptionText()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CommentsViewController {
            vc.episodeId = self.episodeId
        }
    }
    
    @IBAction func commentsPressed(_ sender: UIButton) {
    }
}
