//
//  ViewController.swift
//  photoSearch
//
//  Created by Yotaro Ito on 2021/02/24.
//

import UIKit

class ViewController: UIViewController {
   
    

   var results: [Result] = []
    
    private var collectionview: UICollectionView?
   
    let searchBar = UISearchBar()
    
    
   
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        searchBar.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionview = collectionView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-20,
                                 height: 50)
        collectionview?.frame = CGRect(x: 0,
                                       y: view.safeAreaInsets.top+55,
                                       width: view.frame.size.width,
                                       height: view.frame.size.height-55)
       
    }
    func fetchphoto(query: String){
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {return}
            do{
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionview?.reloadData()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }

}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.getImage(with: imageURLString)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            results = []
            collectionview?.reloadData()
            fetchphoto(query: text)
        }
    }
}
