import serial
import requests
import urllib3
import time
import json
import gspread
import os
import pyowm

from pyowm import timeutils
from requests import get
from datetime import datetime
from oauth2client.service_account import ServiceAccountCredentials

class weather():
    def __init__(self, location):
        try:
            owm = pyowm.OWM('882b317d3aa544dfcac92e0e1b269318')
            observation = owm.weather_at_place(location)
            weather = observation.get_weather()
            self.temp = str(weather.get_temperature('celsius')['temp'])
            self.hum = str(weather.get_humidity())
            self.status = str(weather.get_detailed_status())

            forecast = owm.three_hours_forecast(location)
            later = timeutils.next_three_hours()
            prediction =forecast.get_weather_at(later)
            self.prediction = prediction.get_status()

        except:
            print('Weather'+location+'failed')


def local_write_weather_data(values_weather):
    header = ['Date', 'Time', 'FR temp', 'FR humidity', 'FR Status', 'FR 3-hour Forecast', 'UK temp', 'UK humidity', 'UK Status', 'UK 3-Hour Forecast']
    local_write('weather_collection.csv', header, values_weather)

def local_write_sensor_data(values_sensor):
    header = ['Date', 'Time', 'Sensor (UK)']
    local_write('data_collection.csv', header, values_sensor)

def local_write(file_name, header, data):
    file = open(file_name, 'a')
    if os.stat(file_name).st_size ==0:
        file.write(','.join(header) + '\n')

    try:
        file.write(','.join(data) + '\n')
        file.close
    except:
        print('local write to '+file_name+' failed')

def online_write(values_sensor, values_weather):
    try:
        scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
        creds = ServiceAccountCredentials.from_json_keyfile_name('google_test.json', scope)
        client = gspread.authorize(creds)
        sheet_sensor = client.open('Data').sheet1
        sheet_sensor.append_row(values_sensor)
        sheet_weather = client.open('Data').worksheet('sheet2')
        sheet_weather.append_row(values_weather)
    except:
        print('online upload failed')

def main():
    ser = serial.Serial('/dev/ttyACM0',9600, 8, 'N', 1, timeout=1)
    oldtime = time.time()

    sensor1 = 0
    count = 0
    size = 5

    # collecting size minutes of data
    while (count < size): 
        line = ser.readline()
        if (time.time() - oldtime) > 60:
            (a,b) = [int(_) for _ in line.decode('ascii').strip().split()]
            sensor1 += a
            count += 1
            oldtime = time.time()

    sensor1_avg = str(sensor1/size)

    weather_FR = weather('Mougins, FR')
    weather_UK = weather('London, GB')

    date = (time.strftime('%d/%m/2020'))
    reporttime = (time.strftime('%H:%M:%S'))
    values_sensor = [date, reporttime, sensor1_avg]
    values_weather = [date, reporttime, weather_FR.temp, weather_FR.hum, weather_FR.status, weather_FR.prediction, weather_UK.temp, weather_UK.hum, weather_UK.status, weather_UK.prediction]

    local_write_weather_data(values_weather)
    local_write_sensor_data(values_weather)
    online_write(values_sensor, values_weather)

if __name__== "__main__":
  main()
