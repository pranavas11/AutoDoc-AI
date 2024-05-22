import SwiftUI
import MapKit
import CoreLocation

/// `MKMapView` is a type that provides methods for creating and updating map views.
///
/// You can create a new `MKMapView` instance with a zero frame using the provided context. The context is the
/// environment in which the view is created.
///
/// You can also update an existing `MKMapView` with specified settings and add an annotation. The update function sets
/// the map type, enables zooming and scrolling, and disables rotation. If the map type is either `.hybridFlyover` or
/// `.satelliteFlyover` and the latitude and longitude are both 0, it sets the map region to the entire world.
///
/// If the latitude and longitude are not both 0, it creates a center location coordinate with the provided latitude and
/// longitude. It then creates a map region centered on this coordinate. The span of this region is determined by the
/// `delta` and `deltaUnit` parameters. If `deltaUnit` is "degrees", the span is created with `delta` as both the
/// latitude and longitude delta. Otherwise, the span is created with `delta` as both the latitudinal and longitudinal
/// meters.
///
/// After setting the map region, it creates an `MKPointAnnotation` with the center location coordinate and the provided
/// title and subtitle, and adds this annotation to the map view.
struct MapView: UIViewRepresentable {
    var mapType: MKMapType
    var latitude: Double
    var longitude: Double
    var delta: Double
    var deltaUnit: String
    var annotationTitle: String
    var annotationSubtitle: String

    /// Creates a new `MKMapView` instance with a zero frame.
    ///
    /// - parameter context: The context in which the view is created.
    /// - returns: A new `MKMapView` instance with a zero frame.
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }


    /// Updates the provided `MKMapView` with the specified settings and adds an annotation.
    ///
    /// - parameter view: The `MKMapView` to be updated.
    /// - parameter context: The context in which the update is occurring.
    ///
    /// This function first sets the map type and enables zooming and scrolling, but disables rotation. If the map type is
    /// either `.hybridFlyover` or `.satelliteFlyover` and the latitude and longitude are both 0, it sets the map region to
    /// the entire world.
    ///
    /// If the latitude and longitude are not both 0, it creates a center location coordinate with the provided latitude and
    /// longitude. It then creates a map region centered on this coordinate. The span of this region is determined by the
    /// `delta` and `deltaUnit` parameters. If `deltaUnit` is "degrees", the span is created with `delta` as both the
    /// latitude and longitude delta. Otherwise, the span is created with `delta` as both the latitudinal and longitudinal
    /// meters.
    ///
    /// After setting the map region, it creates an `MKPointAnnotation` with the center location coordinate and the provided
    /// title and subtitle, and adds this annotation to the map view.
    func updateUIView(_ view: MKMapView, context: Context) {

        view.mapType = mapType
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.isRotateEnabled = false

        if (mapType == .hybridFlyover || mapType == .satelliteFlyover) && latitude == 0 && longitude == 0 {


            let mapRegion = MKCoordinateRegion(.world)

            view.setRegion(mapRegion, animated: true)

            return
        }

        let centerLocationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        var mapRegion = MKCoordinateRegion()

        if deltaUnit == "degrees" {

            let mapSpan = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)

            mapRegion = MKCoordinateRegion(center: centerLocationCoordinate, span: mapSpan)

        } else {

            mapRegion = MKCoordinateRegion(center: centerLocationCoordinate, latitudinalMeters: delta, longitudinalMeters: delta)
        }

        view.setRegion(mapRegion, animated: true)

        let annotation = MKPointAnnotation()

        annotation.coordinate = centerLocationCoordinate
        annotation.title = annotationTitle
        annotation.subtitle = annotationSubtitle

        view.addAnnotation(annotation)
    }

}


