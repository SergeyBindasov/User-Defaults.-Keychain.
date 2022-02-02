//
//  ViewController.swift
//  FileManager
//
//  Created by Sergey on 28.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let fileManager = FileManager.default
    
    var content: [URL] = []
    var newFolder: URL?
    var folder: Int = 0
    
    @IBOutlet weak var fileTableview: UITableView!
    
    @IBAction func createFolder(_ sender: UIBarButtonItem) {
        
        var folder = UITextField()
        
        let alert = UIAlertController(title: "Создать новую папку", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            guard let text = folder.text else { return }
            self.newFolder = self.createUrl().appendingPathComponent(text)
            guard let folder = self.newFolder else { return }
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
        fileTableview.delegate = self
        fileTableview.dataSource = self
        loadContent()
    }
}

// MARK:  Class Methods
extension ViewController {
    func createUrl() -> URL {
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentsURL
    }
    
    func loadContent() {
        content = try! fileManager.contentsOfDirectory(at: createUrl(), includingPropertiesForKeys: nil, options: [])
        fileTableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "folder" {
            let vc = segue.destination as! FolderViewController
            vc.title = fileManager.displayName(atPath: content[folder].path)
        }
    }
}

// MARK:  TableView Methods
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        folder = indexPath.row
        performSegue(withIdentifier: "folder", sender: self)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        let folderName = content[indexPath.row].path
        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.text = fileManager.displayName(atPath: folderName)
        return cell
    }
}
