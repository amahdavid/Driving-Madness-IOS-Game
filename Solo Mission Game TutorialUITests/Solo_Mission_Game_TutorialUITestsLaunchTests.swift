//
//  Solo_Mission_Game_TutorialUITestsLaunchTests.swift
//  Solo Mission Game TutorialUITests
//
//  Created by David Chika Amah-Nnachi on 2024-03-18.
//

import XCTest

final class Solo_Mission_Game_TutorialUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
