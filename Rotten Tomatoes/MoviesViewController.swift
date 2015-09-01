//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Zhi Huang on 8/29/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.frame.size.height = 0
        errorView.hidden = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        let cachedDataUrlString = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSURLRequest(URL: cachedDataUrlString)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = error
            self.refreshControl.endRefreshing()
            if let errorValue = errorValue {
                self.errorView.frame.size.height = 44
                self.errorView.hidden = false
                self.delay(2, closure: {
                    self.errorView.frame.size.height = 0
                    self.errorView.hidden = true
                })
            } else {
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary
                if let dictionary = dictionary {
                    self.movies = dictionary["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
        })
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh() {
        let cachedDataUrlString = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSURLRequest(URL: cachedDataUrlString)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = error
            self.refreshControl.endRefreshing()
            if let errorValue = errorValue {
                self.errorView.frame.size.height = 44
                self.errorView.hidden = false
                self.delay(2, closure: {
                    self.errorView.frame.size.height = 0
                    self.errorView.hidden = true
                })
            } else {
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary
                if let dictionary = dictionary {
                    self.movies = dictionary["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]

        cell.cellSpinnerView.hidden = true
        cell.posterSpinnerView.startAnimating()
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String

        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        let request = NSURLRequest(URL: url)

        cell.posterView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            cell.posterSpinnerView.hidden = true
            cell.posterView.image = image
        }) { (request, response, error) -> Void in
            println(error as! String)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
    }

}
