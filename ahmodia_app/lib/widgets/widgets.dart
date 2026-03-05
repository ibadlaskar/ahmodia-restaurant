// lib/widgets/widgets.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ── APP BADGE ─────────────────────────────────────────────────
class AppBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const AppBadge({super.key, required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
    child: Text(label, style: GoogleFonts.nunito(
      fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
  );
}

// ── STATUS BADGE ─────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Color get _bg => switch (status) {
    'Delivered'        => AppColors.greenLight,
    'Confirmed'        => const Color(0xFFDBEAFE),
    'Pending'          => AppColors.saffronLight,
    'Preparing'        => const Color(0xFFFFF7ED),
    'Out for Delivery' => AppColors.saffronLight,
    _ => AppColors.xlgray,
  };

  Color get _fg => switch (status) {
    'Delivered'        => AppColors.green,
    'Confirmed'        => AppColors.blue,
    'Pending'          => AppColors.saffron,
    'Preparing'        => const Color(0xFFEA580C),
    'Out for Delivery' => AppColors.saffron,
    _ => AppColors.gray,
  };

  @override
  Widget build(BuildContext context) => AppBadge(label: status, bg: _bg, fg: _fg);
}

// ── SECTION TITLE ─────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
    child: Row(children: [
      Text(title, style: GoogleFonts.playfairDisplay(
        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.dark)),
      if (subtitle != null) ...[
        const SizedBox(width: 8),
        Text(subtitle!, style: GoogleFonts.nunito(
          fontSize: 12, color: AppColors.gray)),
      ],
    ]),
  );
}

// ── MENU ITEM COMBO CARD ──────────────────────────────────────
class ComboCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onAdd;
  const ComboCard({super.key, required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.cream3, width: 1.5),
      boxShadow: [BoxShadow(
        color: AppColors.green.withOpacity(0.05),
        blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(children: [
      Container(
        width: 60, height: 60,
        decoration: BoxDecoration(
          color: AppColors.cream2,
          borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 30))),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.name, style: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.dark)),
        const SizedBox(height: 3),
        Text(item.description, style: GoogleFonts.nunito(
          fontSize: 12, color: AppColors.gray),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        if (item.tags.isNotEmpty) Row(children: item.tags.map((t) =>
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.greenLight, borderRadius: BorderRadius.circular(99)),
            child: Text(t, style: GoogleFonts.nunito(
              fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.green)),
          )
        ).toList()),
      ])),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('₹${item.price.toStringAsFixed(0)}',
          style: GoogleFonts.playfairDisplay(
            fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.green)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.green, borderRadius: BorderRadius.circular(9)),
            child: Text('+ Add', style: GoogleFonts.nunito(
              fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.white)),
          ),
        ),
      ]),
    ]),
  );
}

// ── PACK CARD ─────────────────────────────────────────────────
class PackCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  const PackCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cream3, width: 1.5),
        boxShadow: [BoxShadow(
          color: AppColors.green.withOpacity(0.06),
          blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image area
        Container(
          height: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
          child: Stack(children: [
            Center(child: Text(item.emoji, style: const TextStyle(fontSize: 52))),
            if (item.isPopular) Positioned(
              top: 8, left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.saffron, borderRadius: BorderRadius.circular(99)),
                child: Text('🔥 Popular', style: GoogleFonts.nunito(
                  fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.white)),
              )),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name, style: GoogleFonts.nunito(
              fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.dark),
              maxLines: 2),
            const SizedBox(height: 2),
            Text(item.description, style: GoogleFonts.nunito(
              fontSize: 11, color: AppColors.gray), maxLines: 2),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('From ₹${item.halfPrice?.toStringAsFixed(0) ?? item.price.toStringAsFixed(0)}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.green)),
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: AppColors.green, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.add, color: AppColors.white, size: 18),
              ),
            ]),
          ]),
        ),
      ]),
    ),
  );
}

// ── ORDER MINI CARD ───────────────────────────────────────────
class OrderMiniCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  const OrderMiniCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cream3, width: 1.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(order.orderId, style: GoogleFonts.nunito(
            fontSize: 14, fontWeight: FontWeight.w800)),
          Text(order.createdAt.toString().substring(11, 16),
            style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
        ]),
        const SizedBox(height: 6),
        Text(
          order.items.map((i) => '${i['emoji'] ?? ''} ${i['name']}').join(' · '),
          style: GoogleFonts.nunito(fontSize: 13, color: AppColors.gray),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('₹${order.total.toStringAsFixed(0)}',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.green)),
          StatusBadge(status: order.status),
        ]),
      ]),
    ),
  );
}

// ── INFO ROW (profile) ────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;
  const InfoRow({super.key, required this.icon, required this.label,
    required this.value, this.onEdit});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: AppColors.greenLight, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.green, size: 18),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.nunito(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: AppColors.gray, letterSpacing: 0.5)),
        Text(value.isEmpty ? '—' : value,
          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600)),
      ])),
      if (onEdit != null) GestureDetector(
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.xlgray, borderRadius: BorderRadius.circular(8)),
          child: Text('Edit', style: GoogleFonts.nunito(
            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.gray)),
        ),
      ),
    ]),
  );
}

// ── LOADING SHIMMER ───────────────────────────────────────────
class ShimmerCard extends StatelessWidget {
  final double height;
  const ShimmerCard({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: AppColors.cream3,
      borderRadius: BorderRadius.circular(14),
    ),
  );
}
