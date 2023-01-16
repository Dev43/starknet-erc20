if [ "$1" == "deploy" ]; then 
    echo "deploying..."
    starknet deploy  --network alpha-goerli --class_hash $2
elif [ "$1" == "declare" ]; then 
    echo "declaring..."
    starknet declare --contract  ./ExcerciseSolution_compiled.json --network alpha-goerli 
else 
    echo "compiling..."
    starknet-compile ./ExcerciseSolution.cairo --output ./ExcerciseSolution_compiled.json
fi
