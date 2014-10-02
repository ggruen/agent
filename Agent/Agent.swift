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

class Agent {

  typealias Headers = Dictionary<String, String>
  typealias Data = AnyObject!
  typealias Response = (NSHTTPURLResponse!, Data!, NSError!) -> Void

  /**
   * MARK: Members
   */

  var request: NSMutableURLRequest
  let queue = NSOperationQueue()

  /**
   * MARK: Initialize
   */

  init(method: String, url: String, headers: Headers?) {
    self.request = NSMutableURLRequest(URL: NSURL(string: url))
    self.request.HTTPMethod = method;
    if (headers != nil) {
      self.request.allHTTPHeaderFields = headers!
    }
  }

  /**
   * MARK: GET
   */

  class func get(url: String) -> Agent {
    return Agent(method: "GET", url: url, headers: nil)
  }

  class func get(url: String, headers: Headers) -> Agent {
    return Agent(method: "GET", url: url, headers: headers)
  }

  class func get(url: String, done: Response) -> Agent {
    return Agent.get(url).end(done)
  }

  class func get(url: String, headers: Headers, done: Response) -> Agent {
    return Agent.get(url, headers: headers).end(done)
  }

  /**
   * MARK: POST
   */

  class func post(url: String) -> Agent {
    return Agent(method: "POST", url: url, headers: nil)
  }

  class func post(url: String, headers: Headers) -> Agent {
    return Agent(method: "POST", url: url, headers: headers)
  }

  class func post(url: String, done: Response) -> Agent {
    return Agent.post(url).end(done)
  }

  class func post(url: String, headers: Headers, data: Data) -> Agent {
    return Agent.post(url, headers: headers).send(data)
  }

  class func post(url: String, data: Data) -> Agent {
    return Agent.post(url).send(data)
  }

  class func post(url: String, data: Data, done: Response) -> Agent {
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
  class func post(url: String, headers: Headers, data: Data, done: Response) -> Agent {
    return Agent.post(url, headers: headers, data: data).send(data).end(done)
  }

  /**
   * MARK: PUT
   */

  class func put(url: String) -> Agent {
    return Agent(method: "PUT", url: url, headers: nil)
  }

  class func put(url: String, headers: Headers) -> Agent {
    return Agent(method: "PUT", url: url, headers: headers)
  }

  class func put(url: String, done: Response) -> Agent {
    return Agent.put(url).end(done)
  }

  class func put(url: String, headers: Headers, data: Data) -> Agent {
      return Agent.put(url, headers: headers).send(data)
  }

  class func put(url: String, data: Data) -> Agent {
    return Agent.put(url).send(data)
  }

  class func put(url: String, data: Data, done: Response) -> Agent {
    return Agent.put(url, data: data).send(data).end(done)
  }

  class func put(url: String, headers: Headers, data: Data, done: Response) -> Agent {
    return Agent.put(url, headers: headers, data: data).send(data).end(done)
  }

  /**
   * MARK: DELETE
   */

  class func delete(url: String) -> Agent {
    return Agent(method: "DELETE", url: url, headers: nil)
  }

  class func delete(url: String, headers: Headers) -> Agent {
    return Agent(method: "DELETE", url: url, headers: headers)
  }

  class func delete(url: String, done: Response) -> Agent {
    return Agent.delete(url).end(done)
  }

  class func delete(url: String, headers: Headers, done: Response) -> Agent {
    return Agent.delete(url, headers: headers).end(done)
  }

  /**
   * MARK: Methods
   */

  func send(data: Data) -> Agent {
    var error: NSError?
    let json = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &error)
    self.set("Content-Type", value: "application/json")
    self.request.HTTPBody = json
    return self
  }

  func set(header: String, value: String) -> Agent {
    self.request.setValue(value, forHTTPHeaderField: header)
    return self
  }

    /**
        Parses the response from the server.  If the response's MIME type is "application/json", the response data is parsed as JSON using NSJSONSerialization.JSONObjectWithData.  The "done" handler is called with the response, the data, and an error object.
    */
    func end(done: Response) -> Agent {
        let completion = { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let res = response as NSHTTPURLResponse!
            if (error != nil) {
                done(res, data, error)
                return
            }
            var error: NSError?
            var contentType = response.MIMEType
            if (data != nil && contentType == "application/json") {
                var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
                done(res, json, error)
            } else {
                done(res, data, error)
            }
        }
        NSURLConnection.sendAsynchronousRequest(self.request, queue: self.queue, completionHandler: completion)
        return self
    }

}
