//SPDX-License-Identifier: UNILCENSED
pragma solidity ^0.6.0;

contract SimpleStorage {

    //This will get initialized to 0
    uint256 favoriteNumber;

    struct People {
        //Creates a struct of people with their favorite number, and name
        uint256 favoriteNumber;
        string name;
    }

    //creates an array mapping where a name points to a number
    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    //Stores the number as a uint256 variable named favoriteNumber
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    //retrieves the saved favoriteNumber
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    //Saves the name and number in the people struct, and in the array mapping
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
