
# Token class 0x55632e4f255eecc6d4cb06298945e9e8967c00519c55ee2cb8f16fdb8bbc28c


# Solution class 0x4c4b2ac227634c2df61db246693687478b8f75124e2a239203f42fbc53669f8
# Token address 0x4b7b5debb586eedc00424d94bb29a09e0ed2b685bd25b8f50fb0022f6fd81a


# Address 0x02b186ba93abb637fb706aa6cdf0f70ef10b3c3dc4c65d7715d5fc314f9b6760
echo "In" $(pwd)
echo
if [ "$1" == "deploy_token" ]; then 
    echo "deploying..."
    starknet deploy  --network alpha-goerli --class_hash $2 --inputs 1 1 1 0 1
elif [ "$1" == "deploy" ]; then 
    echo "deploying..."
    starknet deploy  --network alpha-goerli --class_hash $2 --inputs $3
elif [ "$1" == "declare" ]; then
    echo "declaring..."
    echo "ExcerciseSolution"
    starknet declare --contract  ./ExcerciseSolution_compiled.json --network alpha-goerli 
    echo "ExcerciseSolutionToken"
    starknet declare --contract  ./ExerciseSolutionToken_compiled.json --network alpha-goerli 
else 
    echo "compiling..."
    echo "ExcerciseSolution"
    starknet-compile ./ExcerciseSolution.cairo --output ./ExcerciseSolution_compiled.json
    echo "ExcerciseSolutionToken"
    starknet-compile ./ExerciseSolutionToken.cairo --output ./ExerciseSolutionToken_compiled.json
fi


