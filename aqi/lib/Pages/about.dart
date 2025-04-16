import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final PageController _descController = PageController();
  final PageController _sensorController = PageController();
  final PageController _softwareController = PageController();
  final PageController _hardwareController = PageController();
  int _currentDescPage = 0;
  int _currentSensorPage = 0;

  final List<String> descriptions = [
    "This is an innovative app built by B-Tech students. It focuses on sustainability and technology. Our team worked hard to integrate new solutions.",
    "We have used multiple sensors, including:\n"
        "- BMP280 (Pressure, Temperature, and Humidity Sensor)\n"
        "- MICS-6814 (Gas Sensor)\n"
        "- ESP-32 (Microcontroller)\n"
        "- LoRa module (for data transfer).",
    "BMP280 is a high-precision environmental sensor designed to measure temperature, pressure, and humidity in a single compact module, making it highly efficient for IoT and weather monitoring applications.\n\n"
        "**Advantages:**\n"
        "Low power consumption\n"
        "Factory-calibrated for long-term stability\n"
        "More resistant to environmental factors",
    "MICS-6814 is a compact multi-gas sensor designed to detect various air pollutants. Detected gases include CO, NO2, NH3, and some volatile gases.\n\n"
        "**Advantages:**\n"
        "Multi-gas detection in a single sensor\n"
        "Compact and low power consumption\n"
        "High sensitivity and fast response",
    "LoRa (Long Range) is a wireless communication technology designed for long-range, low-power data transmission. It is widely used in IoT applications such as remote monitoring, smart agriculture, environmental sensing, and industrial automation.\n\n"
        "**Advantages:**\n"
        "Long-range communication\n"
        "Low power consumption\n"
        "Highly secure encryption",
    "ESP-32 is a powerful, low-cost, and versatile microcontroller with built-in WiFi and Bluetooth capabilities. It is widely used in IoT applications, smart home automation, robotics, and industrial control systems.\n\n"
        "**Advantages:**\n"
        "Integrated WiFi & Bluetooth\n"
        "Low power consumption\n"
        "Multiple sensors support & Cost-effective"
  ];

  final List<Map<String, String>> sensorData = [
    {"image": "assets/bme280.png", "name": "BMP280 Sensor"},
    {"image": "assets/mics6814.png", "name": "MICS-6814 Gas Sensor"},
    {"image": "assets/esp32.png", "name": "ESP-32 Microcontroller"},
    {"image": "assets/lora.png", "name": "LoRa Module"},
  ];

  final List<Student> softwareTeam = [
    Student(name: "Ch.Bhanu Prakash", image: "assets/software-1.png"),
    Student(name: "G.Arya Venkata Sai", image: "assets/software-2.png"),
    Student(name: "B.Charan Tej", image: "assets/software-3.png"),
    Student(name: "B.Sri Ram", image: "assets/software-4.png"),
    Student(name: "N.Venu Madhav", image: "assets/software-5.png"),
    Student(name: "B.Nishanth", image: "assets/software-6.png"),
    Student(name: "J.Lohith", image: "assets/software-7.png"),
    Student(name: "M.Rohith", image: "assets/software-8.png"),
    Student(name: "K.Veera Venkatesh", image: "assets/software-9.png")
  ];

  final List<Student> hardwareTeam = [
    Student(name: "P.Sushanth", image: "assets/hardware-1.png"),
    Student(name: "Ch.Surendra", image: "assets/hardware-2.png"),
    Student(name: "K.Uma Mahesh", image: "assets/hardware-3.png"),
    Student(name: "P.Bhuvanesh", image: "assets/hardware-4.png"),
    Student(name: "P.Sujan", image: "assets/hardware-5.png"),
    Student(name: "K.Satwik", image: "assets/hardware-6.png"),
    Student(name: "Ch.Roshan Kumar", image: "assets/hardware-7.png"),
    Student(name: "D.Karthik Raju", image: "assets/hardware-8.png"),
  ];

  @override
  void initState() {
    super.initState();
    _descController.addListener(() {
      if (_descController.page!.round() != _currentDescPage) {
        setState(() {
          _currentDescPage = _descController.page!.round();
        });
      }
    });
    _sensorController.addListener(() {
      if (_sensorController.page!.round() != _currentSensorPage) {
        setState(() {
          _currentSensorPage = _sensorController.page!.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "About Air-Index",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/nature_background.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9),
              BlendMode.lighten,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: kToolbarHeight + 20),
                
                // App Logo & Name with 3D effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shadow for 3D effect
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                    ),
                    // Main logo
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF81C784), Color(0xFF43A047)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/app_logo.jpg"),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                
                // App Name with Nature Theme
                Text(
                  "Air-Index",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF81C784)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.green.withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Clean Air, Healthier Planet",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 25),

                // Description Slideshow with leaf-styled cards
                Container(
                  height: 220,
                  child: PageView.builder(
                    controller: _descController,
                    itemCount: descriptions.length,
                    itemBuilder: (context, index) {
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _currentDescPage == index ? 1.0 : 0.7,
                        child: Transform.scale(
                          scale: _currentDescPage == index ? 1.0 : 0.9,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFE8F5E9),
                                  Color(0xFFC8E6C9),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.green.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Leaf decoration in corners
                                Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Icon(
                                      Icons.eco,
                                      size: 30,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Icon(
                                      Icons.eco,
                                      size: 30,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ),
                                // Text content
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Center(
                                    child: Text(
                                      descriptions[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green[900],
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Page indicator dots
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    descriptions.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentDescPage == index
                            ? Colors.green[700]
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Sensors & Components Section Title with leaf icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.eco, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      "Sensors & Components",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.eco, color: Colors.green[700]),
                  ],
                ),
                SizedBox(height: 15),
                
                // Sensor Image Slideshow with 3D card effect
                Container(
                  height: 270,
                  child: PageView.builder(
                    controller: _sensorController,
                    itemCount: sensorData.length,
                    itemBuilder: (context, index) {
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _currentSensorPage == index ? 1.0 : 0.7,
                        child: Transform.scale(
                          scale: _currentSensorPage == index ? 1.0 : 0.85,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 3D effect for the sensor image
                                Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateX(0.05)
                                    ..rotateY(-0.05),
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: Offset(5, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        sensorData[index]["image"]!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  sensorData[index]["name"]!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Sensor page indicator dots
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    sensorData.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentSensorPage == index
                            ? Colors.green[700]
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Faculty Section with paper-cut effect
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Faculty",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 25),
                      
                      // Instructor with 3D effect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 3D effect avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.green[50],
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: AssetImage("assets/instructor.jpg"),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          
                          // Instructor details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dr. Suresh Jain",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Instructor",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green[700],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.school, size: 16, color: Colors.green[700]),
                                  SizedBox(width: 5),
                                  Text(
                                    "Environmental Engineering",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Mentor with 3D effect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Vishal",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Project Mentor",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green[700],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "IoT Specialist",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.sensors, size: 16, color: Colors.green[700]),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          
                          // 3D effect avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.green[50],
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: AssetImage("assets/mentor.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Team sections with natural look
                NatureTeamSection(
                  title: "Software Development Team",
                  students: softwareTeam,
                  controller: _softwareController,
                  iconData: Icons.code,
                ),
                SizedBox(height: 30),
                
                NatureTeamSection(
                  title: "Hardware Development Team",
                  students: hardwareTeam,
                  controller: _hardwareController,
                  iconData: Icons.memory,
                ),
                SizedBox(height: 40),
                
                // Footer with leaf decoration
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.eco,
                        color: Colors.green[700],
                        size: 30,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Air-Index - Making Our Planet Greener",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        "© 2025 B-Tech Project",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Student {
  final String name;
  final String image;
  Student({required this.name, required this.image});
}

class NatureTeamSection extends StatelessWidget {
  final String title;
  final List<Student> students;
  final PageController controller;
  final IconData iconData;

  const NatureTeamSection({
    Key? key,
    required this.title,
    required this.students,
    required this.controller,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title with nature icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: Colors.green[700]),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        
        // Leaf-shaped divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.green[200],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.eco, color: Colors.green[300], size: 20),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.green[200],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        
        // Team carousel with natural-style cards
        Container(
          height: 200,
          child: PageView.builder(
            controller: controller,
            itemCount: students.length,
            itemBuilder: (context, index) {
              return NatureStudentCard(student: students[index]);
            },
          ),
        ),
      ],
    );
  }
}

class NatureStudentCard extends StatelessWidget {
  final Student student;
  const NatureStudentCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.green[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.green[200]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 3D effect for student avatar
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(0.05),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage(student.image),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            student.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green[900],
            ),
            textAlign: TextAlign.center,
          ),
          // Small leaf decoration
          Icon(
            Icons.eco,
            size: 12,
            color: Colors.green[400],
          ),
        ],
      ),
    );
  }
}