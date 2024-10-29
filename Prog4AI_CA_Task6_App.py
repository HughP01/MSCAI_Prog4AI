#!/usr/bin/env python
# coding: utf-8

# In[32]:

from kafka import KafkaConsumer
import streamlit as st
import pandas as pd
import requests
import json
import plotly.express as px
import plotly.graph_objects as go
from streamlit_autorefresh import st_autorefresh

# GitHub raw URL to your CSV file
GITHUB_CSV_URL = "https://raw.githubusercontent.com/HughP01/MSCAI_Prog4AI/refs/heads/master/GlobalWeatherRepository.csv"

st.set_page_config(page_title="Weather Data Dashboard", layout="wide")

# Page selection
st.sidebar.title("Navigation")
section = st.sidebar.radio("Go to", ["Data Dashboard", "Live Data Updates"])

# Two sections
if section == "Data Dashboard":
    st.title("Global Weather Data Dashboard")

    @st.cache_data(ttl=600)
    def load_data():
        try:
            # Load the CSV file from GitHub
            df = pd.read_csv(GITHUB_CSV_URL)
            return df
        except Exception as e:
            st.error(f"Failed to load data from GitHub: {e}")
            return pd.DataFrame()

    df = load_data()

    
    if not df.empty:
        # Example: Filter by Region
        region_options = df['location_name'].unique()
        selected_region = st.selectbox("Select Region", options=region_options)

        filtered_data = df[df['location_name'] == selected_region]

        # Display the filtered data
        st.write("Filtered Data", filtered_data)
        st.subheader("Temperature vs. Humidity")
        fig = px.scatter(filtered_data, x="temperature_celsius", y="humidity", color="location_name")
        st.plotly_chart(fig)






#Live updates
elif section == "Live Data Updates":

    PRODUCER_API_URL = "http://localhost:5000/send-data"

    # Trigger data sending at the start of the "Live Data Updates" section
    start_row = 0
    end_row = 100  # Adjust as needed for your data size

    # Request data from the producer endpoint
    response = requests.post(PRODUCER_API_URL, params={"start": start_row, "end": end_row})
    if response.status_code == 200:
        st.write("Data stream started successfully.")
    else:
        st.error(f"Failed to start data stream: {response.json()}")


    st.title("Live Weather Data Updates")

    

    KAFKA_BROKER = "localhost:9092" 
    TOPIC_NAME = "csv_data_topic"

    #Kafka consumer
    consumer = KafkaConsumer(
    TOPIC_NAME,
    bootstrap_servers=[KAFKA_BROKER],
    auto_offset_reset="earliest",
    enable_auto_commit=True,
    group_id="streamlit-consumer",
    value_deserializer=lambda x: json.loads(x.decode("utf-8"))
    )


    st_autorefresh(interval=1000)  # Refresh every sec

    
    data = []
    st.write("Most recent data streamed from Kafka in real-time.")
    # Stream data from Kafka
    for message in consumer:
        row = message.value
        data.append(row)

         # Display the latest row in Streamlit as a table
        if data:
            df = pd.DataFrame(data)
            st.write(df.tail(10))

    
    

