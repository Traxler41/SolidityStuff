//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage
{
    uint myFavoriteNumber;  //FavoriteNumber gets initialized by 0 if not assigned with a value

    struct Person
    {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public listOfPeople; //A dynamic array named listOfPeople is created
    mapping(string=>uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public  //Updates the Value of myFavoriteNumber
    {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256)   //Returns the updated myFavoriteNumber
    {
        return myFavoriteNumber;
    }
    function addPerson(string memory _name, uint256 _favoriteNumber) public
    {
        listOfPeople.push(Person(_favoriteNumber,_name));
        nameToFavoriteNumber[_name] = _favoriteNumber; 
    }

}
