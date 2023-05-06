import paho.mqtt.client as mqtt
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.datastream.connectors import FlinkKafkaProducer
from pyflink.common.serialization import SimpleStringSchema

# Define the MQTT broker host and port
broker_address = "mqtt.eclipseprojects.io"
broker_port = 1883

# Define the Kafka broker host and port
kafka_address = "localhost:9092"

# Define the topic to subscribe to on the MQTT broker
mqtt_topic1 = "mytopic/Arhus1"
mqtt_topic2 = "mytopic/Aarhus2"

# Define the Kafka topic to produce to
kafka_topic = "mykafkatopic"

# Set up the MQTT client
mqtt_client = mqtt.Client("FlinkMqttClient")
mqtt_client.connect(broker_address, broker_port)

# Define the function to process incoming MQTT messages
def on_message(client, userdata, message):
    # Get the message payload
    payload = message.payload.decode()

    # Write the payload to the Kafka topic
    producer.send(kafka_topic, payload)

# Set up the Kafka producer
env = StreamExecutionEnvironment.get_execution_environment()
producer = FlinkKafkaProducer(
    kafka_topic, SimpleStringSchema(), {'bootstrap.servers': kafka_address}
)

# Set up the MQTT subscriber
mqtt_client.on_message = on_message
mqtt_client.subscribe(mqtt_topic1)
mqtt_client.subscribe(mqtt_topic2)

# Start the MQTT client and Flink job
with env:
    env.execute("MqttToFlinkKafka")

# Disconnect the MQTT client
mqtt_client.disconnect()
