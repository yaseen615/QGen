// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 0;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      id: fields[0] as String,
      content: fields[1] as String,
      subjectId: fields[2] as String,
      subjectName: fields[3] as String,
      chapterNumber: fields[4] as int,
      chapterName: fields[5] as String,
      questionType: fields[6] as String,
      difficulty: fields[7] as String,
      marks: fields[8] as int,
      options: (fields[9] as List?)?.cast<String>(),
      correctOptionIndex: fields[10] as int?,
      answer: fields[11] as String?,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.subjectId)
      ..writeByte(3)
      ..write(obj.subjectName)
      ..writeByte(4)
      ..write(obj.chapterNumber)
      ..writeByte(5)
      ..write(obj.chapterName)
      ..writeByte(6)
      ..write(obj.questionType)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.marks)
      ..writeByte(9)
      ..write(obj.options)
      ..writeByte(10)
      ..write(obj.correctOptionIndex)
      ..writeByte(11)
      ..write(obj.answer)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
