// How to use: Image.asset(AppIcons.bold['arrow-down']);

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
  };

  static final broken = {
    'airdrop': _getPath('airdrop', IconType.broken),
    'arrow-left': _getPath('arrow-left', IconType.broken),
    'arrow-right': _getPath('arrow-right', IconType.broken),
    'export': _getPath('export', IconType.broken),
    'eye-slash': _getPath('eye-slash', IconType.broken),
    'eye': _getPath('eye', IconType.broken),
    'forbidden': _getPath('forbidden-2', IconType.broken),
    'gallery': _getPath('gallery', IconType.broken),
    'google': _getPath('google', IconType.broken),
    'health': _getPath('health', IconType.broken),
    'home': _getPath('home', IconType.broken),
    'image': _getPath('image', IconType.broken),
    'messages': _getPath('messages-3', IconType.broken),
    'microphone': _getPath('microphone-2', IconType.broken),
    'rotate-right': _getPath('rotate-right', IconType.broken),
    'shield-tick': _getPath('shield-tick', IconType.broken),
    'user': _getPath('user', IconType.broken),
    'warning': _getPath('warning-2', IconType.broken),
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