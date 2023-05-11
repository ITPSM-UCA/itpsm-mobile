import 'dart:io';


/// Returns a [String] representation of the [name] file on the specific [directory]
String readFixture(String directory, String name) => File('test/fixtures/$directory/$name').readAsStringSync();