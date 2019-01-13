
/*let alertController = UIAlertController(title: "StreetFit", message: "Bienvenue", preferredStyle: UIAlertController.Style.alert)
 let showNextController = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in
 // Show next ViewController
 let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
 let newViewController = storyBoard.instantiateViewController(withIdentifier: "IDCurrentEvents")
 self.present(newViewController, animated: true, completion: nil)
 }
 
 alertController.addAction(showNextController)
 self.present(alertController,animated: true,completion: nil)
 */


/*let alertController = UIAlertController(title: "StreetFit", message: "Echec de la connection", preferredStyle: UIAlertController.Style.alert)
 alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
 self.present(alertController,animated: true,completion: nil)*/


/*func RequestAVSports (targetURL: String, theSessionManager: SessionManager, completion: @escaping ([String]?) -> Void) {
 
 theSessionManager.request(targetURL, method: .get)
 .validate()
 .responseJSON { response in
 
 //print(response)
 
 switch response.result {
 
 case .success:
 
 guard response.result.isSuccess else {return completion(nil)}
 guard let rawInventory = response.result.value as? Array? else {return completion(nil)}
 
 completion(rawInventory)
 
 case .failure(let error):
 print(error)
 
 }
 
 }*/
