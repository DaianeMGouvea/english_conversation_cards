// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationCardAdapter extends TypeAdapter<ConversationCard> {
  @override
  final int typeId = 1;

  @override
  ConversationCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationCard(
      id: fields[0] as String,
      phrase: fields[1] as String,
      category: fields[2] as CardCategory,
      isUsed: fields[3] as bool,
      translation: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ConversationCard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phrase)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.isUsed)
      ..writeByte(4)
      ..write(obj.translation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardCategoryAdapter extends TypeAdapter<CardCategory> {
  @override
  final int typeId = 0;

  @override
  CardCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardCategory.green;
      case 1:
        return CardCategory.blue;
      case 2:
        return CardCategory.orange;
      default:
        return CardCategory.green;
    }
  }

  @override
  void write(BinaryWriter writer, CardCategory obj) {
    switch (obj) {
      case CardCategory.green:
        writer.writeByte(0);
        break;
      case CardCategory.blue:
        writer.writeByte(1);
        break;
      case CardCategory.orange:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
