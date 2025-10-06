import 'package:drift/drift.dart';

class Locations extends Table {
  IntColumn get id => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get type => text().nullable()();
  TextColumn get dimension => text().nullable()();
  TextColumn get url => text().unique()();
}
