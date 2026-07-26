import subprocess
import time

PATH = "shots/"


def capture(path: str = "screenshot.png") -> None:
    # GNOME/Wayland 下走 Shell 的 D-Bus 接口
    #   include_cursor=false -> 不带鼠标指针
    #   flash=false          -> 不闪光
    # 注意：快门音效是 gnome-screenshot 自带 libcanberra 事件，
    #       直接调用此 D-Bus 方法不会触发，因此可做到完全静默。
    subprocess.run(
        ["gnome-screenshot", "-f", path],
        check=True,
    )


if __name__ == "__main__":
    while True:
        date = time.time
        datestring = time.strftime("%Y-%m-%d-%H:%M")
        capture(PATH + datestring + ".png")
        time.sleep(60 * 15)
