//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Zhi Huang on 8/30/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var imageSpinnerView: UIActivityIndicatorView!

    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        imageSpinnerView.startAnimating()
        
//        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
//        imageView.setImageWithURL(url)
        
        var origUrl = movie.valueForKeyPath("posters.thumbnail") as! String
        var range = origUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            origUrl = origUrl.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }

        let url = NSURL(string: origUrl as String)!
        
        let request = NSURLRequest(URL: url)
        
        imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            self.imageSpinnerView.hidden = true
            self.imageView.image = image
            }) { (request, response, error) -> Void in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
