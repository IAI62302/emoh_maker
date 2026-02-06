// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_date_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DueDateItemAdapter extends TypeAdapter<DueDateItem> {
  @override
  final int typeId = 2;

  @override
  DueDateItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DueDateItem(
      id: fields[0] as String,
      title: fields[1] as String,
      dueDate: fields[2] as DateTime,
      isDone: fields[3] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, DueDateItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dueDate)
      ..writeByte(3)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DueDateItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}