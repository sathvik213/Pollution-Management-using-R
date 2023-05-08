import paho.mqtt.client as mqtt

# Define the MQTT broker host and port
broker_address = "mqtt.eclipseprojects.io"
broker_port = 1883

# Define the topics for the publishers and subscriber
topic1 = "mytopic/Arhus1"
topic2 = "mytopic/Aarhus2"

def on_message(client, userdata, message):
    co = str(message.payload.decode("utf-8")).split(',')[1]
    validate(co)

def validate(co):
    if int(co)<=100:
        print("Low Pollution")
    else:
        print("High Pollution")    

subscriber = mqtt.Client("PollutionSubscriber2")
subscriber.connect(broker_address, broker_port)

# Set up the callback function for the subscriber
subscriber.on_message = on_message

# Subscribe to the topics for the publishers
subscriber.subscribe(topic1)
subscriber.subscribe(topic2)

subscriber.loop_forever()