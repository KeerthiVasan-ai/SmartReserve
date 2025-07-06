class ServerDetails {
  final bool isAppUnderMaintenance;
  final String version;

  ServerDetails({
    required this.isAppUnderMaintenance,
    required this.version,
  });

  factory ServerDetails.fromMap(Map<String, dynamic> map) {
    return ServerDetails(
      isAppUnderMaintenance: map['isAppUnderMaintenance'] ?? false,
      version: map['version'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAppUnderMaintenance': isAppUnderMaintenance,
      'version': version,
    };
  }
}
