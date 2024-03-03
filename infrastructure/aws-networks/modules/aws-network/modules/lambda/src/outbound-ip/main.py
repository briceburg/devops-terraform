import json
import urllib3


def lambda_handler(event, context):
    http = urllib3.PoolManager()
    try:
        r = http.request(
            "GET",
            "http://ipinfo.io",
            timeout=2.90,
            retries=False,
        )
        #print(r.data)
        return {"success": True, "ip": json.loads(r.data.decode("utf-8"))["ip"] }
    except urllib3.exceptions.ConnectTimeoutError:
        return {"success": False, "ip": None}

    