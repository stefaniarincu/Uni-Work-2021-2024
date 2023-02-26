from pwn import *
context.log_level = 'error'
context.timeout = 20
inputArray = [
      ["981819C03A7892DC00A78A78C03C048FFC029FFC01", 
       "8F890F94B8C8C02C03A758DFC00A75A75C04C01C03A71900C00A71A75C03", 
       "A74913C00A74A66900C00A66C0181580E864C02C04C04A72825C01A72A74A66C01C02C04", 
       "A66901C00A6D80AC00A69964C00A66A6DA69C03C01964C0480F9DE"]
    , ["255 255 mul 17 div 32 97 88 sub sub add 255 mul", 
       "98 211 mul 75 sub 33 21 155 add 100 div sub div", 
       "211 47 3 add sub 45 44 div sub 37 mul", 
       "130 27 13 sub 2 mul div 255 74 sub 92 mul mul"]
    , ["13 y 200 let y r 37 let q 94 let q r sub div 2 add mul ", 
       "20 227 f 39 let m 45 let m f sub i 2 let i mul sub 14 div add", 
       "p 227 let q 41 let p r 25 let q r 8 9 t 4 let t sub add 2 add div mul add 45 sub"]
    , ["a 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let -5 add", 
       "a 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let a -5 add", 
       "s 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let 20 sub", 
       "s 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let s 20 sub", 
       "m 5 3 -38 -12 -72 38 65 -64 -25 37 -34 -23 -14 27 -23 64 14 let -3 mul",
       "m 5 3 -38 -12 -72 38 65 -64 -25 37 -34 -23 -14 27 -23 64 14 let m -3 mul",
       "d 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let -5 div", 
       "d 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let d -5 div",
       "r 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let rot90d",
       "r 5 3 -38 -102 -92 138 95 -164 -125 237 -34 -213 -104 227 -235 164 244 let r rot90d"]]
outputArray = [
      ["-129 25 mul x -45 let x x mul div 255 sub -255 add", 
       "248 -15 -75 200 sub mul u 223 let u u div add mul q -0 let q u mul", 
       "t -19 let t f -0 let f add 21 14 100 sub div div r 37 add r t f add sub div", 
       "f -1 let m 10 let i -100 let f m i mul add -100 div 15 -222"]
    , ["981240", "643", "5920", "66608"]
    , ["65", "35", "223"]
    , ["5 3 -43 -107 -97 133 90 -169 -130 232 -39 -218 -109 222 -240 159 239", 
       "5 3 -43 -107 -97 133 90 -169 -130 232 -39 -218 -109 222 -240 159 239", 
       "5 3 -58 -122 -112 118 75 -184 -145 217 -54 -233 -124 207 -255 144 224", 
       "5 3 -58 -122 -112 118 75 -184 -145 217 -54 -233 -124 207 -255 144 224", 
       "5 3 114 36 216 -114 -195 192 75 -111 102 69 42 -81 69 -192 -42", 
       "5 3 114 36 216 -114 -195 192 75 -111 102 69 42 -81 69 -192 -42",
       "5 3 7 20 18 -27 -19 32 25 -47 6 42 20 -45 47 -32 -48", 
       "5 3 7 20 18 -27 -19 32 25 -47 6 42 20 -45 47 -32 -48",
       "3 5 -235 -213 -125 138 -38 164 -104 237 95 -102 244 227 -34 -164 -92",
       "3 5 -235 -213 -125 138 -38 164 -104 237 95 -102 244 227 -34 -164 -92"]]
points = [
      [10, 10, 10, 10]
    , [5, 5, 5, 5]
    , [5, 5, 5]
    , [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
]
executables = ["./cerinta1", "./cerinta2", "./cerinta3", "./cerinta4"]
estimatedGrade = 0
for taskIndex in range(len(executables)):
    findProcess = process(["find", executables[taskIndex]])
    findResult = findProcess.recv()
    findProcess.kill()
    
    if findResult.decode().replace("\n", "").strip() != executables[taskIndex]:
        print(f"Executable {executables[taskIndex]} not found!")
        continue 
        
    print(f"Task: {executables[taskIndex]}")
        
    taskInputArray = inputArray[taskIndex]
    taskOutputArray = outputArray[taskIndex]
    taskPoints = points[taskIndex]
    
    for i in range(0, len(taskInputArray)):
        try:
            sh = process(executables[taskIndex])
            sh.sendline(taskInputArray[i].encode())
            line = sh.recvline().decode().replace("\n", "").strip()
            sh.kill()
            
            if line == taskOutputArray[i]:
                estimatedGrade += taskPoints[i]
                
                if taskIndex < 3:
                    print(f"\tTest {i}: OK ({taskPoints[i]})")
                
                if taskIndex == 3 and i % 2 == 0:
                    print(f"\tTest {i}: OK ({taskPoints[i]})")
                    taskPoints[i + 1] = 0 # already scored
                    
                if taskIndex == 3 and i % 2 == 1:
                    if taskPoints[i] == 0:
                        print(f"\tTest {i}: already scored")
                    else:
                        print(f"\tTest {i}: OK ({taskPoints[i]})")
            else:
                print(f"\tTest {i} failed (0p)")
                print(f"\t   Input: {taskInputArray[i]}")
                print(f"\t   Your output: {line}")
                print(f"\t   Expected output: {taskOutputArray[i]}")
            
            if taskIndex == 3 and i % 2 == 1:
                print("\t------------------")
        except:
            print(f"\tTest {i}: exception! (0p)")
    print("\n")
print(f"Estimated grade {estimatedGrade + 10} / 100")
