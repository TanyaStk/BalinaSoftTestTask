//
//  ViewController.swift
//  BalinaSoftTestTask
//
//  Created by Tanya Samastroyenka on 22.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var page = 1
    private var data = [Content]()
    private var selectedCellIndex = 0
    
    private let serviceProvider = ServiceProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceProvider.getData(page: page) { [weak self] response in
            self?.data = response.content
            self?.page += 1
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
        
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,
                          UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = data[indexPath.row].name
        return cell ?? UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            self.tableView.tableFooterView = createSpinnerFooter()
            serviceProvider.getData(page: page) { [weak self] response in
                self?.data.append(contentsOf: response.content)
                self?.page += 1
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        serviceProvider.postData(name: "Samostroenko Tatsiana Sergeevna", image: image, typeId: selectedCellIndex)
    }
}
