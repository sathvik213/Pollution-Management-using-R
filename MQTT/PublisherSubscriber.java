
//////////////////////////////////////////////////////////////s
import org.eclipse.paho.client.mqttv3.*;
import com.opencsv.*;
import java.io.*;
import java.util.*;
import java.util.concurrent.TimeUnit;

public class PublisherSubscriber {

    // Define the MQTT broker host and port
    static String broker_address = "mqtt.eclipseprojects.io";
    static int broker_port = 1883;

    // Define the topics for the publishers and subscriber
    static String topic1 = "mytopic/Arhus1";
    static String topic2 = "mytopic/Aarhus2";

    // Define the function to read data from the CSV file
    static List<String[]> read_csv(String file) throws Exception {
        CSVReader reader = new CSVReader(new FileReader(file));
        List<String[]> data = reader.readAll();
        return data;
    }

    // Define the function to publish data to MQTT broker
    static void publish_data(MqttClient client, String topic, String data) throws MqttException {
        MqttMessage message = new MqttMessage(data.getBytes());
        client.publish(topic, message);
    }

    // Define the callback function for the subscriber
    static class SubscriberCallback implements MqttCallback {
        public void messageArrived(String topic, MqttMessage message) throws Exception {
            System.out.println("Received message: " + new String(message.getPayload()));
        }
        public void connectionLost(Throwable cause) {}
        public void deliveryComplete(IMqttDeliveryToken token) {}
    }

    public static void main(String[] args) throws Exception {

        // Set up the MQTT client for the publishers
        MqttClient client1 = new MqttClient("tcp://" + broker_address + ":" + broker_port, "Arhus1");
        client1.connect();

        MqttClient client2 = new MqttClient("tcp://" + broker_address + ":" + broker_port, "Aarhus2");
        client2.connect();

        // Set up the MQTT client for the subscriber
        MqttClient subscriber = new MqttClient("tcp://" + broker_address + ":" + broker_port, "PollutionSubscriber");
        subscriber.connect();

        // Set up the callback function for the subscriber
        subscriber.setCallback(new SubscriberCallback());

        // Subscribe to the topics for the publishers
        subscriber.subscribe(topic1);
        subscriber.subscribe(topic2);

        // Read data from the CSV file for Aarhus2 publisher
        List<String[]> data1 = read_csv("data/GROUP1pollutionData209907.csv");
        List<String[]> data2 = read_csv("data/SecondDataset2pollutionData209960.csv");

        // Loop for publishing data every 10 seconds
        while (true) {
            // Get current timestamp
            long timestamp = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());

            // Publish data for Arhus1 publisher
            String co_data = data1.get((new Random()).nextInt(data1.size()))[1];
            String payload1 = timestamp + "," + co_data;
            publish_data(client1, topic1, payload1);

            // Publish data for Aarhus2 publisher
            co_data = data2.get((new Random()).nextInt(data2.size()))[1];
            String payload2 = timestamp + "," + co_data;
            publish_data(client2, topic2, payload2);

            // Wait for 10 seconds before publishing next data
            Thread.sleep(10000);
        }

        // Stop the subscriber

    }
}
