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
	@IBOutlet var regionLabel: UILabel!
	
	var locationManager: CLLocationManager?
	var beaconDetected = false

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
					startScanning()
				}
			}
		}
	}

	func startScanning() {
		let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
		// TODO: Deprecated
		let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

		locationManager?.startMonitoring(for: beaconRegion)
		// TODO: Deprecated
		locationManager?.startRangingBeacons(in: beaconRegion)
	}

	func update(distance: CLProximity) {
		UIView.animate(withDuration: 1) {
			switch distance {
			case .far:
				self.view.backgroundColor = .blue
				self.distanceReading.text = "FAR"
			case .near:
				self.view.backgroundColor = .orange
				self.distanceReading.text = "NEAR"
			case .immediate:
				self.view.backgroundColor = .red
				self.distanceReading.text = "RIGHT HERE"
			 default:
				self.view.backgroundColor = .gray
				self.distanceReading.text = "UNKNOWN"
			}
		}
	}

	// TODO: Deprecated
	func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		if let beacon = beacons.first {
			if !beaconDetected {
				beaconDetected = true
				let ac = UIAlertController(title: "Beacon detected", message: nil, preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "OK", style: .default))
				present(ac, animated: true)
			}
			update(distance: beacon.proximity)
		} else {
			beaconDetected = false
			update(distance: .unknown)
		}
	}

}
