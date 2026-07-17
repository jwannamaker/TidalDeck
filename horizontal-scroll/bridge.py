import serial
import keyboard
import time

# Adjust the port and baud rate to match the Arduino
ser = serial.Serial('/dev/ttyACM0', 9600, timeout=0.1)
time.sleep(2)
ser.reset_input_buffer()
print('Buffer cleared.')
print('Listening for scroll wheel movements...')

while True:
    try:
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8', errors='ignore').strip()
            if line == "LEFT":
                keyboard.press('left')
                time.sleep(0.01)
            elif line == "RIGHT":
                keyboard.press('right')
                time.sleep(0.01)
            ser.reset_input_buffer()
    except Exception as e:
        print(f"Error reading serial: {e}")
        time.sleep(0.1)

