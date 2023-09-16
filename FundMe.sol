//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./PriceConvertor.sol";

//It is for testing purposes only. Use Sepolia Ethereum or any other testnet coins.

contract FundMe{
  using PriceConvertor for uint256;
  uint256 minimiumUSD = 50 * 1e18; //At least 0.37 Sepolia ETH must me funded to this contract by others. 0.37 ETH = $50 @ 1ETH = $1636.80
  address[] public funders; //funders will store the list of addresses that funded you;
  mapping(address=>uint256) public addressToAmountFunded; //addressToAmountFunded maps addresses of the donors to their donations
  address public owner;

  constructo(){
    owner = msg.sender;
    }
  function fund() public payable{
    //Want others to donate money using this contract
    //1. How do we send ETH to this contract?

    require(msg.value.getConversionRate() >= minimumUSD,"DID NOT SEND ENOUGH"); //Donors at least need to send this contract a value of 50 dollars.
    funders.push(msg.sender); //funders array stores the first address of the donor
    addresstoAmountFunded[msg.sender]+=msg.value;//Maps the senders address to sender's amount and stores it to addresstoAmountFunded
    }

  function withdraw() public onlyOwner{
    //for loop
    //for(initial value;final value condition;step amount)
    for(uint256 funderIndex = 0; funderIndex <= funders.length;funderIndex++){
      address funder = funders[funderIndex];
      addresstoAmountFunded[funder] = 0;

      //rest the array
      funders = new address[](0);

      //actually withdraw money from the contract
      //transfer
      //payable(msg.sender).transfer(address(this).balance);

      //send
      //bool sendSuccess = payable(msg.sender).send(address(this).balance);
      //require(sendSuccess, "Send Failed");

      //call
      (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
      require(callSuccess , "Call Failed");
}

modifier onlyOwner{
  require(msg.sender == owner , "Not the owner");
  }

}    
