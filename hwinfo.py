import io
import wmi
import json
from ftplib import FTP

data = {}
mainboard = {}


w = wmi.WMI(namespace="root\OpenHardwareMonitor")
temperature_infos = w.Hardware()
temperature_infos2 = w.Sensor();
for hardware in temperature_infos:
    name = hardware.Name
    type = hardware.HardwareType
    
   
    data[name] = {}
    data[name]["type"] = type
    data[name]["temps"] = {}
    data[name]["load"] = {}
    data[name]["fans"] = {}
    data[name]["clocks"] = {}
    data[name]["voltage"] = {}
    data[name]["Parent"] = {}
    
    id = hardware.Identifier
    for sensor in temperature_infos2:
        if sensor.Parent==id:
            data[name]["Parent"] = hardware.Identifier;
            if sensor.SensorType==u'Temperature':
                data[name]["temps"][sensor.Name] = {}
                data[name]["temps"][sensor.Name] = sensor.Value
            elif sensor.SensorType==u'Load':
                data[name]["load"][sensor.Name] = {}
                data[name]["load"][sensor.Name] = sensor.Value
            elif sensor.SensorType==u'Fan':
                data[name]["fans"][sensor.Name] = {}
                data[name]["fans"][sensor.Name] = sensor.Value    
            elif sensor.SensorType==u'Clock':
                data[name]["clocks"][sensor.Name] = {}
                data[name]["clocks"][sensor.Name] = sensor.Value
            elif sensor.SensorType==u'Voltage':
                data[name]["voltage"][sensor.Name] = {}
                data[name]["voltage"][sensor.Name] = sensor.Value            
           
json_data = json.dumps(data)
exit()


            

    
    
