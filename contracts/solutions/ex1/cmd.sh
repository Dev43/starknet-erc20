if [ "$1" == "deploy" ]; then 
    echo "deploying..."
    starknet deploy --inputs 1465404249 1465404249 450000000000000000000 0 361958816396474883452031563054282316433373339603650974221110346970974921578 --network alpha-goerli --class_hash $2
elif [ "$1" == "declare" ]; then 
    echo "declaring..."
    starknet declare --contract  ./ERC20_compiled.json --network alpha-goerli 
else 
    echo "compiling..."
    starknet-compile ./ERC20.cairo --output ./ERC20_compiled.json
fi
