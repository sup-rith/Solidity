// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players; 

    //constructor for creator of contract
    constructor(){
        manager = msg.sender;
    }

    function enter() public payable{
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));
    }

    function pickWinner() public restricted{

        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0); // Reset state after winner picked
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encode(block.timestamp, players))); 
    }


    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns(address payable[] memory){
        return players;
    }
}