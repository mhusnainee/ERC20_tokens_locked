// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {


    constructor() ERC20("MyToken", "MTK") {}

    mapping(address => uint) private depositTimes;
    mapping(address => uint) private mintedTokens;

    function mint(uint256 amount) public {

        _mint(msg.sender, amount - (amount*3/10));
        depositTimes[msg.sender] = block.timestamp;
        mintedTokens[msg.sender] = amount;
    }

    function claim() public{
        require(block.timestamp - depositTimes[msg.sender] >= 10, "Can't claim before 10 minutes");
        _mint(msg.sender, mintedTokens[msg.sender]*3/10);
    }

}
