// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 3;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      status: fields[3] as String,
      startDate: fields[4] as DateTime,
      expiryDate: fields[5] as DateTime,
      price: fields[6] as double,
      currency: fields[7] as String,
      paymentMethod: fields[8] as String,
      transactionId: fields[9] as String?,
      autoRenew: fields[10] as bool,
      nextBillingDate: fields[11] as DateTime?,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      features: (fields[14] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.expiryDate)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.paymentMethod)
      ..writeByte(9)
      ..write(obj.transactionId)
      ..writeByte(10)
      ..write(obj.autoRenew)
      ..writeByte(11)
      ..write(obj.nextBillingDate)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.features);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
