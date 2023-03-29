import 'dart:io';

String readFixture(String directory, String name) => File('test/fixtures/$directory/$name').readAsStringSync();