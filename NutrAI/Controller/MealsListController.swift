//
//  ViewController.swift
//  NutrAI
//
//  Created by Vinicius Mangueira on 02/07/19.
//  Copyright © 2019 Vinicius Mangueira. All rights reserved.
//

import UIKit

class MealsListController: UITableViewController {
    
    var model: Food101!
    
    let schedules = [Schedule(name: "BreakFast", imageNamed: "breakfast"),Schedule(name: "Lunch", imageNamed: "lunch"),Schedule(name: "Dinner", imageNamed: "dinner")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonDidClick))
        setupTableView()
        
        model = Food101()
    }
}

// MARK: - Actions

extension MealsListController {
    @objc func cameraButtonDidClick(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
}



extension MealsListController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        let resizableImage = CoreMLHelper.resizableImageForModel(image: image, size: CGSize(width: 299, height: 299))
        
        guard let newImage = resizableImage.image, let pixelBuffer = resizableImage.pixelBuffer else {
            return
        }
        
        // Assign new resizable image here
        
        
        // Get model prediction
        guard let prediction = try? model.prediction(image: pixelBuffer) else {
            return
        }
        
        // Display results
        print("I think this is a \(prediction.classLabel)")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension MealsListController {
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(cellType: MealsListCell.self)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MealsListHeader()
        header.schedule = schedules[section]
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MealsListCell.self)
        return cell
    }
}
