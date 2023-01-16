
# Token class 0x525507e3b33d6d41ff2d0d29e53bd2ccd0c8f0b0876ca481a0d4af46fcdfb17


# Solution class 0x52fd37dbcb0d40e3e790c6fe670ac3386f58fa6b6939a4f7df5adf737db4986
# Token address 0x065219a91f3f535fb42c63b0620718738a728b9848bc912a4ae04002b45d1cd4
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


