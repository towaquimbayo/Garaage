// How to use:
// - SvgPicture.asset(AppIcons.bold['arrow-right']!);
// - SvgPicture.asset(AppIcons.broken['arrow-right']!);

enum IconType { bold, broken }

class AppIcons {
  static String _getPath(String name, IconType type) => _Icon(name, type).path;

  static final bold = {
    'arrow-down': _getPath('arrow-down', IconType.bold),
    'arrow-right': _getPath('arrow-right', IconType.bold),
    'direct-down': _getPath('direct-down', IconType.bold),
    'health': _getPath('health', IconType.bold),
    'home': _getPath('home', IconType.bold),
    'image': _getPath('image', IconType.bold),
    'messages': _getPath('messages-3', IconType.bold),
    'send': _getPath('send-2', IconType.bold),
    'forbidden': _getPath('forbidden-2', IconType.bold),
    'close-circle': _getPath('close-circle', IconType.bold),
  };

  static final broken = {
    'airdrop': _getPath('airdrop', IconType.broken),
    'arrow-left': _getPath('arrow-left', IconType.broken),
    'arrow-right': _getPath('arrow-right', IconType.broken),
    'battery': _getPath('battery-charging', IconType.broken),
    'chatbot': _getPath('device-message', IconType.broken),
    'coolant': _getPath('devices', IconType.broken),
    'drop': _getPath('drop', IconType.broken),
    'export': _getPath('export', IconType.broken),
    'eye-slash': _getPath('eye-slash', IconType.broken),
    'eye': _getPath('eye', IconType.broken),
    'forbidden': _getPath('forbidden-2', IconType.broken),
    'fuel': _getPath('gas-station', IconType.broken),
    'gallery': _getPath('gallery', IconType.broken),
    'google': _getPath('google', IconType.broken),
    'health': _getPath('health', IconType.broken),
    'home': _getPath('home', IconType.broken),
    'image': _getPath('image', IconType.broken),
    'logout': _getPath('logout', IconType.broken),
    'messages': _getPath('messages-3', IconType.broken),
    'microphone': _getPath('microphone-2', IconType.broken),
    'people': _getPath('people', IconType.broken),
    'rotate-right': _getPath('rotate-right', IconType.broken),
    'rpm': _getPath('radar', IconType.broken),
    'shield-tick': _getPath('shield-tick', IconType.broken),
    'speed': _getPath('speedometer', IconType.broken),
    'transmission': _getPath('data', IconType.broken),
    'user': _getPath('user', IconType.broken),
    'warning': _getPath('warning-2', IconType.broken),
    'camera': _getPath('camera', IconType.broken),
    'add': _getPath('add', IconType.broken),
  };
}

class _Icon {
  static const String basePath = 'assets/icons';
  static const String format = '.svg';

  final String name;
  final IconType type;

  _Icon(this.name, this.type);

  String get path => '$basePath/${type.name}/$name$format';
}
