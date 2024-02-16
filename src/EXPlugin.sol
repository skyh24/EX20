// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ERC721} from "solmate/tokens/ERC721.sol";

interface IPlugin {
    function afterDeposit(address sender, uint256 amount) external;
    function afterWithdraw(address sender, uint256 amount) external;
    function afterTransfer(address sender, address recipient, uint256 amount) external;
    function afterApprove(address sender, address spender, uint256 amount) external;
}

contract EXPlugin is IPlugin, ERC721 {
  address public exToken;
  mapping (address => uint)  public  balanceOf;

  // Events
  event Deposit(address indexed recipient, uint amount);
  event Withdrawal(address indexed sender, uint amount);
  event Approval(address indexed sender, address indexed spender, uint amount);

  // Errors
    error NotFound();
    error AlreadyExists();
    error InvalidRecipient();
    error InvalidSender();
    error UnsafeRecipient();

  /// @dev Current mint counter, monotonically increasing to ensure accurate ownership
  uint256 public minted;

  constructor(address token, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    exToken = token;
  }

  function setExToken(address token) public {
    exToken = token;
  }

  function afterDeposit(address sender, uint256 amount) external override {
    balanceOf[sender] += amount;
    emit Deposit(sender, amount);
  }
  function afterWithdraw(address sender, uint256 amount) external override {
    balanceOf[sender] -= amount;
    emit Withdrawal(sender, amount);
  }
  function afterTransfer(address sender, address recipient, uint256 amount) external override {}
  function afterApprove(address sender, address spender, uint256 amount) external override {
    emit Approval(sender, spender, amount);
  }

  /// @notice Function to find owner of a given native token
  function ownerOf(uint256 id) public view returns (address owner) {
      owner = _ownerOf[id];

      if (owner == address(0)) {
          revert NotFound();
      }
  }

  function mintTo(address recipient) public returns (uint256) {
      uint256 newItemId = ++minted;
      _safeMint(recipient, newItemId);
      return newItemId;
  }

  /// @notice tokenURI must be implemented by child contract
  function tokenURI(uint256 id) public view virtual override returns (string memory) {
      return Strings.toString(id);
  }
}