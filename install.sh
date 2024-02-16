forge init --template https://github.com/foundry-rs/forge-template hello_foundry
forge install transmissions11/solmate Openzeppelin/openzeppelin-contracts

##  \
# --etherscan-api-key <your_etherscan_api_key> \
# --constructor-args address \
forge create  --rpc-url localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    src/MyToken.sol:MyToken

# forge verify-contract \
#     --chain-id 11155111 \
#     --num-of-optimizations 1000000 \
#     --watch \
#     --constructor-args $(cast abi-encode "constructor(string,string,uint256,uint256)" "ForgeUSD" "FUSD" 18 1000000000000000000000) \
#     --etherscan-api-key <your_etherscan_api_key> \
#     --compiler-version v0.8.10+commit.fc410830 \
#     <the_contract_address> \
#     src/MyToken.sol:MyToken 




forge create  --rpc-url localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    src/MyToken.sol:MyToken

# [⠒] Compiling...
# No files changed, compilation skipped
# Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
# Deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
# Transaction hash: 0x9a561be150c6db131ab17591097474d803c3f9751621296fbb7eaa0cbb17c1c7

cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "totalSupply()(uint256)" 
# 1000000000000000000000 [1e21]

forge create  --rpc-url localhost:8545 \
    --constructor-args 0x5FbDB2315678afecb367f032d93F642f64180aa3 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    src/WrapToken.sol:WrapToken

# No files changed, compilation skipped
# Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
# Deployed to: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
# Transaction hash: 0x9c4c0681d1b4349e5318aee547f43d68830618ff4cb0d265631a02fea9dc1eb1

cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "name()(string)"
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "symbol()(string)"
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "decimals()(uint8)"

forge create  --rpc-url localhost:8545 \
    --constructor-args 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    src/EX404Plugin.sol:EX404Plugin

# No files changed, compilation skipped
# Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
# Deployed to: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
# Transaction hash: 0x75d6e5701c2f3af56125601d7d27c5dd5f55aee5f127c30d3d712a94c300b467

export ADDRESS="0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0"
export METHOD="name()(string)"
cast call $ADDRESS $METHOD
