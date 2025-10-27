import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'dart:async';
import '../../controllers/auth_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final authController = Get.find<AuthController>();
  final Random _random = Random();
  Timer? _timer;

  // Datos simulados de sensores
  double _currentTemperature = 24.5;
  double _currentHumidity = 65.0;
  String _systemStatus = 'Óptimo';
  String _lastReading = 'hace 2 min';
  String _aiMode = 'Automático';
  double _averageTemperature = 23.8;
  double _averageHumidity = 63.5;
  double _yesterdayTempVariation = 0.7;
  double _yesterdayHumidVariation = -2.3;

  // Datos para los gráficos (últimas 24 horas)
  List<FlSpot> _temperatureData = [];
  List<FlSpot> _humidityData = [];

  @override
  void initState() {
    super.initState();
    _generateHistoricalData();
    _startSensorSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateHistoricalData() {
    final now = DateTime.now();
    _temperatureData = List.generate(24, (index) {
      final baseTemp = 24.0 + (_random.nextDouble() - 0.5) * 6;
      return FlSpot(index.toDouble(), baseTemp);
    });
    
    _humidityData = List.generate(24, (index) {
      final baseHumid = 65.0 + (_random.nextDouble() - 0.5) * 15;
      return FlSpot(index.toDouble(), baseHumid);
    });
  }

  void _startSensorSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        // Simular cambios de temperatura realistas
        final tempChange = (_random.nextDouble() - 0.5) * 2.0;
        _currentTemperature = (_currentTemperature + tempChange).clamp(18.0, 32.0);
        
        // Simular cambios de humedad realistas
        final humidChange = (_random.nextDouble() - 0.5) * 3.0;
        _currentHumidity = (_currentHumidity + humidChange).clamp(40.0, 85.0);
        
        // Actualizar estado del sistema
        if (_currentTemperature >= 22 && _currentTemperature <= 26 && 
            _currentHumidity >= 55 && _currentHumidity <= 75) {
          _systemStatus = 'Óptimo';
        } else if ((_currentTemperature >= 20 && _currentTemperature <= 28 && 
                   _currentHumidity >= 50 && _currentHumidity <= 80)) {
          _systemStatus = 'Alerta';
        } else {
          _systemStatus = 'Crítico';
        }

        // Actualizar última lectura
        _lastReading = 'hace ${_random.nextInt(3) + 1} min';

        // Actualizar gráficos (mover datos hacia la izquierda)
        _temperatureData.removeAt(0);
        _temperatureData.add(FlSpot(23, _currentTemperature));
        
        _humidityData.removeAt(0);
        _humidityData.add(FlSpot(23, _currentHumidity));

        // Actualizar datos promedios
        _averageTemperature = (_averageTemperature + (_random.nextDouble() - 0.5) * 0.2).clamp(20.0, 28.0);
        _averageHumidity = (_averageHumidity + (_random.nextDouble() - 0.5) * 1.5).clamp(50.0, 80.0);
        _yesterdayTempVariation = (_random.nextDouble() - 0.5) * 1.5;
        _yesterdayHumidVariation = (_random.nextDouble() - 0.5) * 4.0;
      });
    });
  }

  Color _getTemperatureColor() {
    if (_currentTemperature >= 22 && _currentTemperature <= 26) {
      return const Color(0xFF00BCD4); // Cyan para óptimo
    } else if (_currentTemperature >= 20 && _currentTemperature <= 28) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getHumidityColor() {
    if (_currentHumidity >= 55 && _currentHumidity <= 75) {
      return const Color(0xFF00BCD4); // Cyan para óptimo
    } else if (_currentHumidity >= 50 && _currentHumidity <= 80) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getStatusColor() {
    switch (_systemStatus) {
      case 'Óptimo':
        return const Color(0xFF00BCD4); // Cyan
      case 'Alerta':
        return Colors.orange;
      case 'Crítico':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getAiModeColor() {
    switch (_aiMode) {
      case 'Automático':
        return const Color(0xFF00BCD4); // Cyan
      case 'Manual':
        return Colors.blue;
      case 'Híbrido':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _changeAiMode(String mode) {
    setState(() {
      _aiMode = mode;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modo IA cambiado a: $mode'),
        backgroundColor: _getAiModeColor(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Invernadero Upc IA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _systemStatus,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              Get.offAllNamed('/login');
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            _buildHeader(),
            const SizedBox(height: 20),
            
            // Panel de sensores principal (Temperatura y Humedad)
            _buildSensorPanel(),
            const SizedBox(height: 20),
            
            // Gráficas de tendencias
            _buildTrendCharts(),
            const SizedBox(height: 20),
            
            // Estado del sistema IA
            _buildAiControls(),
            const SizedBox(height: 20),
            
            // Tarjetas informativas
            _buildInfoCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF26C6DA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.eco,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sistema de Monitoreo Inteligente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Última lectura: $_lastReading',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _systemStatus,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Encabezado
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sensors,
                  color: Color(0xFF00BCD4),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Datos de Sensores',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Grilla de sensores
          Row(
            children: [
              // Sensor de Temperatura
              Expanded(
                child: _buildSensorCard(
                  'Temperatura',
                  '${_currentTemperature.toStringAsFixed(1)}°C',
                  Icons.thermostat,
                  _getTemperatureColor(),
                  'Rango: 22-26°C',
                  18.0,
                  32.0,
                  _currentTemperature,
                ),
              ),
              const SizedBox(width: 16),
              // Sensor de Humedad
              Expanded(
                child: _buildSensorCard(
                  'Humedad',
                  '${_currentHumidity.toStringAsFixed(1)}%',
                  Icons.water_drop,
                  _getHumidityColor(),
                  'Rango: 55-75%',
                  40.0,
                  85.0,
                  _currentHumidity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String range,
    double min,
    double max,
    double current,
  ) {
    final percentage = ((current - min) / (max - min)).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              range,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCharts() {
    return Column(
      children: [
        // Gráfica de Temperatura
        _buildChart(
          'Temperatura (24h)',
          Icons.thermostat,
          _temperatureData,
          const Color(0xFF00BCD4),
          18.0,
          32.0,
          '°C',
        ),
        const SizedBox(height: 20),
        // Gráfica de Humedad
        _buildChart(
          'Humedad (24h)',
          Icons.water_drop,
          _humidityData,
          const Color(0xFF2196F3),
          40.0,
          85.0,
          '%',
        ),
      ],
    );
  }

  Widget _buildChart(
    String title,
    IconData icon,
    List<FlSpot> data,
    Color color,
    double minY,
    double maxY,
    String unit,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: (maxY - minY) / 5,
                  verticalInterval: 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 4,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('00:00', style: style);
                            break;
                          case 6:
                            text = const Text('06:00', style: style);
                            break;
                          case 12:
                            text = const Text('12:00', style: style);
                            break;
                          case 18:
                            text = const Text('18:00', style: style);
                            break;
                          case 23:
                            text = const Text('23:00', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (maxY - minY) / 4,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          '${value.toInt()}$unit',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                maxX: 23,
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.6),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.psychology,
                color: Color(0xFF00BCD4),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Control de IA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  'Automático',
                  Icons.auto_awesome,
                  _aiMode == 'Automático',
                  () => _changeAiMode('Automático'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeButton(
                  'Manual',
                  Icons.touch_app,
                  _aiMode == 'Manual',
                  () => _changeAiMode('Manual'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeButton(
                  'Híbrido',
                  Icons.blur_on,
                  _aiMode == 'Híbrido',
                  () => _changeAiMode('Híbrido'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? _getAiModeColor() : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _getAiModeColor() : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildInfoCard(
          'Temp Promedio',
          '${_averageTemperature.toStringAsFixed(1)}°C',
          Icons.thermostat_outlined,
          const Color(0xFF00BCD4),
        ),
        _buildInfoCard(
          'Var Temp vs Ayer',
          '${_yesterdayTempVariation > 0 ? '+' : ''}${_yesterdayTempVariation.toStringAsFixed(1)}°C',
          Icons.trending_up,
          _yesterdayTempVariation > 0 ? Colors.red : const Color(0xFF00BCD4),
        ),
        _buildInfoCard(
          'Humedad Promedio',
          '${_averageHumidity.toStringAsFixed(1)}%',
          Icons.water_drop,
          const Color(0xFF2196F3),
        ),
        _buildInfoCard(
          'Var Humedad vs Ayer',
          '${_yesterdayHumidVariation > 0 ? '+' : ''}${_yesterdayHumidVariation.toStringAsFixed(1)}%',
          Icons.trending_up,
          _yesterdayHumidVariation > 0 ? Colors.red : const Color(0xFF00BCD4),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}