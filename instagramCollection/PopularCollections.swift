import UIKit

class PopularCollections: UICollectionViewController {
    
    let network = Network()
    var data: [String] = []
//    var url: [NSURL] = []

    
    override func viewDidLoad() {
        network.getPhotos { (names) in
            self.data = names
            self.collectionView?.reloadData()
        }
//        self.data = network.getPhotos()
//        self.collectionView?.reloadData()
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! InstagramCell
        //cell.label.text = data[indexPath.row]
        let imageUrl = data[indexPath.row]
        
        network.getImageFromUrl(imageUrl) {myImage in
            print("hello")
            cell.image.image = myImage
        }
        
        
        return cell
    }
    
}

class InstagramCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!

    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let superAt = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if superAt.frame.width > screenWidth {
            let newFrame = CGRect(x: superAt.frame.origin.x, y: superAt.frame.origin.y, width: screenWidth-20.0, height: superAt.frame.height)
            superAt.frame = newFrame
        }
        
        return superAt
    }
    
}

class Network {
    let session = NSURLSession.sharedSession()

    func getPhotos(completion:([String])->Void){
        
        var names = [String]()

        
        
        
        
        //json request
        let url = NSURL(string: "https://api.instagram.com/v1/users/self/media/recent/?access_token=3225346526.ea0f869.e7ca148f8fcb4df88aa014a32faaa565")!
        
        let dataTask = session.dataTaskWithURL(url) { (data,response, error) -> Void in
            
            do
            {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                
                let results = jsonData.objectForKey("data") as! NSArray
                
                
                for item in results
                {
                    
                    let images = (item as! NSDictionary).objectForKey("images") as! NSDictionary
                    let image = images.objectForKey("standard_resolution") as! NSDictionary
                    let imageURL = image.objectForKey("url") as! String
                    print(imageURL)
                    names.append(imageURL)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(names)
                })
            }
            catch
            {
                print("Error: \(error)")
            }
        }
        
        dataTask.resume()
//        return names

    }
    
    func getImageFromUrl(url:String, completion:(UIImage)->Void){
        let newTask = session.dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            let img = UIImage(data: data!)!
            completion(img)
        }
        newTask.resume()
    }
}

//https://api.instagram.com/v1/users/self/media/recent/?access_token=ACCESS-TOKEN