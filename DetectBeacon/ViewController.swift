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
	@IBOutlet var rangeIndicator: UIView!
	
	var locationManager: CLLocationManager?

	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestAlwaysAuthorization()

		rangeIndicator.backgroundColor = .white
		rangeIndicator.alpha = 0.25
		rangeIndicator.layer.cornerRadius = 128
		// TODO: Add a gradient

		view.backgroundColor = .gray

	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if locationManager?.authorizationStatus == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}

	func startScanning() {

		typealias Beacon = (identifier: String, uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue)

		let beacons: [Beacon] =
		[
			(identifier: "Apple", uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456),
			(identifier: "TwoCanoes", uuid: UUID(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491")!, major: 123, minor: 456),
			(identifier: "Radius", uuid: UUID(uuidString: "52414449-5553-4E45-5457-4F524B53434F")!, major: 654, minor: 321),
		]

		for beacon in beacons {
			let constraint = CLBeaconIdentityConstraint(uuid: beacon.uuid, major: beacon.major, minor: beacon.minor)
			let region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: beacon.identifier)
			locationManager?.startMonitoring(for: region)
			locationManager?.startRangingBeacons(satisfying: constraint)
		}

	}

	func update(distance: CLProximity) {
		UIView.animate(withDuration: 1) {
			switch distance {
			case .far:
				self.view.backgroundColor = .blue
				self.distanceReading.text = "FAR"
				UIView.animate(withDuration: 1) {
					self.rangeIndicator.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
				}
			case .near:
				self.view.backgroundColor = .orange
				self.distanceReading.text = "NEAR"
				UIView.animate(withDuration: 1) {
					self.rangeIndicator.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
				}
			case .immediate:
				self.view.backgroundColor = .red
				self.distanceReading.text = "RIGHT HERE"
				UIView.animate(withDuration: 1) {
					self.rangeIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
				}
			 default:
				self.view.backgroundColor = .gray
				self.distanceReading.text = "UNKNOWN"
				UIView.animate(withDuration: 1) {
					self.rangeIndicator.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
				}
			}
		}
	}

	func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
		if let beacon = beacons.first {
			update(distance: beacon.proximity)
		}
	}

	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		let identifier = region.identifier
		regionLabel.text = identifier
		let ac = UIAlertController(title: "Beacon detected", message: "You entered the \(identifier) region.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}

	func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		update(distance: .unknown)
		regionLabel.text = "---"
	}

	func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
		if state == .inside {
			regionLabel.text = region.identifier
		}
	}
}
