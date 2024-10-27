#!/usr/bin/env python
# coding: utf-8

# In[32]:


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

    # Add filters for date, region, or other relevant metrics
    if not df.empty:
        # Example: Filter by Region
        region_options = df['location_name'].unique()
        selected_region = st.selectbox("Select Region", options=region_options)

        # Apply the region filter
        filtered_data = df[df['location_name'] == selected_region]

        # Display the filtered data
        st.write("Filtered Data", filtered_data)

        # Plot a sample static chart
        st.subheader("Temperature vs. Humidity")
        fig = px.scatter(filtered_data, x="temperature_celsius", y="humidity", color="location_name")
        st.plotly_chart(fig)






#Live updates
elif section == "Live Data Updates":
    st.title("Live Weather Data Updates")

    st_autorefresh(interval=1000)  # Refresh every sec

    
    plot_placeholder = st.empty()

    
    

