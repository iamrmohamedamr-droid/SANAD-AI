/// Contract sketch for replacing the local demo assistant with a secure backend.
/// Keep provider API keys on the server, never in the Flutter application.
abstract class SanadAssistantService {
  Future<String> sendMessage(String message);
  Future<String> describeImage(String imagePath, {String? question});
}
