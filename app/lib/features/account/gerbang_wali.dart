import 'dart:math';

import 'package:flutter/material.dart';

/// Pembatas interaksi anak, bukan autentikasi pengganti akun Google.
Future<bool> bukaGerbangWali(BuildContext context) async {
  final acak = Random();
  final a = 20 + acak.nextInt(40);
  final b = 20 + acak.nextInt(40);
  return await showDialog<bool>(
        context: context,
        builder: (_) => _GerbangWali(a: a, b: b),
      ) ??
      false;
}

class _GerbangWali extends StatefulWidget {
  const _GerbangWali({required this.a, required this.b});
  final int a, b;
  @override
  State<_GerbangWali> createState() => _GerbangWaliState();
}

class _GerbangWaliState extends State<_GerbangWali> {
  String _jawaban = '';
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Untuk ayah, ibu, atau wali'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${widget.a} + ${widget.b} = ?',
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.number,
          maxLength: 3,
          decoration: const InputDecoration(labelText: 'Jawaban wali'),
          onChanged: (value) => setState(() => _jawaban = value),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Kembali'),
      ),
      TextButton(
        onPressed: int.tryParse(_jawaban) == widget.a + widget.b
            ? () => Navigator.pop(context, true)
            : null,
        child: const Text('Buka ruang wali'),
      ),
    ],
  );
}
