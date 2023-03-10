import 'types.dart' show MetadataEnum, MetadataV12;

class RuntimeConfiguration {
  factory RuntimeConfiguration() =>_getInstance();

  MetadataEnum _runtimeMetadata;
  static RuntimeConfiguration _instance;
  static RuntimeConfiguration _getInstance() {
    if (_instance == null) {
      _instance = new RuntimeConfiguration._internal();
    }
    return _instance;
  }

  RuntimeConfiguration._internal();


  registMetadata(MetadataEnum metadata) {
    _runtimeMetadata = metadata;
  }

  MetadataEnum get runtimeMetadata => _runtimeMetadata;

  bool get isV12OrLater => runtimeMetadata.obj is MetadataV12;
}