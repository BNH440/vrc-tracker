import 'package:hive/hive.dart';

part 'Event.g.dart';

@HiveType(typeId: 4)
class Event extends HiveObject {
  Event({
    required this.id,
    required this.name,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime lastUpdated = DateTime.now();
}
