//
//  FolderViewController.swift
//  FileManager
//
//  Created by Sergey on 30.01.2022.
//

import UIKit

class FolderViewController: UIViewController {
    
    let fileManager = FileManager.default
    
    var subfolderContent: [URL] = []
    var newItem: URL?
    
    @IBOutlet weak var subfolderTableView: UITableView!
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func addSubfolder(_ sender: UIBarButtonItem) {
        var folder = UITextField()
        
        let alert = UIAlertController(title: "Создать новую папку", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            guard let text = folder.text else { return }
            self.newItem = self.createSubfolder().appendingPathComponent(text)
            guard let folder = self.newItem else { return }
            do {
                try self.fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: [:])
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.loadContent()
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Новая папка"
            folder = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subfolderTableView.delegate = self
        subfolderTableView.dataSource = self
        loadContent()
    }
}

extension FolderViewController {
    func createSubfolder() -> URL {
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let titleDir = title else { return documentsURL}
        let subdirectory = documentsURL.appendingPathComponent(titleDir)
        return subdirectory
    }
    
    func loadContent() {
        subfolderContent = try! fileManager.contentsOfDirectory(at: createSubfolder(), includingPropertiesForKeys: nil, options: [])
        subfolderTableView.reloadData()
    }
    
}

extension FolderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(subfolderContent[indexPath.row].path)
    }
    
}

extension FolderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subfolderContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "folderCell")
        let itemName = subfolderContent[indexPath.row].path
        cell.textLabel!.text = fileManager.displayName(atPath: itemName)
        return cell
    }
}

extension FolderViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            let imageName = UUID().uuidString
            let path = createSubfolder().appendingPathComponent(imageName)
            if let jpegData = editedImage.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: path)
            }
        }
        DispatchQueue.main.async {
            self.loadContent()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FolderViewController: UINavigationControllerDelegate {
}
