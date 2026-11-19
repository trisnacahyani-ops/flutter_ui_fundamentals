import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> securityTest({
  required int courseIdMilikUserA,
  required String uuidUserA,
}) async {
  final client = Supabase.instance.client;

  debugPrint('===== SECURITY TEST PRAKTIK 6 =====');
  debugPrint('Pengujian dilakukan menggunakan akun User B');

  // 1. User B mencoba mengubah data milik User A.
  try {
    final updated = await client
        .from('courses')
        .update({'title': 'DIUBAH OLEH USER B'})
        .eq('id', courseIdMilikUserA)
        .select('id');

    debugPrint(
      updated.isEmpty
          ? '[PASS] UPDATE ditolak oleh RLS'
          : '[FAIL] User B berhasil mengubah data User A',
    );
  } on PostgrestException catch (e) {
    debugPrint('[PASS] UPDATE ditolak: ${e.code} - ${e.message}');
  }

  // 2. User B mencoba menghapus data milik User A.
  try {
    final deleted = await client
        .from('courses')
        .delete()
        .eq('id', courseIdMilikUserA)
        .select('id');

    debugPrint(
      deleted.isEmpty
          ? '[PASS] DELETE ditolak oleh RLS'
          : '[FAIL] User B berhasil menghapus data User A',
    );
  } on PostgrestException catch (e) {
    debugPrint('[PASS] DELETE ditolak: ${e.code} - ${e.message}');
  }

  // 3. User B mencoba INSERT dengan owner_id milik User A.
  try {
    await client.from('courses').insert({
      'code': 'SEC-${DateTime.now().microsecondsSinceEpoch}',
      'title': 'Kursus Palsu',
      'credits': 2,
      'status': 'planned',
      'owner_id': uuidUserA,
    });

    debugPrint('[FAIL] INSERT atas nama User A berhasil');
  } on PostgrestException catch (e) {
    debugPrint('[PASS] INSERT ditolak: ${e.code} - ${e.message}');
  }

  debugPrint('===== SECURITY TEST SELESAI =====');
}
