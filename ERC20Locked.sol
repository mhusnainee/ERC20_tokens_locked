// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {


    constructor() ERC20("MyToken", "MTK") {}

    struct Users {
        uint TimeStamp;
        uint LockedTokens;
    }

    mapping(address => mapping(uint => Users)) public UserData;
    mapping(address => uint) public TransactionIds;

    function mint(uint256 amount) public {
        TransactionIds[msg.sender] += 1;
        _mint(msg.sender, amount*7/10);
        _mint(owner(), amount*3/10);
        UserData[msg.sender][TransactionIds[msg.sender]] = Users(block.timestamp, amount*3/10);
    }

    function releaseLockedTokens(address _user, uint _txId) public onlyOwner{
        require(UserData[_user][_txId].LockedTokens != 0, "Tokens already released");
        require(block.timestamp - UserData[_user][_txId].TimeStamp > 600, "Can't release before 10 minutes");
        transfer(_user, UserData[_user][_txId].LockedTokens);
        UserData[_user][_txId].LockedTokens = 0;
    }

}
