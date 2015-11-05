//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate , UIPickerViewDataSource, UIPickerViewDelegate{
    
    //Text field for translation
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    //Pickerview to select languages
    @IBOutlet weak var pickerView: UIPickerView!
    
    var lang = "hello"
    var rowSelected1 = 0
    var rowSelected2 = 0
    
    //Creation of pickerview
    var pickerDataLanguageToTranslate = ["English", "French", "Gaelic", "Turkish"]
    var pickerDataLanguageTranslated = ["English", "French", "Gaelic", "Turkish"]
    
    //var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.textToTranslate.delegate = self
        //self.view.backgroundColor = UIColor.blackColor()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Dismiss keyboard by touching to anywhere on the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerView[row]
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }*/

    // Function about PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return pickerDataLanguageToTranslate.count
        }else{
            return pickerDataLanguageTranslated.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return pickerDataLanguageToTranslate[row]
        }else{
            return pickerDataLanguageTranslated[row]
        }
    }
    
    //Detecting pickerview selected row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if component == 0 {
            rowSelected1 = row
        }else{
            rowSelected2 = row
        }
    }
    
    @IBAction func translate(sender: AnyObject) {
        
        let str = textToTranslate.text
        
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        //Define the request
        switch rowSelected1 {
            case 0: switch rowSelected2 {
                        case 0: lang = ("en|en")
                        case 1: lang = ("en|fr")
                        case 2: lang = ("en|ga")
                        case 3: lang = ("en|tr")
                        default:break
                    }
            case 1: switch rowSelected2 {
                        case 0: lang = ("fr|en")
                        case 1: lang = ("fr|fr")
                        case 2: lang = ("fr|ga")
                        case 3: lang = ("fr|tr")
                        default:break
                    }
            case 2: switch rowSelected2 {
                        case 0: lang = ("ga|en")
                        case 1: lang = ("ga|fr")
                        case 2: lang = ("ga|ga")
                        case 3: lang = ("ga|tr")
                        default:break
            }
            case 3: switch rowSelected2 {
                        case 0: lang = ("tr|en")
                        case 1: lang = ("tr|fr")
                        case 2: lang = ("tr|ga")
                        case 3: lang = ("tr|tr")
                        default:break
            }
            default:break
        }
        
        let langStr = lang.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

        //let session = NSURLSession.sharedSession()
        
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = NSURL(string: urlStr)
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
        /*_ = session.dataTaskRequest(request) {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in*/
            
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            
            indicator.stopAnimating()
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    if(jsonDict.valueForKey("responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.objectForKey("responseData") as! NSDictionary
                        
                        result = responseData.objectForKey("translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        }
        
    }
}