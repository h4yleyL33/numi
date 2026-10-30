import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> bukaDatabase([String nama = 'numi-v1']) async {
  final direktori = await getApplicationSupportDirectory();
  await direktori.create(recursive: true);
  return databaseFactoryIo.openDatabase(p.join(direktori.path, '$nama.db'));
}
