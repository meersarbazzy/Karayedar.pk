import 'package:karayedar_pk/models/property.dart';

List<Property> searchAndFilterProperties(
    List<Property> properties, String searchTerm, String selectedType, String selectedMeasurementUnit, double minPrice, double maxPrice) {
  
  return properties.where((property) {
    return (searchTerm.isEmpty || property.type.contains(searchTerm)) &&
           (selectedType.isEmpty || property.type == selectedType) &&
           (selectedMeasurementUnit.isEmpty || property.measurementUnit == selectedMeasurementUnit) &&
           (property.price >= minPrice && property.price <= maxPrice);
  }).toList();
}
