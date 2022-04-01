load("render.star", "render")
load("http.star", "http")
load("time.star", "time")

result = http.get("https://services.swpc.noaa.gov/text/wwv.txt")
sfi = None
kindex = None
aindex = None

def main(config):
    timezone = "UTC"
    now = time.now().in_location(timezone)
    if result.status_code == 200:
        text = result.body().split()
        sfi = text[text.index("flux") + 1]
        aindex = text[text.index("A-index") + 1].strip(".")
        kindex = text[text.index("K-index") + 8].strip(".")

    return render.Root(
        child = render.Column(
            expanded = True,
            main_align = "space_evenly",
            cross_align = "center",
            children = [
                render.Text(
                    content = "   "+now.format("15:04")+"   ",
                    font = "10x20",
                    height = 17,
                    offset = -2,
                    color = "#d00",
                ),
                render.Text(
                    content = "SFI: "+str(sfi),
                    font = "tb-8",
                    color = "#0b0",
                ),
                render.Text(
                    content = " A: "+str(aindex)+" K: "+str(kindex),
                    font = "tb-8",
                    color = "#0b0",
                ),
            ],
        ),

    )
