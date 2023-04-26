import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String title;
  final String cause;
  
  const Failure({required this.title, required this.cause});
  
  @override
  List<Object> get props => [];
}