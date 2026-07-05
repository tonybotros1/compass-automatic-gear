import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class NotificationSoundService extends GetxService {
  DateTime? _lastPlayedAt;

  void playTaskNotification() {
    final now = DateTime.now();
    final lastPlayedAt = _lastPlayedAt;
    if (lastPlayedAt != null &&
        now.difference(lastPlayedAt) < const Duration(milliseconds: 900)) {
      return;
    }
    _lastPlayedAt = now;

    try {
      final audio = html.AudioElement()
        ..src = _notificationSoundDataUri
        ..volume = 0.35;
      audio.play().catchError((_) {});
    } catch (_) {
      // Browsers can block sounds before the first user interaction.
    }
  }
}

const String _notificationSoundDataUri =
    'data:audio/wav;base64,UklGRqQCAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YYACAACAgIGAfXt8goeHgHd0e4iPiXpucH+QlIdxZ3CImpeAZmF1k6OVdFtgf6GnjWZTZI6tp39WTm+ft6BuSFB/sbqTWj9ZlMC3f0Y7aavLrGg1QH/AzJhQMFCYzMCAPzNnr9CvZzM/gMDMmFAwUJjMwIA/M2ev0K9nMz9/wMyYUDBQmMzAgD8zZ6/Qr2czP4DAzJhQMFCYzMCAPzNnr9CvZzM/f8DMmFAwUJjMwIA/M2ev0K9nMz9/wMyYUDBQmMzAgD8zZ6/Qr2czP4DAzJhQMFCYzMCAPzNnr9CvZzM/f8DMmFAwUJjMwIA/M2ev0K9nMz9/wMyYUDBQmMzAgD8zZ6/Qr2czP3/AzJhQMFCYzMB/PzNnr9CvZzM/gMDMmFAwUJjMwIA/M2ev0K9nMz9/wMyYUDBQmMzAgD8zZ6/Qr2czP3/AzJhQMFCYzMB/PzNnr9CvZzM/f8DMmFAwUJjMwIA/M2ev0K9nMz9/wMyYUDBQmMzAgD8zZ6/Qr2czP3/AzJhQMFCYzMCAPzNnr9CvZzM/gMDMmFAwUJjMwIA/M2ev0K9nMz9/wMyYUDBQmMzAgD8zZ6/Qr2czP3/AzJhQMFCYzMCAPzNnr9CvZzM/f8DMmFAwUJjMwIA/M2ev0K9nMz9/wMuYUjJSl8i9gEM5aarIqmk8Rn+4wZVYPFiUvrSAS0Nspb6kbEVPf7C4kl1GXpG1rIBTTG+ftJ5wT1eAqK6OY1Bkjqukf1tWcpmqmHNZX4CfpYtpWmqLopyAZF91k6CSdmJnf5ebiG9kcIiYlIBsaXiNlox5bG9/j5KFdW52hY+MgHRye4eMh3x1d3+HiIJ7eHuChYR/fHx+gYKBf39/';
