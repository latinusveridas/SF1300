
import UIKit
import MapKit

// need async + network connection
// On recupere les coordinates de ? et on on fait un reverse GeoCoding

/*dictionary GeocoderReverseLookupOptions {
    String language;
}; */

let optionsLookup: GeocoderReverseLookupOptions = [:]
optionsLookup.language = "FR-fr"

// Create Object
let geoCoder = new mapkit.Geocoder(optional GeocoderConstructorOptions options);
geoCoder = geoCoder(optionsLookup)


