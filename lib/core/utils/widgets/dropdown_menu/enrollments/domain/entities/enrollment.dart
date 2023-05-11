import 'package:equatable/equatable.dart';

abstract class Enrollment extends Equatable {
  final int id;
  final int code;
  final int year;
  final String status;

  const Enrollment({
    required this.id, 
    required this.code, 
    required this.year, 
    required this.status
  }); 

  @override
  List<Object> get props => [id, code, year, status];
}