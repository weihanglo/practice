import requests
# Google direction API -----------------
resp = requests.get('https://maps.googleapis.com/maps/api/directions/json?origin=台北小城&destination=台大&mode=transit&departure_time=1379319226&alternatives=true')

i = 0 # 0 for 綠8, 1 for 648
j = 0 # 0 for 綠8, 1 for 648
# loop 'i' for differnt route
# loop 'j' to find transit mode, location, and name of bus line
if resp.json()['routes'][i]['legs'][0]['steps'][j]['travel_mode'] == 'TRANSIT':
    resp.json()['routes'][i]['legs'][0]['steps'][j]['start_location']
    resp.json()['routes'][i]['legs'][0]['steps'][j]['end_location']
    resp.json()['routes'][i]['legs'][0]['steps'][j]['transit_details']['line']['short_name']

# MOTC bus line shape ------------------
resp2 = requests.get('http://210.59.250.227/MOTC/v2/Bus/Shape/Taipei/648?$format=json')



routeJSON = resp.json()['routes']
routes = {}
for i in routeJSON:
    print(i)
