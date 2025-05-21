import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int id;
  final String name;
  final String phone;
  final double previousDue;

const Customer({
  required this.id,
  required this.name,
  required this.phone,
  required this.previousDue, });

@override List<Object?> get props => [id, name, phone, previousDue]; }