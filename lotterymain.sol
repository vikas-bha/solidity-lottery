//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0<0.9.0;

contract lottery{
    address public manager;
    address payable[] public participants;// participants are going to send ether thus they are payable
    // manager is going to be a crucial and the mos important varaible
    
    constructor(){
        manager = msg.sender;
        // global varaible and the account which initiates the smart contract
        
    }
    receive () external payable{// receive funtion can be used only one time , external is compulsory to use with it , a special function to transfer some ether i contract
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
        // sender's or participant's address will be added to the array
    }
    function getBalance() public view returns(uint){// only maneger should access this function 
        require(msg.sender==manager);
        return address(this).balance;
    }
    
    function random() public view returns(uint){
      return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp, participants.length)));
      // this is not a desired practice to use this particular function in case you or a developer need to have a random function in his or her contract
      // this is an another way to create a random function learnt from gfg
      //  return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
    }
    
    // simply to get the index of the array 
    function selectWinner()  public{
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r%participants.length;
        // it's a basic programming observation that the answer of a % b is always going to be less than b 
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}