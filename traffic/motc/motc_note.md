MOTC Project
======
* 公車站牌距離查詢
resp = requests.post('https://gist-geo.motc.gov.tw/Api/Locator/V1/Bus', json={"name": "682"}, verify=False)

* 公車shape 查詢
http://210.59.250.227/MOTC/v2/Bus/Shape/Taipei/648?$format=json

* Google Direction API
https://maps.googleapis.com/maps/api/directions/json?origin=台北小城&destination=台大&mode=transit&departure_time=1379319226&alternatives=true
