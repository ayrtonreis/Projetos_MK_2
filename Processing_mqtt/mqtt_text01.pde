import mqtt.*;

MQTTClient client;

void setup() {
  client = new MQTTClient(this);
  client.connect("mqtt://192.168.43.246", "processing");
  client.subscribe("#");
  // client.unsubscribe("/example");
}

void draw() {}

void keyPressed() {
  client.publish("/hello", "this is my message");
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
}