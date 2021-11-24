# Traffic light system using 8051 assembly ISA

## Schematic
![image](https://user-images.githubusercontent.com/61471002/143238951-bc27d0a2-c059-4f2b-b9c4-9e816217f2ff.png)

## Components
1. 8051 MCU
2. Two 7-segment displays
3. Two push button
4. Two LEDs

## Features

### 1.Display time left <br>
This happens by using main two functions that control the displaying numbers on 7-segments. They use look-up table and decremented until reach the lower value (value 0) then return to the end (value 9). <br>

![image](https://user-images.githubusercontent.com/61471002/143239778-48563b59-75d5-4c6e-a52b-38b5198c8929.png)
![image](https://user-images.githubusercontent.com/61471002/143239800-546ddc30-a74c-45c5-83d1-a75b36ef25b3.png)

### 2.Changing delay between counts <br>
This feature aims to control the frequency of change of 7-segments values. This is done using a variable that is incremented by a switch and another switch to just return the variable to a pre-defined value. <br>

![image](https://user-images.githubusercontent.com/61471002/143239988-99eb974e-98c0-40f0-bbac-83eadc4bafa8.png)
![image](https://user-images.githubusercontent.com/61471002/143240009-1ee5f745-0438-4d33-a632-e238b087e1bc.png)
![image](https://user-images.githubusercontent.com/61471002/143240054-74562459-6ad8-473f-9b16-38c8a5087198.png)
<br>
>> ‘SWITCH’ function sets flags in case of pressing on reset or delay buttons <br>
>> ‘INCREMENT’ function executes the functions according to flags values

### 3.Controlling maximum value displayed on 7-segments <br>
This is done by incrementing ‘MAX’ variable. The same logic as the above (SWITCH’ function sets flags and SWITCH’ function sets flags) <br>
![image](https://user-images.githubusercontent.com/61471002/143240219-88757fe4-a14a-46e4-9278-6143024245ca.png)
![image](https://user-images.githubusercontent.com/61471002/143240242-1f113345-7150-42d9-a7f4-586b0c0c25f4.png)

### 4.Toggle LEDs when “0 0” value displayed <br>
![image](https://user-images.githubusercontent.com/61471002/143240309-8f72c997-e362-4544-a858-82527cb2f36e.png)
![image](https://user-images.githubusercontent.com/61471002/143240323-802fed96-7cf1-46ef-bde8-b069f24556a6.png)
![image](https://user-images.githubusercontent.com/61471002/143240347-a3466bfd-1c8a-466c-b8ae-467e43d9743c.png)

>> The two flags is set in initialization <br>
>> When each of 7-segments reaches zero -> the the flag <br>
>> ‘LED’ function is continuously called in main and check for the flag <br>
>> If the condition is verified then toggle LEDs


## DEMO: [Link](https://drive.google.com/file/d/1nJPAogW0gTZAVJ3GOtxFHYK2MTAr9SIY/view?usp=sharing)
