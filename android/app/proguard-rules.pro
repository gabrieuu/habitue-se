# Preserva os atributos de assinatura de classes genéricas
-keepattributes Signature

# Mantém a classe TypeToken do Gson para evitar erros de serialização
-keep class com.google.gson.reflect.TypeToken { *; }

# Mantém todas as classes do plugin FlutterLocalNotifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Mantém todas as classes da biblioteca Gson
-keep class com.google.gson.** { *; }