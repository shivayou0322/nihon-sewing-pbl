class SuitItem {
  final String ticketNumber;
  final String imagePath;
  final String description;
  final String? processName; // Phase 2 拡張用

  const SuitItem({
    required this.ticketNumber,
    required this.imagePath,
    required this.description,
    this.processName,
  });

  factory SuitItem.fromJson(String ticketNumber, Map<String, dynamic> json) {
    return SuitItem(
      ticketNumber: ticketNumber,
      imagePath: json['image'] as String,
      description: json['description'] as String,
      processName: json['processName'] as String?,
    );
  }
}
