import 'package:flutter/material.dart';
import '../../utils/math_utils.dart';

class EngineeringCalcScreen extends StatefulWidget {
  const EngineeringCalcScreen({super.key});

  @override
  State<EngineeringCalcScreen> createState() => _EngineeringCalcScreenState();
}

class _EngineeringCalcScreenState extends State<EngineeringCalcScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // -------------------- Controllers --------------------
  final TextEditingController _angleController = TextEditingController();

  final TextEditingController _massController = TextEditingController();
  final TextEditingController _accController = TextEditingController();
  final TextEditingController _energyMassController = TextEditingController();
  final TextEditingController _velocityController = TextEditingController();
  final TextEditingController _powerWorkController = TextEditingController();
  final TextEditingController _powerTimeController = TextEditingController();

  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();

  final TextEditingController _molesController = TextEditingController();
  final TextEditingController _volumeChemController = TextEditingController();
  final TextEditingController _hPlusController = TextEditingController();

  // -------------------- Values --------------------
  double _sin = 0, _cos = 0, _tan = 0;
  double _force = 0, _energy = 0, _power = 0;
  double _resistance = 0, _molarity = 0, _pH = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _angleController.dispose();
    _massController.dispose();
    _accController.dispose();
    _energyMassController.dispose();
    _velocityController.dispose();
    _powerWorkController.dispose();
    _powerTimeController.dispose();
    _voltageController.dispose();
    _currentController.dispose();
    _molesController.dispose();
    _volumeChemController.dispose();
    _hPlusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Calculator'),
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.yellow,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(
              child: Text(
                'Trigonometry',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text('Physics', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Electrical', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('Chemistry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _trigonometryTab(),
          _physicsTab(),
          _electricalTab(),
          _chemistryTab(),
        ],
      ),
    );
  }

  // ---------------- TRIGONOMETRY TAB ----------------
  Widget _trigonometryTab() {
    return _buildScrollableContainer(
      children: [
        _inputField(_angleController, 'Angle (degrees)'),
        _calcButton('Calculate', () {
          final angle = double.tryParse(_angleController.text) ?? 0;
          setState(() {
            _sin = MathUtils.sinDeg(angle);
            _cos = MathUtils.cosDeg(angle);
            _tan = MathUtils.tanDeg(angle);
          });
        }),
        _resultText(
          'Sin: ${_sin.toStringAsFixed(4)}\n'
          'Cos: ${_cos.toStringAsFixed(4)}\n'
          'Tan: ${_tan.toStringAsFixed(4)}',
        ),
      ],
    );
  }

  // ---------------- PHYSICS TAB ----------------
  Widget _physicsTab() {
    return _buildScrollableContainer(
      children: [
        _sectionTitle('Force = m × a'),
        _inputField(_massController, 'Mass (kg)'),
        _inputField(_accController, 'Acceleration (m/s²)'),
        _calcButton('Calculate Force', () {
          final m = double.tryParse(_massController.text) ?? 0;
          final a = double.tryParse(_accController.text) ?? 0;
          setState(() => _force = MathUtils.calculateForce(m, a));
        }),
        _resultText('Force: ${_force.toStringAsFixed(3)} N'),
        const Divider(),

        _sectionTitle('Kinetic Energy = ½ m v²'),
        _inputField(_energyMassController, 'Mass (kg)'),
        _inputField(_velocityController, 'Velocity (m/s)'),
        _calcButton('Calculate Energy', () {
          final m = double.tryParse(_energyMassController.text) ?? 0;
          final v = double.tryParse(_velocityController.text) ?? 0;
          setState(() => _energy = MathUtils.calculateKineticEnergy(m, v));
        }),
        _resultText('Energy: ${_energy.toStringAsFixed(3)} J'),
        const Divider(),

        _sectionTitle('Power = Work ÷ Time'),
        _inputField(_powerWorkController, 'Work (J)'),
        _inputField(_powerTimeController, 'Time (s)'),
        _calcButton('Calculate Power', () {
          final w = double.tryParse(_powerWorkController.text) ?? 0;
          final t = double.tryParse(_powerTimeController.text) ?? 1;
          setState(() => _power = MathUtils.calculatePower(w, t));
        }),
        _resultText('Power: ${_power.toStringAsFixed(3)} W'),
      ],
    );
  }

  // ---------------- ELECTRICAL TAB ----------------
  Widget _electricalTab() {
    return _buildScrollableContainer(
      children: [
        _sectionTitle('Ohm’s Law: R = V ÷ I'),
        _inputField(_voltageController, 'Voltage (V)'),
        _inputField(_currentController, 'Current (A)'),
        _calcButton('Calculate Resistance', () {
          final v = double.tryParse(_voltageController.text) ?? 0;
          final i = double.tryParse(_currentController.text) ?? 1;
          setState(() => _resistance = MathUtils.calculateResistance(v, i));
        }),
        _resultText('Resistance: ${_resistance.toStringAsFixed(3)} Ω'),
      ],
    );
  }

  // ---------------- CHEMISTRY TAB ----------------
  Widget _chemistryTab() {
    return _buildScrollableContainer(
      children: [
        _sectionTitle('Molarity = moles ÷ volume'),
        _inputField(_molesController, 'Moles'),
        _inputField(_volumeChemController, 'Volume (L)'),
        _calcButton('Calculate Molarity', () {
          final moles = double.tryParse(_molesController.text) ?? 0;
          final vol = double.tryParse(_volumeChemController.text) ?? 1;
          setState(() => _molarity = MathUtils.calculateMolarity(moles, vol));
        }),
        _resultText('Molarity: ${_molarity.toStringAsFixed(4)} M'),
        const Divider(),

        _sectionTitle('pH = -log [H⁺]'),
        _inputField(_hPlusController, 'H⁺ Concentration (mol/L)'),
        _calcButton('Calculate pH', () {
          final h = double.tryParse(_hPlusController.text) ?? 0;
          setState(() => _pH = MathUtils.calculatePH(h));
        }),
        _resultText('pH: ${_pH.toStringAsFixed(3)}'),
      ],
    );
  }

  // ------------------- REUSABLE WIDGETS -------------------
  Widget _buildScrollableContainer({required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...children, const SizedBox(height: 30)],
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget _calcButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }

  Widget _resultText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
