import UIKit

class PopularCollections: UICollectionViewController {

  let network = Network()
  var data: [String] = []

  override func viewDidLoad() {
    network.getPhotos { (names) in
      self.data = names
      self.collectionView?.reloadData()
    }
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! InstagramCell
    cell.label.text = data[indexPath.row]
    return cell
  }

}

class InstagramCell: UICollectionViewCell {
  @IBOutlet weak var label: UILabel!
}

class Network {

  func getPhotos(completion:[String] -> Void){

    let names = ["one", "two", "three"]

    completion(names)
  }

}