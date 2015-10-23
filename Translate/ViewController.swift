//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //Text field for translation
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    //Pickerview to select languages
    @IBOutlet weak var pickerView: UIPickerView!
    
    var lang = "hello"
    var rowSelected = 0
    
    //Creation of pickerview
    var pickerDataLanguage = ["French", "Gaelic", "Turkish"];

    
    //var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
    }

    // Function about PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataLanguage.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataLanguage[row]
    }
    
    //Detecting pickerview selected row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        rowSelected = row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func translate(sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        switch rowSelected {
        case 0: lang = ("en|fr")
        case 1: lang = ("en|ga")
        case 2: lang = ("en|tr")
        default:break
        }
        
        let langStr = lang.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = NSURL(string: urlStr)
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
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