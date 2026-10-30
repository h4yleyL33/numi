import 'package:sembast_web/sembast_web.dart';

Future<Database> bukaDatabase([String nama = 'numi-v1']) =>
    databaseFactoryWeb.openDatabase(nama);
