// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KelasModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KelasModelAdapter extends TypeAdapter<KelasModel> {
  @override
  final int typeId = 2;

  @override
  KelasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KelasModel(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as Map)?.cast<String, dynamic>(),
      fields[3] as String,
      (fields[4] as Map)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, KelasModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.jurusan)
      ..writeByte(1)
      ..write(obj.ketuaKelas)
      ..writeByte(2)
      ..write(obj.mataPelajaran)
      ..writeByte(3)
      ..write(obj.namaKelas)
      ..writeByte(4)
      ..write(obj.waliKelas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KelasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
