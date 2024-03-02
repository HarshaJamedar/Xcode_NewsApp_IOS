//
//  ViewController.swift
//  NewsApp
//
//  Created by HARSHAVARDHAN JEMEDAR on 2/29/24.
//

import UIKit
//Table view
//custom cell
//API caller
//search news
//open news

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [NewsTableViewCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "BizTimes"
        // Set the font attributes for the title
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36) // Change 24 to the desired font size
            ]
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource=self
        
        view.backgroundColor = .systemBackground
        
        APIkeyCaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellModel(title: $0.title,
                                           subtitle: $0.description ?? "No Description",
                                           imageURL: URL(string: $0.urlToImage ?? "")
                                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //frames for table
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
        
        

//Table view functions:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


