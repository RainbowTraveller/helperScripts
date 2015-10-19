languages=( "java" "c" "cpp" "python" )
present=1

function set_tmux_env {

    tmux has-session -t env_java 

    if [ $? != 0 ]
        then
            #JAVA
            #Create new session env_java with window named Coding
            tmux new -s env_java -n Coding -d
            #Add new window Compile in target session env_java
            tmux new-window -n Compile -t env_java 
            #Add new window Testing in target session env_java
            tmux new-window -n Testing -t env_java 
            #Change to appropriate directory in all the windows in target session env_java
            #C-m : Enter or CR
            tmux send-keys -t env_java:1 'cd ~/WFMilind/amazingJava' C-m
            tmux send-keys -t env_java:2 'cd ~/WFMilind/amazingJava' C-m
            tmux send-keys -t env_java:3 'cd ~/WFMilind/amazingJava' C-m
        fi

    tmux has-session -t env_c

    if [ $? != 0 ]
        then
            #C
            tmux new -s env_c -n Coding -d
            tmux new-window -n Compile -t env_c 
            tmux new-window -n Testing -t env_c 
            tmux send-keys -t env_c:1 'cd ~/WFMilind/starterC' C-m
            tmux send-keys -t env_c:2 'cd ~/WFMilind/starterC' C-m
            tmux send-keys -t env_c:3 'cd ~/WFMilind/starterC' C-m
        fi

    tmux has-session -t env_cpp

    if [ $? != 0 ]
        then
            #CPP
            tmux new -s env_cpp -n Coding -d
            tmux new-window -n Compile -t env_cpp 
            tmux new-window -n Testing -t env_cpp 
            tmux send-keys -t env_cpp:1 'cd ~/WFMilind/almightyC++' C-m
            tmux send-keys -t env_cpp:2 'cd ~/WFMilind/almightyC++' C-m
            tmux send-keys -t env_cpp:3 'cd ~/WFMilind/almightyC++' C-m
        fi

    tmux has-session -t env_python 

    if [ $? != 0 ]
        then
            #PYTHON
            tmux new -s env_python -n Coding -d
            tmux new-window -n Compile -t env_python 
            tmux new-window -n Testing -t env_python  
            tmux new-window -n Command -t env_python  
            tmux send-keys -t env_python:1 'cd ~/WFMilind/pythonPranks' C-m
            tmux send-keys -t env_python:2 'cd ~/WFMilind/pythonPranks' C-m
            tmux send-keys -t env_python:3 'cd ~/WFMilind/pythonPranks' C-m
            tmux send-keys -t env_python:4 'cd ~/WFMilind/pythonPranks' C-m
        fi

    case "$1" in
     java)
         tmux attach -t env_java
         ;;
     c)
         tmux attach -t env_c
         ;;
     cpp)
         tmux attach -t env_cpp
         ;;
     python)
         tmux attach -t env_python
         ;;
    esac
}

for lang in "${languages[@]}"
do
   if [[ $lang == $1 ]] 
   then
       present=0
       set_tmux_env $1
       break
   fi
done

if [[ $present == 1 ]]
then
   echo "Not a valid language"
   echo "Usage : ./tmux_sessions.sh {java, c , c++, python}"
fi

