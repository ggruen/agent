//
//  Agent.swift
//  Agent
//
//  Created by Christoffer Hallas on 6/2/14.
//  Copyright (c) 2014 Christoffer Hallas. All rights reserved.
//
// https://github.com/hallas/agent
//

import Foundation

public class Agent {

  public typealias Headers = Dictionary<String, String>
  public typealias Response = (NSHTTPURLResponse?, AnyObject?, NSError?) -> Void
  public typealias RawResponse = (NSHTTPURLResponse?, NSData?, NSError?) -> Void

  /**
   * MARK: Members
   */

  var base: NSURL?
  var headers: Dictionary<String, String>?
  var request: NSMutableURLRequest?
  let queue = NSOperationQueue()

  /**
   * MARK: Initialize
   */
  
  init(url: String, headers: Dictionary<String, String>?) {
    self.base = NSURL(string: url)
    self.headers = headers
  }
  
  convenience init(url: String) {
    self.init(url: url, headers: nil)
  }

  init(method: String, url: String, headers: Dictionary<String, String>?) {
    self.headers = headers
    self.request(method, path: url)
  }
  
  convenience init(method: String, url: String) {
    self.init(method: method, url: url, headers: nil)
  }
  
  /**
   * Request
   */
  
  func request(method: String, path: String) -> Agent {
    var u: NSURL
    if self.base != nil {
      u = self.base!.URLByAppendingPathComponent(path)
    } else {
      u = NSURL(string: path)!
    }

    self.request = NSMutableURLRequest(URL: u)
    self.request!.HTTPMethod = method
    
    if self.headers != nil {
      self.request!.allHTTPHeaderFields = self.headers
    }
    
    return self
  }

  /**
   * MARK: GET
   */

  public class func get(url: String) -> Agent {
    return Agent(method: "GET", url: url, headers: nil)
  }

  public class func get(url: String, headers: Headers) -> Agent {
    return Agent(method: "GET", url: url, headers: headers)
  }

  public class func get(url: String, done: Response) -> Agent {
    return Agent.get(url).end(done)
  }

  public class func get(url: String, headers: Headers, done: Response) -> Agent {
    return Agent.get(url, headers: headers).end(done)
  }
  
  public func get(url: String, done: Response) -> Agent {
    return self.request("GET", path: url).end(done)
  }

  /**
   * MARK: POST
   */

  public class func post(url: String) -> Agent {
    return Agent(method: "POST", url: url, headers: nil)
  }

  public class func post(url: String, headers: Headers) -> Agent {
    return Agent(method: "POST", url: url, headers: headers)
  }

  public class func post(url: String, done: Response) -> Agent {
    return Agent.post(url).end(done)
  }

  public class func post(url: String, headers: Headers, data: AnyObject) -> Agent {
    return Agent.post(url, headers: headers).send(data)
  }

  public class func post(url: String, data: AnyObject) -> Agent {
    return Agent.post(url).send(data)
  }

  public class func post(url: String, data: AnyObject, done: Response) -> Agent {
    return Agent.post(url, data: data).send(data).end(done)
  }

    /**
        Submits "data" to "url" with headers in "headers".  When done, calls "done".
    
        Example:
            var url: String = "http://some.api.com/"
            let req = Agent.post(url, data: dictResults, done: { (response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void in
                if (error == nil) {
                    // Process result.  If your result is JSON, it'll already be parsed via NSJSONSerialization.JSONObjectWithData.  If it's any other MIME type, it'll be exactly as the NSURLConnection.sendAsynchronousRequest call would return it.
                } else {
                    println("Error: \(error!.localizedDescription)")
                }
            })

    */
  public class func post(url: String, headers: Headers, data: AnyObject, done: Response) -> Agent {
    return Agent.post(url, headers: headers, data: data).send(data).end(done)
  }

  public func POST(url: String, data: AnyObject, done: Response) -> Agent {
    return self.request("POST", path: url).send(data).end(done)
  }

  /**
   * MARK: PUT
   */

  public class func put(url: String) -> Agent {
    return Agent(method: "PUT", url: url, headers: nil)
  }

  public class func put(url: String, headers: Headers) -> Agent {
    return Agent(method: "PUT", url: url, headers: headers)
  }

  public class func put(url: String, done: Response) -> Agent {
    return Agent.put(url).end(done)
  }

  public class func put(url: String, headers: Headers, data: AnyObject) -> Agent {
      return Agent.put(url, headers: headers).send(data)
  }

  public class func put(url: String, data: AnyObject) -> Agent {
    return Agent.put(url).send(data)
  }

  public class func put(url: String, data: AnyObject, done: Response) -> Agent {
    return Agent.put(url, data: data).send(data).end(done)
  }

  public class func put(url: String, headers: Headers, data: AnyObject, done: Response) -> Agent {
    return Agent.put(url, headers: headers, data: data).send(data).end(done)
  }
  
  public func PUT(url: String, data: AnyObject, done: Response) -> Agent {
    return self.request("PUT", path: url).send(data).end(done)
  }

  /**
   * MARK: DELETE
   */

  public class func delete(url: String) -> Agent {
    return Agent(method: "DELETE", url: url, headers: nil)
  }

  public class func delete(url: String, headers: Headers) -> Agent {
    return Agent(method: "DELETE", url: url, headers: headers)
  }

  public class func delete(url: String, done: Response) -> Agent {
    return Agent.delete(url).end(done)
  }

  public class func delete(url: String, headers: Headers, done: Response) -> Agent {
    return Agent.delete(url, headers: headers).end(done)
  }

  public func delete(url: String, done: Response) -> Agent {
    return self.request("DELETE", path: url).end(done)
  }

  /**
   * MARK: Methods
   */

  public func data(data: NSData?, mime: String) -> Agent {
    self.set("Content-Type", value: mime)
    self.request!.HTTPBody = data
    return self
  }
  
  public func send(data: AnyObject) -> Agent {
    var error: NSError?
    let json = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &error)
    return self.data(json, mime: "application/json")
  }

  public func set(header: String, value: String) -> Agent {
    self.request!.setValue(value, forHTTPHeaderField: header)
    return self
  }

    /**
        Parses the response from the server.  If the response's MIME type is "application/json", the response data is parsed as JSON using NSJSONSerialization.JSONObjectWithData.  The "done" handler is called with the response, the data, and an error object.
    */
  public func end(done: Response) -> Agent {
    let completion = { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      if error != .None {
        done(.None, data, error)
        return
      }
      var error: NSError?
      var json: AnyObject!
      if ( data != .None && response.MIMEType == "application/json") {
        json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
      }
      let res = response as! NSHTTPURLResponse
      done(res, json, error)
    }
    NSURLConnection.sendAsynchronousRequest(self.request!, queue: self.queue, completionHandler: completion)
    return self
  }
  
  public func raw(done: RawResponse) -> Agent {
    let completion = { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      if error != .None {
        done(.None, data, error)
        return
      }
      done(response as? NSHTTPURLResponse, data, error)
    }
    NSURLConnection.sendAsynchronousRequest(self.request!, queue: self.queue, completionHandler: completion)
    return self
  }

}
