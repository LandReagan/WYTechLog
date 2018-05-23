import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: 'WY Techlog v0.2',
    home: new Home(),
  ));
}

class Home extends StatelessWidget {

  TechLogTable techlogtable = new TechLogTable();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('WY Techlog v0.2 alpha'),
        actions: <Widget>[
          new RaisedButton(
            child: const Text('RESET'),
          ),
        ],
      ),
      body: techlogtable,
      bottomNavigationBar: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Text(
          'Enter values in yellow and white boxes...\nAll calculations will be done automatically!',
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

class TechLogTable extends StatefulWidget {

  @override
  _TechlogTableState createState() => new _TechlogTableState();
}

class _TechlogTableState extends State<TechLogTable> {

  int _arrival_fuel;
  int _fuel_before;
  int _fuel_used;
  int _total_required;
  int _metered_fuel;
  double _sg;
  double _conversion_factor;
  double _metered_uplift;
  int _total_onboard;
  int _actual_uplift;
  double _discrepancy;

  void reset() {
    _arrival_fuel = null;
    _fuel_before = null;
    _fuel_used = null;
    _total_required = null;
    _metered_fuel = null;
    _sg = null;
    _conversion_factor = null;
    _metered_uplift = null;
    _total_onboard = null;
    _actual_uplift = null;
    _discrepancy = null;
  }

  void _calculate() {
    setState(() {
      if (_arrival_fuel != null && _fuel_before != null) {
        _fuel_used = _arrival_fuel - _fuel_before;
      }
      if (_sg != null && _sg != 0.0 && _sg < 1.0) {
        _conversion_factor = 1 / _sg;
      }
      if (_metered_fuel != null && _conversion_factor != null) {
        _metered_uplift = _metered_fuel / _conversion_factor;
      }
      if (_total_onboard != null && _fuel_before != null) {
        _actual_uplift = _total_onboard - _fuel_before;
      }
      if (_metered_uplift != null && _actual_uplift != null) {
        _discrepancy =
            (_metered_uplift - _actual_uplift) / _actual_uplift * 100;
      }
    });
  }

  void _update_arrival_fuel(String value) {
    _arrival_fuel = int.parse(value);
  }

  void _update_fuel_before(String value) {
    _fuel_before = int.parse(value);
  }

  void _update_total_required(String value) {
    _total_required = int.parse(value);
  }

  void _update_metered_fuel(String value) {
    _metered_fuel = int.parse(value);
  }

  void _update_sg(String value) {
    _sg = double.parse(value);
  }

  void _update_total_onboard(String value) {
    _total_onboard = int.parse(value);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _calculate,
      child: new ListView(
        children: <Widget>[
          new TechLogLine('ARRIVAL FUEL (KG)', 'A', _arrival_fuel,
              Colors.amberAccent, _update_arrival_fuel),
          new TechLogLine('FUEL FIG BEFORE REFUELING (KG)', 'B', _fuel_before,
              Colors.white, _update_fuel_before),
          new TechLogLine('FUEL USED ON GROUNG (KGs) (A-B)', 'C', _fuel_used,
              Colors.white30, null),
          new TechLogLine('TOTAL REQUIRED DEPARTURE FUEL (KGs)', 'D',
              _total_required, Colors.amberAccent, _update_total_required),
          new TechLogLine('METERED FUEL (LTs)', 'E', _metered_fuel,
              Colors.white, _update_metered_fuel),
          new TechLogLine('REFUELING S.G.', 'F', _sg, Colors.white, _update_sg),
          new TechLogLine('CONVERSION FACTOR', 'G', _conversion_factor,
              Colors.white30, null),
          new TechLogLine('METERED UPLIFT (KGs) (E:G)', 'H', _metered_uplift,
              Colors.white30, null),
          new TechLogLine('TOTAL ONBOARD (KGs) ECAM/EICAS', 'I', _total_onboard,
              Colors.white, _update_total_onboard),
          new TechLogLine(
              'ACTUAL UPLIFT (I-B)', 'J', _actual_uplift, Colors.white30, null),
          new TechLogLine('DISCREPANCY (H-J)/J X 100', 'K', _discrepancy,
              Colors.white30, null),
        ],
      ),
    );
  }
}

class TechLogLine extends StatelessWidget {

  TechLogLine(this.title, this.reference_letter, this.value, this.color,
      this.onNewValue);

  final String title;
  final String reference_letter;
  final value;
  final Color color;
  final onNewValue;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.grey,
        border: new Border.all(),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              child: new Text(title, textAlign: TextAlign.center),
            ),
            flex: 5,
          ),
          new Expanded(
            child: new Container(
              child: new Text(reference_letter, textAlign: TextAlign.center),
            ),
            flex: 1,
          ),
          new Expanded(
            child: TextField(
                controller: new TextEditingController(
                  text: value != null ? value.toString() : '',
                ),
                decoration: new InputDecoration(
                  filled: true,
                  fillColor: color,
                ),
                enabled: color == Colors.white30 ? false : true,
                onChanged: (text) {
                  onNewValue(text);
                }),
            flex: 4,
          ),
        ],
      ),
    );
  }
}
