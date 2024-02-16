pragma solidity ^0.8.0;

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

interface IPlugin {
    function afterDeposit(address sender, uint256 amount) external;

    function afterWithdraw(address sender, uint256 amount) external;

    function afterTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) external;

    function afterApprove(
        address sender,
        address spender,
        uint256 amount
    ) external;
}

abstract contract EX20 {
    IPlugin[] public plugins;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addPlugin(IPlugin plugin) public onlyOwner {
        plugins.push(plugin);
    }

    function removePlugin(IPlugin plugin) public onlyOwner {
        for (uint i = 0; i < plugins.length; i++) {
            if (plugins[i] == plugin) {
                plugins[i] = plugins[plugins.length - 1];
                plugins.pop();
                return;
            }
        }
    }

    function exCallback(address addr, int256 amount) public virtual;
}

contract WrapToken is IERC20, EX20 {
    IERC20 public underlyingToken;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    event Approval(address indexed sender, address indexed guy, uint amount);
    event Transfer(
        address indexed sender,
        address indexed recipient,
        uint amount
    );
    event Deposit(address indexed recipient, uint amount);
    event Withdrawal(address indexed sender, uint amount);

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    constructor(IERC20 token) {
        underlyingToken = token;
        name = string(abi.encodePacked(token.name(), " extension"));
        symbol = string(abi.encodePacked(token.symbol(), "X"));
        decimals = token.decimals();
        owner = msg.sender;
    }

    function deposit(uint256 amount) public {
        require(
            underlyingToken.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        uint balance = balanceOf[msg.sender];
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        // notifiy plugins
        for (uint i = 0; i < plugins.length; i++) {
            plugins[i].afterDeposit(msg.sender, amount);
        }
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        uint balance = balanceOf[msg.sender];
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        require(
            underlyingToken.transfer(msg.sender, amount),
            "Transfer failed"
        );
        // notifiy plugins
        for (uint i = 0; i < plugins.length; i++) {
            plugins[i].afterWithdraw(msg.sender, amount);
        }
        emit Withdrawal(msg.sender, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        // notifiy plugins
        for (uint i = 0; i < plugins.length; i++) {
            plugins[i].afterApprove(msg.sender, spender, amount);
        }
        Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address recipient, uint amount) public returns (bool) {
        return transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) public returns (bool) {
        require(balanceOf[sender] >= amount);
        if (sender != msg.sender && allowance[sender][msg.sender] != uint(-1)) {
            require(allowance[sender][msg.sender] >= amount);
            allowance[sender][msg.sender] -= amount;
        }

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        // notifiy plugins
        for (uint i = 0; i < plugins.length; i++) {
            plugins[i].afterTransfer(sender, recipient, amount);
        }
        Transfer(sender, recipient, amount);
        return true;
    }

    function exCallback(address addr, int256 amount) public override {
        require(msg.sender == address(underlyingToken), "Invalid caller");
        if (amount > 0) {
            balanceOf[addr] += uint(amount);
            totalSupply += uint(amount);
        } else {
            require(balanceOf[addr] >= uint(-amount), "Insufficient balance");
            balanceOf[addr] -= uint(-amount);
            totalSupply -= uint(-amount);
        }
    }
}
