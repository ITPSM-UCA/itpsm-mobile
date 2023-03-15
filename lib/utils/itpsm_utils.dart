import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itpsm_mobile/utils/log/getLogger.dart';
import 'package:logger/logger.dart';
import 'package:yaml/yaml.dart';

class ItpsmUtils {
  static final Logger logger = getLogger();

  /// Gets the [property] from the itpsm_properties.yaml file using rootBundle
  /// 
  /// The [property] must have the following pattern: parentKey.childKey
  static dynamic getProperty(String property) async {
    final List<String> keys = property.split('.');

    try {
      final String file = await rootBundle.loadString('assets/properties/itpsm_properties.yaml');
      Map document = loadYaml(file) as Map;
           
      return _resolveProperty(keys, document);
    } catch (e) {
      logger.e('Error al cargar propiedad $property: ', e);
    }

    return null;
  }

  /// Gets the [property] from the itpsm_properties.yaml file using DefaultAssetBundle
  /// 
  /// The [property] must have the following pattern: parentKey.childKey
  static dynamic getPropertyWithContext(String property, BuildContext context) async {
    final List<String> keys = property.split('.');

    try {
      final String file = await DefaultAssetBundle.of(context).loadString('assets/properties/itpsm_properties.yaml');
      Map document = loadYaml(file) as Map;
           
      return _resolveProperty(keys, document);
    } catch (e) {
      logger.e('Error al cargar propiedad $property: ', e);
    }

    return null;
  }

  /// Searches for the last key child in [keys] inside the [document] yamlMap
  static dynamic _resolveProperty(List<String> keys, Map document) {
    final int length = keys.length;
    dynamic property = document[keys[0]];

    logger.d(property);
    for (var i = 1; i < length; i++) {
      property = property[keys[i]];
      logger.d(property);
    }
    
    return property; 
  }
}