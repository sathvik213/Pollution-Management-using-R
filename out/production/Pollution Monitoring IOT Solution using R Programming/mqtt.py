import paho.mqtt.client as mqtt
import pandas as pd
import time

# Define the MQTT broker host and port
broker_address = "mqtt.eclipseprojects.io"
broker_port = 1883

# Define the topics for the publishers and subscriber
topic1 = "mytopic/Arhus1"
topic2 = "mytopic/Aarhus2"

# Define the function to read data from the CSV file
def read_csv(file):
    data = pd.read_csv(file)
    return data

# Define the function to publish data to MQTT broker
def publish_data(client, topic, data):
    client.publish(topic, data)

# Define the callback function for the subscriber
def on_message(client, userdata, message):
    print("Received message: ", str(message.payload.decode("utf-8")))

# Set up the MQTT client for the publishers
client1 = mqtt.Client("Arhus1")
client1.connect(broker_address, broker_port)

client2 = mqtt.Client("Aarhus2")
client2.connect(broker_address, broker_port)

# Set up the MQTT client for the subscriber
subscriber = mqtt.Client("PollutionSubscriber")
subscriber.connect(broker_address, broker_port)

# Set up the callback function for the subscriber
subscriber.on_message = on_message

# Subscribe to the topics for the publishers
subscriber.subscribe(topic1)
subscriber.subscribe(topic2)

# Start the subscriber
subscriber.loop_start()

# Read data from the CSV file for Aarhus2 publisher
data1 = read_csv("data//GROUP1pollutionData209907.csv")
data2 = read_csv("data//SecondDataset2pollutionData209960.csv")

# Loop for publishing data every 10 seconds
while True:
    # Get current timestamp
    timestamp = int(time.time())

    # Publish data for Arhus1 publisher
    co_data = str(data1.sample(1)["carbon_monoxide"].values[0])
    payload1 = str(timestamp) + "," + co_data
    publish_data(client1, topic1, payload1)

    # Publish data for Aarhus2 publisher
    co_data = str(data2.sample(1)["carbon_monoxide"].values[0])
    payload2 = str(timestamp) + "," + co_data
    publish_data(client2, topic2, payload2)

    # Wait for 10 seconds before publishing next data
    time.sleep(10)

# Stop the subscriber
subscriber.loop_stop()
