if [ "$1" == "deploy" ]; then 
    echo "deploying..."
    starknet deploy --contract contracts/solutions/ex1/ERC20.cairo --inputs 1465404249 1465404249 450000000000000000000 --network alpha-goerli 
elif [ "$1" == "declare" ]; then 
    echo "declaring..."
    starknet declare --contract  contracts/solutions/ex1/ERC20_compiled.json --network alpha-goerli 
else 
    echo "compiling..."
    starknet-compile contracts/solutions/ex1/ERC20.cairo --output contracts/solutions/ex1/ERC20_compiled.json
fi