load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")

MONERO_PRICE_URL = "https://www.monero.how/widgetLive.json"

MONERO_ICON = base64.decode("""
UklGRp4BAABXRUJQVlA4TJEBAAAvEAAEEL/iNpIkRcpj8fw37O5JfguYZtsNNo0kOarz4ZF9ZM/lgXzsxlFk207U5CX+dWACA1EFzOyI121t20r07/tA6N4EhPRDW/TBSBmTT+ru/m7AJCEIQkG8Ih8BAAAgOCvxgCB+Fvv2fy9ESf4gnjVO/dzvf919C1xt06d/X16ejF3zCR9LNF42MfHam902Ny5HW/W1NF0prkOrsKyu2a7J+T33vf3fKgnh4I4KLgSAABi6UrwxxgUL/JOkSQTHrhR1ncMHhB8U8w7bwQ52TIo7iEcHwxkKDW7HDMS/QwCxtm3T1Y5t27ZPvhFnx+q/locaIvo/AQCwXzwup8tjsYf65kb181pleaD2YQVge6Deww77G6s6ajzv/0l/XqPkJRd30mbMq5RNPvJ1IW0GY45kxWTwkdcjabMGjAUWjXa3jzzeSJun4TSmjfZm2Efe7gqpOwyuliie2Xjc7BFpRJsiYUs8nkkGnc6YiHRFJBGJhFL4Gove2Q+A96mOyR+Uvz2N4SfUOx/zwaj/9t0GAAA=
""")

def main():
    rate_cached = cache.get("monero_rate")
    if rate_cached != None:
        rate = rate_cached
    else:
        rep = http.get(MONERO_PRICE_URL)
        if rep.status_code != 200:
            fail("request failed with status %d", rep.status_code)
        rate = rep.json()['xmrPriceKraken']['last']
        cache.set("monero_rate", str(rate), ttl_seconds = 240)

    return render.Root(
        child = render.Box(
            render.Row(
                expanded = True,
                main_align = "space_evenly",
                cross_align = "center",
                children = [
                    render.Image(src = MONERO_ICON),
                    render.Text("$%s" % rate),
                ],
            ),
        ),
    )
