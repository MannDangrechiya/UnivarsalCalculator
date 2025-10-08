import 'package:flutter/material.dart';
import '../../utils/math_utils.dart';

class EngineeringCalcScreen extends StatefulWidget {
  const EngineeringCalcScreen({super.key});

  @override
  State<EngineeringCalcScreen> createState() => _EngineeringCalcScreenState();
}

class _EngineeringCalcScreenState extends State<EngineeringCalcScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Trigonometry
  final TextEditingController _angleController = TextEditingController();
  double _sin = 0, _cos = 0, _tan = 0;

  // Physics
  final TextEditingController _massController = TextEditingController();
  final TextEditingController _accController = TextEditingController();
  final TextEditingController _energyMassController = TextEditingController();
  final TextEditingController _velocityController = TextEditingController();
  final TextEditingController _powerWorkController = TextEditingController();
  final TextEditingController _powerTimeController = TextEditingController();
  double _force = 0, _energy = 0, _power = 0;

  // Electrical
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();
  double _resistance = 0;

  // Chemistry
  final TextEditingController _molesController = TextEditingController();
  final TextEditingController _volumeChemController = TextEditingController();
  final TextEditingController _hPlusController = TextEditingController();
  double _molarity = 0, _pH = 0;

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
    _resistanceController.dispose();
    _molesController.dispose();
    _volumeChemController.dispose();
    _hPlusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Calculator'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
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

  /// ----------------- TRIGONOMETRY -----------------
  Widget _trigonometryTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _angleController,
            decoration: const InputDecoration(
              labelText: 'Angle (degrees)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              double angle = double.tryParse(_angleController.text) ?? 0;
              setState(() {
                _sin = MathUtils.sinDeg(angle);
                _cos = MathUtils.cosDeg(angle);
                _tan = MathUtils.tanDeg(angle);
              });
            },
            child: const Text('Calculate'),
          ),
          const SizedBox(height: 20),
          Text(
            'Sin: $_sin, Cos: $_cos, Tan: $_tan',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// ----------------- PHYSICS -----------------
  Widget _physicsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Force = m * a
          TextField(
            controller: _massController,
            decoration: const InputDecoration(
              labelText: 'Mass (kg)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _accController,
            decoration: const InputDecoration(
              labelText: 'Acceleration (m/s²)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              double mass = double.tryParse(_massController.text) ?? 0;
              double acc = double.tryParse(_accController.text) ?? 0;
              setState(() => _force = MathUtils.calculateForce(mass, acc));
            },
            child: const Text('Calculate Force'),
          ),
          Text('Force: $_force N', style: const TextStyle(fontSize: 16)),
          const Divider(),

          // Energy = 0.5 * m * v²
          TextField(
            controller: _energyMassController,
            decoration: const InputDecoration(
              labelText: 'Mass (kg)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _velocityController,
            decoration: const InputDecoration(
              labelText: 'Velocity (m/s)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              double m = double.tryParse(_energyMassController.text) ?? 0;
              double v = double.tryParse(_velocityController.text) ?? 0;
              setState(() => _energy = MathUtils.calculateKineticEnergy(m, v));
            },
            child: const Text('Calculate Energy'),
          ),
          Text('Energy: $_energy J', style: const TextStyle(fontSize: 16)),
          const Divider(),

          // Power = Work / Time
          TextField(
            controller: _powerWorkController,
            decoration: const InputDecoration(
              labelText: 'Work (J)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _powerTimeController,
            decoration: const InputDecoration(
              labelText: 'Time (s)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              double work = double.tryParse(_powerWorkController.text) ?? 0;
              double time = double.tryParse(_powerTimeController.text) ?? 1;
              setState(() => _power = MathUtils.calculatePower(work, time));
            },
            child: const Text('Calculate Power'),
          ),
          Text('Power: $_power W', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// ----------------- ELECTRICAL -----------------
  Widget _electricalTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _voltageController,
            decoration: const InputDecoration(
              labelText: 'Voltage (V)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _currentController,
            decoration: const InputDecoration(
              labelText: 'Current (A)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              double voltage = double.tryParse(_voltageController.text) ?? 0;
              double current = double.tryParse(_currentController.text) ?? 1;
              setState(
                () => _resistance = MathUtils.calculateResistance(
                  voltage,
                  current,
                ),
              );
            },
            child: const Text('Calculate Resistance'),
          ),
          Text(
            'Resistance: $_resistance Ω',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// ----------------- CHEMISTRY -----------------
  Widget _chemistryTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _molesController,
            decoration: const InputDecoration(
              labelText: 'Moles',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _volumeChemController,
            decoration: const InputDecoration(
              labelText: 'Volume (L)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              double moles = double.tryParse(_molesController.text) ?? 0;
              double vol = double.tryParse(_volumeChemController.text) ?? 1;
              setState(
                () => _molarity = MathUtils.calculateMolarity(moles, vol),
              );
            },
            child: const Text('Calculate Molarity'),
          ),
          Text('Molarity: $_molarity M', style: const TextStyle(fontSize: 16)),
          const Divider(),
          TextField(
            controller: _hPlusController,
            decoration: const InputDecoration(
              labelText: 'H⁺ Concentration (mol/L)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              double h = double.tryParse(_hPlusController.text) ?? 0;
              setState(() => _pH = MathUtils.calculatePH(h));
            },
            child: const Text('Calculate pH'),
          ),
          Text('pH: $_pH', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
