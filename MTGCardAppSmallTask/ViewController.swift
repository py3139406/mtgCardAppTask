//
//  ViewController.swift
//  MTGCardAppSmallTask
//
//  Created by pavan yadav on 14/03/24.
//
import UIKit

class ViewController: UIViewController {
    private var segmentedControl:UISegmentedControl!
    private var collectionView:UICollectionView!
    var totalCards:[Card] = []
    var filteredCards:[Card] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        applyConstraints()
        setActions()
        Task {
         await getCards()
        }
        
    }
    private func getCards() async {
        do {
            let jsonStrings =  try await APIImpl.shared.getCards()
            let jsonData = Data(jsonStrings.utf8)
            
            do {
                let cards = try JSONDecoder().decode([Card].self, from: jsonData)
                totalCards = cards
                filteredCards = totalCards
                self.collectionView.reloadData()
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
        } catch  {
            printContent(error.localizedDescription)
        }
    }
    
    private func setActions(){
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func addViews(){
        // Add segmented control
        segmentedControl = UISegmentedControl(items: ["ALL", "Artifact", "Creature","Instant","Sorcery"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterItems(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)

        // Add collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom:0, right: 10)
        layout.itemSize = CGSize(width: view.frame.width * 0.46,
                                 height: view.frame.height * 0.25)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
    }
    @objc func filterItems(_ sender: UISegmentedControl) {
        // Use `sender` to access the segmented control that triggered the action
        filteredCards = totalCards
        switch sender.selectedSegmentIndex {
        case 1:
            filteredCards = filteredCards.filter({$0.types.contains(ItemType.artifact.rawValue)})
            self.collectionView.reloadData()
            return
        case 2:
            filteredCards = filteredCards.filter({$0.types.contains(ItemType.creature.rawValue)})
            self.collectionView.reloadData()
            return
        case 3:
            filteredCards = filteredCards.filter({$0.types.contains(ItemType.instant.rawValue)})
            self.collectionView.reloadData()
            return
        case 4:
            filteredCards = filteredCards.filter({$0.types.contains(ItemType.sorcery.rawValue)})
            self.collectionView.reloadData()
            return
        default:
            self.collectionView.reloadData()
            return
        }
    }

    private func applyConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Segmented control constraints
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),

            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
        cell.layer.cornerRadius = 5
        cell.topLabel.text = filteredCards[indexPath.row].nameJapanese
        if let url = URL(string: filteredCards[indexPath.row].imageUrls.first ?? "") {
            downloadImage(from: url) { image in
                if let image = image {
                    DispatchQueue.main.sync {
                        cell.cardImage.image = image
                    }
                } else {
                    print("Failed to download image")
                }
            }
        } else {
            print("Invalid URL")
        }
        
        return cell
    }
    
    // Optional: Implement additional delegate methods as needed
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Create a URLSessionDataTask to download the image data
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            guard let data = data, error == nil else {
                print("Failed to download image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            // Convert the downloaded data into a UIImage
            if let image = UIImage(data: data) {
                completion(image) // Call the completion handler with the downloaded image
            } else {
                print("Failed to create image from data")
                completion(nil)
            }
        }
        
        // Start the URLSessionDataTask
        task.resume()
    }
}

enum ItemType:String {
    case creature = "Creature"
    case artifact = "Artifact"
    case instant = "Instant"
    case sorcery = "Sorcery"
}
