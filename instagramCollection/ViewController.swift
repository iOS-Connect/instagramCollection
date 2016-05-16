import UIKit
import SafariServices


// account: johnregnericloud@gmail.com
// username: johnregnericloud
// pass: cwWeLzVV


//this view login API
class ViewController: UIViewController, SFSafariViewControllerDelegate {

  var svc: SFSafariViewController!
  var loginHasBeenShown = false

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    svc = SFSafariViewController(URL: NSURL(string:"https://api.instagram.com/oauth/authorize/" +
      "?client_id=" + clientID +
      "&redirect_uri=" + redirectURI +
      "&response_type=token")!)
    svc.delegate = self
    NSNotificationCenter.defaultCenter()
      .addObserver(self,
                   selector: #selector(ViewController.safariLoginComplete(_:)),
                   name: Notifications.CloseSafariViewController.rawValue, object: nil)
    if !loginHasBeenShown {
      presentViewController(svc, animated: true, completion: nil)
      loginHasBeenShown = true
    }
  }

  func safariLoginComplete(notification: NSNotification){
    //ensure we really have an auth token
    guard let accessT = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.AuthToken.rawValue) else {
      return
        
    }
    print(accessT)

    self.svc.dismissViewControllerAnimated(true){
      self.performSegueWithIdentifier("UserIsLoggedIn", sender: nil)
    }
  }

  // If someone presses the done button on the SafariViewController
  func safariViewControllerDidFinish(controller: SFSafariViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

}

let tags = "https://api.instagram.com/v1/tags/" + "nofilter" + "/media/recent" + "?access_token=ACCESS_TOKEN"