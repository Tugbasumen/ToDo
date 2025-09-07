import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:not/presentation/common/custom_button.dart';
import 'package:not/presentation/common/custom_snackbar.dart';
import 'package:not/presentation/features/auth/providers/auth_provider.dart';

class AyarlarScreen extends ConsumerWidget {
  const AyarlarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text("Hoşgeldin ${user.email}"),
              const SizedBox(height: 20),

              // CustomButton kullanıldı
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  text: "Çıkış Yap",
                  onPressed: () async {
                    try {
                      await ref.read(authRepositoryProvider).logout();

                      if (context.mounted) {
                        CustomSnackbar.show(
                          context,
                          message: "Başarıyla çıkış yapıldı!",
                          type: SnackbarType.success,
                        );

                        context.go('/login');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        CustomSnackbar.show(
                          context,
                          message: "Çıkış yapılırken hata: $e",
                          type: SnackbarType.error,
                        );
                      }
                    }
                  },
                  type: ButtonType.primary,
                ),
              ),
            ] else
              const Text("Giriş yapılmamış"),
          ],
        ),
      ),
    );
  }
}
