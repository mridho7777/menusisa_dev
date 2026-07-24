import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/notifikasi_controller.dart';
import '../widgets/notifikasi_widget.dart';

// Supabase Integration:
// Halaman notifikasi ini akan menampilkan data dari Supabase 'notifications' table.
// realtime subscription:
// supabase.channel('public:notifications').onPostgresChanges(event: PostgresChangeEvent.all, ...).subscribe();

class NotifikasiView extends StatelessWidget {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantNotifikasiController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
            ),
          );
        }
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifikasi',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),
              NotifikasiWidget(controller: controller, data: null),
            ],
          ),
        );
      },
    );
  }
}
