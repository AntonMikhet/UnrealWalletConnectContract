// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract changeMoney {  
    address public owner;
    uint public conversionFactor = 314;
    uint public usersCount;

    enum EuserStatus { 
        commonUser,
        ownerContract 
        } 

    struct userData{
        address userWallet;
        uint userId;
        string userNick;
        uint userMoneyAmount;
        EuserStatus userStatus;
        uint userRegistrationTime;        
        
    }
    mapping(address => userData) public users;
   
    modifier onlyOwner {  // создание модификатора onlyOwner
      require(users[msg.sender].userStatus == EuserStatus.ownerContract, "you not a owner"); // условный оператор владельца
      _; // продолжения выполнения тела функции
    }
    

    constructor() {
        addUserToContract("ADMIN", 99999999);
        changeUserStatus(msg.sender, EuserStatus.ownerContract);
        owner = msg.sender;
    }

    function addUserToContract(string memory _nick, uint _startmoney) public {
        require(msg.sender != users[msg.sender].userWallet, 'you are already registered');
        usersCount++;

        users[msg.sender].userWallet = msg.sender;
        users[msg.sender].userNick = _nick;
        users[msg.sender].userId = usersCount;
        users[msg.sender].userMoneyAmount = _startmoney;
        users[msg.sender].userStatus = EuserStatus.commonUser;
        users[msg.sender].userRegistrationTime = block.timestamp;
    }




    function getMoneyToConvertation () public payable {
            // require(msg.sender == 0, "your address is not valid");
            sendToDB(msg.sender, convertationToGameMoney(msg.value), users[msg.sender].userNick );

    }

    function convertationToGameMoney (uint _value) internal returns(uint) {
        value = _value *(conversionFactor / 100);
        return value;
    }

    function sendToDB (address _sender, uint value, string memory _nick) internal{
        users[_sender].userMoneyAmount = value;
        users[_sender].userNick = _nick;
    }

    function changeUserStatus (address _user, EuserStatus _value) public{
        users[_user].userStatus = _value;
    }
}
    