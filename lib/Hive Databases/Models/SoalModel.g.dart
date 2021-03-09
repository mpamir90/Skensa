// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SoalModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoalModelAdapter extends TypeAdapter<SoalModel> {
  @override
  final int typeId = 1;

  @override
  SoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoalModel(
      fields[0] as String,
      (fields[1] as Map)?.cast<String, dynamic>(),
      (fields[2] as List)?.cast<dynamic>(),
      fields[3] as String,
      (fields[4] as List)?.cast<dynamic>(),
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SoalModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.namaTugas)
      ..writeByte(1)
      ..write(obj.guru)
      ..writeByte(2)
      ..write(obj.kelas)
      ..writeByte(3)
      ..write(obj.namaMataPelajaran)
      ..writeByte(4)
      ..write(obj.soal)
      ..writeByte(5)
      ..write(obj.tipe)
      ..writeByte(6)
      ..write(obj.waktuKuis)
      ..writeByte(7)
      ..write(obj.idSoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
