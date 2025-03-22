import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final PageController _descController = PageController();
  final PageController _sensorController = PageController(); // Sensor slideshow
  final PageController _softwareController = PageController();
  final PageController _hardwareController = PageController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About App"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// App Logo & Name
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/app_logo.jpg"),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Air-Index",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),

              /// Description Slideshow (Cards with Elevation)
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 150,
                  maxHeight: 400,
                ),
                child: PageView.builder(
                  controller: _descController,
                  itemCount: descriptions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            descriptions[index],
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40), // Increased spacing before sensor images

              /// Sensor Image Slideshow (New Feature)
              Text(
                "Sensors & Components Used",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250, // Adjusted for image + name
                width: 250,
                child: PageView.builder(
                  controller: _sensorController,
                  itemCount: sensorData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Rounded edges
                          child: Image.asset(sensorData[index]["image"]!, fit: BoxFit.cover, height: 200, width: 200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          sensorData[index]["name"]!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 40), // More space before instructor section

              /// Instructor Section
              Column(
                children: [
                  Text(
                    "Instructor",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  SizedBox(height: 10), // Spacing between heading and image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/instructor.jpg"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Dr. Suresh Jain",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Project Mentor",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  SizedBox(height: 10), // Spacing between heading and image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/mentor.png"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Vishal",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
                
              ),
              SizedBox(height: 40), // Increased space before teams

              /// Software Development Team
              TeamSection(
                title: "Software Development Team",
                students: softwareTeam,
                controller: _softwareController,
              ),
              SizedBox(height: 20),

              /// Hardware Development Team
              TeamSection(
                title: "Hardware Development Team",
                students: hardwareTeam,
                controller: _hardwareController,
              ),
              SizedBox(height: 20),
            ],
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

class TeamSection extends StatelessWidget {
  final String title;
  final List<Student> students;
  final PageController controller;

  const TeamSection({
    Key? key,
    required this.title,
    required this.students,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: controller,
            itemCount: students.length,
            itemBuilder: (context, index) {
              return StudentCard(student: students[index]);
            },
          ),
        ),
      ],
    );
  }
}

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(student.image),
        ),
        SizedBox(height: 5),
        Text(
          student.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
