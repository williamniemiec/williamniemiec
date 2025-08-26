// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MembershipAdapter extends TypeAdapter<Membership> {
  @override
  final int typeId = 6;

  @override
  Membership read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Membership(
      id: fields[0] as String,
      userId: fields[1] as String,
      plan: fields[2] as MembershipPlan,
      status: fields[3] as MembershipStatus,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime?,
      nextBillingDate: fields[6] as DateTime,
      monthlyFee: fields[7] as double,
      paymentMethod: fields[8] as PaymentMethod,
      cardLastFour: fields[9] as String?,
      outstandingBalance: fields[10] as double,
      includedLocations: (fields[11] as List).cast<String>(),
      guestPassesPerMonth: fields[12] as int,
      hasPersonalTraining: fields[13] as bool,
      hasGroupClasses: fields[14] as bool,
      hasNutritionConsultation: fields[15] as bool,
      freezeStartDate: fields[16] as DateTime?,
      freezeEndDate: fields[17] as DateTime?,
      transactionHistory: (fields[18] as List).cast<Transaction>(),
    );
  }

  @override
  void write(BinaryWriter writer, Membership obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.plan)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.nextBillingDate)
      ..writeByte(7)
      ..write(obj.monthlyFee)
      ..writeByte(8)
      ..write(obj.paymentMethod)
      ..writeByte(9)
      ..write(obj.cardLastFour)
      ..writeByte(10)
      ..write(obj.outstandingBalance)
      ..writeByte(11)
      ..write(obj.includedLocations)
      ..writeByte(12)
      ..write(obj.guestPassesPerMonth)
      ..writeByte(13)
      ..write(obj.hasPersonalTraining)
      ..writeByte(14)
      ..write(obj.hasGroupClasses)
      ..writeByte(15)
      ..write(obj.hasNutritionConsultation)
      ..writeByte(16)
      ..write(obj.freezeStartDate)
      ..writeByte(17)
      ..write(obj.freezeEndDate)
      ..writeByte(18)
      ..write(obj.transactionHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembershipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 10;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      amount: fields[2] as double,
      type: fields[3] as TransactionType,
      status: fields[4] as TransactionStatus,
      description: fields[5] as String,
      paymentMethodUsed: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.paymentMethodUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MembershipPlanAdapter extends TypeAdapter<MembershipPlan> {
  @override
  final int typeId = 7;

  @override
  MembershipPlan read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MembershipPlan.basic;
      case 1:
        return MembershipPlan.premium;
      case 2:
        return MembershipPlan.vip;
      default:
        return MembershipPlan.basic;
    }
  }

  @override
  void write(BinaryWriter writer, MembershipPlan obj) {
    switch (obj) {
      case MembershipPlan.basic:
        writer.writeByte(0);
        break;
      case MembershipPlan.premium:
        writer.writeByte(1);
        break;
      case MembershipPlan.vip:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembershipPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MembershipStatusAdapter extends TypeAdapter<MembershipStatus> {
  @override
  final int typeId = 8;

  @override
  MembershipStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MembershipStatus.active;
      case 1:
        return MembershipStatus.frozen;
      case 2:
        return MembershipStatus.cancelled;
      case 3:
        return MembershipStatus.pastDue;
      case 4:
        return MembershipStatus.suspended;
      default:
        return MembershipStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, MembershipStatus obj) {
    switch (obj) {
      case MembershipStatus.active:
        writer.writeByte(0);
        break;
      case MembershipStatus.frozen:
        writer.writeByte(1);
        break;
      case MembershipStatus.cancelled:
        writer.writeByte(2);
        break;
      case MembershipStatus.pastDue:
        writer.writeByte(3);
        break;
      case MembershipStatus.suspended:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembershipStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentMethodAdapter extends TypeAdapter<PaymentMethod> {
  @override
  final int typeId = 9;

  @override
  PaymentMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentMethod.creditCard;
      case 1:
        return PaymentMethod.debitCard;
      case 2:
        return PaymentMethod.bankTransfer;
      case 3:
        return PaymentMethod.paypal;
      default:
        return PaymentMethod.creditCard;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentMethod obj) {
    switch (obj) {
      case PaymentMethod.creditCard:
        writer.writeByte(0);
        break;
      case PaymentMethod.debitCard:
        writer.writeByte(1);
        break;
      case PaymentMethod.bankTransfer:
        writer.writeByte(2);
        break;
      case PaymentMethod.paypal:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 11;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.payment;
      case 1:
        return TransactionType.refund;
      case 2:
        return TransactionType.fee;
      case 3:
        return TransactionType.adjustment;
      default:
        return TransactionType.payment;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.payment:
        writer.writeByte(0);
        break;
      case TransactionType.refund:
        writer.writeByte(1);
        break;
      case TransactionType.fee:
        writer.writeByte(2);
        break;
      case TransactionType.adjustment:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionStatusAdapter extends TypeAdapter<TransactionStatus> {
  @override
  final int typeId = 12;

  @override
  TransactionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionStatus.pending;
      case 1:
        return TransactionStatus.completed;
      case 2:
        return TransactionStatus.failed;
      case 3:
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionStatus obj) {
    switch (obj) {
      case TransactionStatus.pending:
        writer.writeByte(0);
        break;
      case TransactionStatus.completed:
        writer.writeByte(1);
        break;
      case TransactionStatus.failed:
        writer.writeByte(2);
        break;
      case TransactionStatus.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
