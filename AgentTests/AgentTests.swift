//
//  AgentTests.swift
//  AgentTests
//
//  Created by Christoffer Hallas on 6/2/14.
//  Copyright (c) 2014 Christoffer Hallas. All rights reserved.
//

import XCTest
import Agent

class AgentTests: XCTestCase {

  func waitFor (inout wait: Bool) {
    while (wait) {
      NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode,
        beforeDate: NSDate(timeIntervalSinceNow: 0.1))
    }
  }

  func testGetShouldSucceed () {
    var wait: Bool = true
    let done: Agent.Response = { (response: NSHTTPURLResponse?, _, error: NSError?) -> Void in
      XCTAssertNil(error)
      XCTAssertEqual(response!.statusCode, 200)
      wait = false
    }
    Agent.get("https://api.github.com", done: done)
    waitFor(&wait)
  }
  
  func testGetShouldSucceedWithJSON () {
    var wait: Bool = true
    let done: Agent.Response = { (response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
      XCTAssertNil(error)
      XCTAssertEqual(response!.statusCode, 200)
      let json = data as! Dictionary<String, String>
      XCTAssertEqual(json["current_user_url"]!, "https://api.github.com/user")
      wait = false
    }
    Agent.get("https://api.github.com/", done: done)
    waitFor(&wait)
}

  func testGetShouldFail () {
    var wait: Bool = true
    let done = { (_: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
      XCTAssertNotNil(error)
      wait = false
    }
    Agent.get("http://nope.example.com", done: done)
    waitFor(&wait)
  }

  func testPostShouldFail () {
    var wait: Bool = true
    let done = { (_: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
      XCTAssertNotNil(error)
      wait = false
    }
    Agent.post("http://nope.example.com", done: done)
    waitFor(&wait)
  }

  func testPutShouldFail () {
    var wait: Bool = true
    let done = { (_: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
      XCTAssertNotNil(error)
      wait = false
    }
    Agent.put("http://nope.example.com", done: done)
    waitFor(&wait)
  }
  
  func testShouldOverload () {
    var wait: Bool = true
    let done = { (_: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
      XCTAssertNotNil(error)
      wait = false
    }
    Agent.post("http://example.com", headers: [ "Header": "Value" ], data: [ "Key": "Value" ], done: done)
    waitFor(&wait)
  }

  func testShouldMethodChain () {
    var wait: Bool = true
    let done = { (_: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
      XCTAssertNotNil(error)
      wait = false
    }
    Agent.post("http://example.com")
      .send([ "Key": "Value" ])
      .end(done)
    waitFor(&wait)
  }

}
