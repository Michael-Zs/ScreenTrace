import subprocess
import threading
import time

PATH = "shots/"


def capture(path: str = "screenshot.png") -> None:
    subprocess.run(
        ["gnome-screenshot", "-f", path],
        check=True,
    )


def capture_loop():
    while True:
        datestring = time.strftime("%Y-%m-%d-%H:%M")
        capture(PATH + datestring + ".png")
        time.sleep(60 * 15)


if __name__ == "__main__":
    # sthart capturing every 15 min
    capture_thread = threading.Thread(target=capture_loop)
    capture_thread.start()

    # archive the past day's files
    while True:
        print("todo...")
        time.sleep(10)
