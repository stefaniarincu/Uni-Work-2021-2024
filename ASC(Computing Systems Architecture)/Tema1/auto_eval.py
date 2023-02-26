from time import time 
import os
import subprocess
import shlex
import sys


sys_args = sys.argv

def compileSource(task):
    print("Compiling source for task {}".format(task['id']))
    atoProc = subprocess.run(list(shlex.split("as --32 cerinta{}.asm -o cerinta{}.o".format(task['id'], task['id']))), stdout=subprocess.PIPE)
    oteProc = subprocess.run(shlex.split("gcc -m32 cerinta{}.o -o cerinta{}".format(task["id"], task['id'])), stdout=subprocess.PIPE)


tl_ids = list(set((map(int, input("Insert problem ids (eg 1 2 3 4 if you'd like to test all the problems):").split()))))
tasks = [{'id':i, 'exec_file': 'cerinta{}'.format(i), 'tests_file': 'cerinta{}_teste.txt'.format(i)} for i in tl_ids]

start_time = time()

task_stats = {}

for task in tasks:
    compile_source = '--no-compile' not in sys_args
    if compile_source:
        compileSource(task)   
    
    tests_file = open(task['tests_file'], 'r')
    lines = tests_file.readlines()
    lines = [{'input': lines[t].strip(), 'output': lines[t+1].strip()} for t in range(0,len(lines),3)]
    task_stats[task['id']] = {'tests_count': len(lines), 'passed': 0, 'failed': 0}
    for line in lines:
        expected_output = line['output']
        taskProcess = subprocess.run(['./' + task['exec_file']], stdout=subprocess.PIPE, input = line['input'], encoding = 'ascii')
        process_output = taskProcess.stdout
        process_output = process_output.strip()
        if expected_output == process_output:
            task_stats[task['id']]['passed'] += 1
        else:
            task_stats[task['id']]['failed'] += 1
            print("Test failed for problem no. {}, (input was \"{}\")".format(task['id'], line['input']))
            print("Expected output is \"{}\", actual output is \"{}\"\n\n".format(expected_output, process_output))
    passed_count = task_stats[task['id']]['passed']
    failed_count = task_stats[task['id']]['failed']
    print("Task {}: {} out of {} tests passed ({:.2f}%)".format(task['id'],passed_count,  passed_count + failed_count, passed_count/(passed_count+failed_count)*100))    



end_time = time()


print("Evaluation finished (took {:.5f}s)".format(end_time - start_time))
