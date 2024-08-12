import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

import '../../../common/widgets/my_app_bar.dart';
import '../../../common/widgets/my_button.dart';
import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failures.dart';
import '../../navigation/pages/navigation.dart';
import '../bloc/vehicle_cubit.dart';

class ConnectPage extends StatefulWidget {
  static String routeName = '/connect';

  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  int? _connectingToIndex;
  StreamSubscription? _scanningStateSubscription;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    try {
      adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) {
          setState(() => _adapterState = current);

          if (current == BluetoothAdapterState.on) {
            _flutterBlueClassicPlugin.startScan();
          }
        }
      });
      _scanSubscription = _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) setState(() => _scanResults.add(device));
      });
      _scanningStateSubscription = _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        if (mounted) setState(() => _isScanning = isScanning);
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if (!mounted) return;

    setState(() {
      _adapterState = adapterState;
    });

    if (_adapterState == BluetoothAdapterState.on) _flutterBlueClassicPlugin.startScan();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> scanResults = _scanResults.toList();

    return Scaffold(
      appBar: MyAppBar(
        leading: true,
        title: Text(
          'Connect OBD2',
          style: AppText.pageTitleText.copyWith(color: AppColors.headingText),
        ),
      ),
      body: _adapterState == BluetoothAdapterState.on
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _headingText(),
                        const SizedBox(height: 24),
                        _availableDevices(scanResults),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: AppColors.background,
                  child: _continueWithSampleData(),
                ),
              ],
            )
          : _buildBluetoothOffScreen(),
    );
  }

  Widget _headingText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Searching for devices ...',
          style: AppText.headH2,
        ),
        Text(
          'Make sure your OBD2 scanner is ready and your Bluetooth is enabled',
          style: AppText.bodyS.copyWith(color: AppColors.bodyText),
        ),
      ],
    );
  }

  Widget _availableDevices(List<BluetoothDevice> scanResults) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available devices',
          style: AppText.headH5,
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: scanResults.length,
          itemBuilder: (context, index) {
            final result = scanResults[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.broken['airdrop']!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.placeholderText,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                title: Text(
                  result.name ?? "Unknown Device",
                  style: AppText.bodyM.copyWith(color: AppColors.bodyText),
                ),
                subtitle: Text(
                  result.address,
                  style:
                      AppText.bodyS.copyWith(color: AppColors.placeholderText),
                ),
                trailing: SvgPicture.asset(
                  AppIcons.broken['arrow-right']!,
                  colorFilter: const ColorFilter.mode(
                    AppColors.placeholderText,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () async {
                  BluetoothConnection? connection;
                  setState(() => _connectingToIndex = index);
                  try {
                    connection =
                        await _flutterBlueClassicPlugin.connect(result.address);
                    if (!this.context.mounted) return;
                    if (connection != null && connection.isConnected) {
                      if (mounted) setState(() => _connectingToIndex = null);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        NavigationPage.routeName,
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (mounted) setState(() => _connectingToIndex = null);
                    if (kDebugMode) print(e);
                    connection?.dispose();
                    ErrorHandler.handleError(context, ClientFailure('error', 'Error connecting to device'));
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _continueWithSampleData() {
    return BlocBuilder<VehicleCubit, Map<String, dynamic>?>(
      builder: (context, vehicleState) {
        return MyButton(
          type: 'secondary',
          text: 'Continue with Sample Data Instead',
          onPressed: () {
            context.read<VehicleCubit>().addSampleVehicle();
            Navigator.of(context).pushNamedAndRemoveUntil(
              NavigationPage.routeName,
              (route) => false,
            );
          },
        );
      },
    );
  }

  Widget _buildBluetoothOffScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bluetooth is turned off',
              style: AppText.headH2,
            ),
            const SizedBox(height: 16),
            MyButton(
              type: 'primary',
              text: 'Turn On Bluetooth',
              onPressed: () {
                _flutterBlueClassicPlugin.turnOn();
              },
            ),
          ],
        ),
      ),
    );
  }
}
