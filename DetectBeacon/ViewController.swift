//
//  ViewController.swift
//  DetectBeacon
//
//  Created by Paul Richardson on 31/05/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet var distanceReading: UILabel!

	var locationManager: CLLocationManager?

	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestAlwaysAuthorization()

		view.backgroundColor = .gray

	}

	// TODO: this delegate method is deprecated.
	// convert to func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					// do stuff
				}
			}
		}
	}

}

