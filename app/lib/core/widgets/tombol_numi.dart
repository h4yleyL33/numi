import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'krayon.dart';

/// Tombol bertebal seperti tombol mainan: ada sisi bawah yang terlihat, dan
/// saat ditekan permukaannya turun menutupi sisi itu.
class TombolNumi extends StatefulWidget {
  const TombolNumi({
    super.key,
    required this.label,
    required this.onTap,
    this.warna = NumiWarna.cahaya,
    this.warnaTeks = NumiWarna.tinta,
    this.ikon,
    this.lebar,
    this.tinggi = 60,
  });

  final String label;
  final VoidCallback? onTap;
  final Color warna;
  final Color warnaTeks;
  final IconData? ikon;
  final double? lebar;
  final double tinggi;

  @override
  State<TombolNumi> createState() => _TombolNumiState();
}

class _TombolNumiState extends State<TombolNumi> {
  static const _tebal = 6.0;
  bool _ditekan = false;

  Color _gelapkan(Color c) => Color.lerp(c, Colors.black, 0.22)!;

  @override
  Widget build(BuildContext context) {
    final aktif = widget.onTap != null;
    if (widget.warna == NumiWarna.cahaya || widget.warna == NumiWarna.kartu) {
      return Opacity(
        opacity: aktif ? 1 : 0.58,
        child: DecoratedBox(
          decoration: kertasKrayon(
            widget.warna == NumiWarna.cahaya ? 'tombol-utama' : 'tombol-putih',
          ),
          child: TextButton(
            onPressed: widget.onTap,
            style: TextButton.styleFrom(
              minimumSize: Size(widget.lebar ?? 0, widget.tinggi + _tebal),
              foregroundColor: widget.warnaTeks,
              disabledForegroundColor: widget.warnaTeks,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Mali',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.ikon case final ikon?) ...[
                  Icon(ikon),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(widget.label, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final warna = aktif ? widget.warna : const Color(0xFFD9D6E4);
    final turun = _ditekan && aktif ? _tebal : 0.0;

    return Semantics(
      button: true,
      enabled: aktif,
      label: widget.label,
      child: GestureDetector(
        onTapDown: aktif ? (_) => setState(() => _ditekan = true) : null,
        onTapCancel: () => setState(() => _ditekan = false),
        onTapUp: aktif
            ? (_) {
                setState(() => _ditekan = false);
                widget.onTap!();
              }
            : null,
        child: SizedBox(
          width: widget.lebar,
          height: widget.tinggi + _tebal,
          child: Stack(
            children: [
              Positioned.fill(
                top: _tebal,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _gelapkan(warna),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 70),
                left: 0,
                right: 0,
                top: turun,
                height: widget.tinggi,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: warna,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.ikon != null) ...[
                          Icon(
                            widget.ikon,
                            color: aktif ? widget.warnaTeks : Colors.white,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                              color: aktif ? widget.warnaTeks : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
