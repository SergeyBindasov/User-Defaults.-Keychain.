//
//  FolderViewController.swift
//  FileManager
//
//  Created by Sergey on 30.01.2022.
//
import Foundation
import UIKit

class FolderViewController: UIViewController {
    
    let fileManager = FileManager.default
    
    var observer: NSKeyValueObservation?
    var subfolderContent: [URL] = []
    var newItem: URL?
    
    @IBOutlet weak var subfolderTableView: UITableView!
    
    // MARK:  Class Methods
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
    
    deinit {
        observer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subfolderTableView.register(UINib(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        subfolderTableView.delegate = self
        subfolderTableView.dataSource = self
        loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeSort()
        observeSize()
        loadContent()
    }
}

extension FolderViewController {
    
    func observeSort() {
        observer = UserDefaults.standard.observe(\.sortBool, options: .new) { defaults, value in
        }
    }
    
    func observeSize() {
        observer = UserDefaults.standard.observe(\.sizeBool, options: .new) { (defaults, value) in
        }
    }
    
    func createSubfolder() -> URL {
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let titleDir = title else { return documentsURL}
        let subdirectory = documentsURL.appendingPathComponent(titleDir)
        return subdirectory
    }
    
    func loadContent() {
        
        subfolderContent = try! fileManager.contentsOfDirectory(at: createSubfolder(), includingPropertiesForKeys: nil, options: [])
        
        let sortedUrls = subfolderContent.sorted { a, b in
            if UserDefaults.standard.sortBool == true {
                return a.lastPathComponent.localizedStandardCompare(b.lastPathComponent) == ComparisonResult.orderedAscending
            } else {
                return a.lastPathComponent.localizedStandardCompare(b.lastPathComponent) == ComparisonResult.orderedDescending
            }
        }
        subfolderContent = sortedUrls
        subfolderTableView.reloadData()
    }
    
    func getSizeOfImg(path: URL) -> Int {
        do {
            let attribute = try fileManager.attributesOfItem(atPath: path.path)
            
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.intValue / 1000
            }
        } catch {
            print ("No size")
        }
        return 0
    }
}
// MARK: TableView Methods
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
        
        let cell = subfolderTableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! FileCell
        
        let itemName = subfolderContent[indexPath.row].path
        
        cell.label.text = fileManager.displayName(atPath: itemName)
        
        cell.cellImage.image = UIImage(contentsOfFile: itemName) ?? UIImage(systemName: "questionmark.folder.fill")
        if UserDefaults.standard.sizeBool == true {
            cell.sizeLabel.isHidden = false
            cell.sizeLabel.text = "\(getSizeOfImg(path: subfolderContent[indexPath.row])) Кб"
        } else {
            cell.sizeLabel.isHidden = true
        }
        return cell
    }
}
// MARK: UIImagePicker Methods
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

extension UserDefaults {
    @objc dynamic var sizeBool: Bool {
        return bool(forKey: "sizeBool")
    }
    
    @objc dynamic var sortBool: Bool {
        return bool(forKey: "sortBool")
    }
}
