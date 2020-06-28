//
//  AddTvShowViewController.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

class AddTvShowViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seasonTextF: FloatingLabelTextField!
    @IBOutlet weak var titleTextF: FloatingLabelTextField!
    @IBOutlet weak var descTextF: FloatingLabelTextField!
    @IBOutlet weak var episodeTextF: FloatingLabelTextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    private let BackSegue = "backSegue"
    private var viewModel: AddEpisodeViewModelProtocol?
    var showId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seasonTextF.delegate = self
        titleTextF.delegate = self
        episodeTextF.delegate = self
        descTextF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.viewModel = AddEpisodeViewModel(showId: showId, completion: episodeAdded(error:)) as! AddEpisodeViewModelProtocol
    }
    
    func episodeAdded(error: Error?) {
        if error != nil {
            Common.presentErrorAlert("Error while saving episode", fromVC: self)
            return
        }
        self.performSegue(withIdentifier: BackSegue, sender: self)
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        let imageController = UIImagePickerController()
        imageController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        imageController.delegate = self
        self.present(imageController, animated: false, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        viewModel?.setTitle(title: titleTextF?.text)
        viewModel?.setSeason(season: seasonTextF?.text)
        viewModel?.setEpisodeNumber(epNumber: episodeTextF?.text)
        viewModel?.setDescription(description: descTextF?.text)
        viewModel?.addShowEpisode()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension AddTvShowViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.imageView.image = image
        self.viewModel?.setImage(image: image)
        picker.dismiss(animated: false, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
        
}

extension AddTvShowViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
}
