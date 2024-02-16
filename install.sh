forge init --template https://github.com/foundry-rs/forge-template hello_foundry
forge install transmissions11/solmate Openzeppelin/openzeppelin-contracts

##  \
# --etherscan-api-key <your_etherscan_api_key> \
forge create  --rpc-url localhost:8545 \
    --constructor-args "ForgeUSD" "FUSD" 18 1000000000000000000000 \
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

cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "totalSupply()(uint256)" --rpc-url http://localhost:8545/
1000000000000000000000 [1e21]