// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IaModel {
  final String name;
  final String modelName;
  final String version;
  final String displayName;
  final String description;
  final int inputTokenLimit;
  final int outputTokenLimit;
  final List<dynamic> supportedGenerationMethods;

  IaModel({
    required this.name,
    required this.modelName,
    required this.version,
    required this.displayName,
    required this.description,
    required this.inputTokenLimit,
    required this.outputTokenLimit,
    required this.supportedGenerationMethods,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'version': version,
      'displayName': displayName,
      'description': description,
      'inputTokenLimit': inputTokenLimit,
      'outputTokenLimit': outputTokenLimit,
      'supportedGenerationMethods': supportedGenerationMethods,
    };
  }

  factory IaModel.fromMap(Map<String, dynamic> map) {
    String name = map['name'].toString();
    String modelName = name.split('/').last;
    String version = map['version'].toString();
    String displayName = map['displayName'].toString();
    String description = map['description'].toString();
    int inputTokenLimit = map['inputTokenLimit'] is int
        ? map['inputTokenLimit'] as int
        : int.parse(map['inputTokenLimit'].toString());
    int outputTokenLimit = map['outputTokenLimit'] is int
        ? map['outputTokenLimit'] as int
        : int.parse(map['outputTokenLimit'].toString());
    List<dynamic> supportedGenerationMethods = List<dynamic>.from(
      (map['supportedGenerationMethods'] as List<dynamic>),
    );
    return IaModel(
      name: name,
      modelName: modelName,
      version: version,
      displayName: displayName,
      description: description,
      inputTokenLimit: inputTokenLimit,
      outputTokenLimit: outputTokenLimit,
      supportedGenerationMethods: supportedGenerationMethods,
    );
  }

  String toJson() => json.encode(toMap());

  factory IaModel.fromJson(String source) =>
      IaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
