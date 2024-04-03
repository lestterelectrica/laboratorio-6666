import processing.serial.*;


Serial puerto; // Objeto para la comunicación serial
boolean[] ledsEstado = {false, false, false, false}; // Estado de los LEDs
boolean[] btnsEstado = {false, false, false, false}; // Estado de los botones

void setup() {
  size(400, 200);
  // Inicia la comunicación serial con Arduino
  puerto = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  background(255);
  // Dibuja los LEDs
  for (int i = 0; i < 8; i++) {
    fill(ledsEstado[i/2] ? color(255, 0, 0) : color(150));
    ellipse(50 + i * 40, 50, 30, 30);
  }
  // Dibuja los botones
  for (int i = 0; i < 4; i++) {
    fill(btnsEstado[i] ? color(0, 255, 0) : color(150));
    rect(50 + i * 90, 120, 60, 30);
  }
}

// Envia la señal al Arduino cuando se presiona un botón
void mousePressed() {
  if (mouseY > 120 && mouseY < 150) {
    for (int i = 0; i < 4; i++) {
      if (mouseX > 50 + i * 90 && mouseX < 110 + i * 90) {
        puerto.write((char)('A' + i));
        break;
      }
    }
  }
}

// Recibe los datos desde Arduino
void serialEvent(Serial p) {
  String mensaje = p.readStringUntil('\n').trim();
  if (mensaje.length() == 1) {
    char estado = mensaje.charAt(0);
    if (estado >= 'A' && estado <= 'D') {
      ledsEstado[estado - 'A'] = true;
    } else if (estado >= 'E' && estado <= 'H') {
      ledsEstado[estado - 'E'] = false;
    }
  }
}
