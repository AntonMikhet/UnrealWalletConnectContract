// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract gameDB{
    address public owner;
    uint public usersCount;
    uint public gameTransId;
    transactionData[] public gameTransaction;

    enum EuserStatus {  // Announcement of user status, with the status of contractOwner, the user has access to the functions of interaction with the smart contract tokens
        commonUser,
        ownerContract 
        } 

    struct userData{  // The main data structure of the user, which stores the main information about him
        address     userWallet;
        uint        userId;
        string      userNick;
        uint        userMoneyAmount;
        EuserStatus userStatus;
        uint        userRegistrationTime;        
        
    }
    mapping(address => userData) public users;

    struct transactionData {
        uint    gameTransId;
        address gameTransSender;
        address gameTransResiever;
        uint    gameTransTimeStamp;
        uint    gameTransAmount;
        bool    gameTransStatus;
    }
    mapping(address => transactionData[]) public transactionDB;

    mapping(address => mapping(uint256 => transactionData)) public trans;
    mapping(address => uint256) public tr_count;

    function getAllTransactionData() public view returns (transactionData[] memory){
        transactionData[] memory transit;

        for(uint256 i = 0; i < tr_count[msg.sender]; i++){
            transit[i] = trans[msg.sender][i];
        }
        
        return transit;
    }


    function addUserToContract(string memory _nick, uint _startmoney) public {  // Function to add a user to the blockchain database
        require(msg.sender != users[msg.sender].userWallet, 'you are already registered');
        usersCount++;

        users[msg.sender].userWallet = msg.sender;
        users[msg.sender].userNick = _nick;
        users[msg.sender].userId = usersCount;
        users[msg.sender].userMoneyAmount = _startmoney;
        users[msg.sender].userStatus = EuserStatus.commonUser;
        users[msg.sender].userRegistrationTime = block.timestamp;
    }


    function inGameTransaction (address _reciever, uint _value, string memory _description) public{
        require(users[msg.sender].userMoneyAmount - _value >= 0, "You havent game money");
        require(users[_reciever].userWallet != address(0), "This account does not exist");
        require(_value > 0, "Incorrect amount");

        users[msg.sender].userMoneyAmount - _value;
        _value = users[_reciever].userMoneyAmount + _value;
        gameTransId++;

        transactionDB[msg.sender].push(transactionData(
            gameTransId,
            msg.sender,
            _reciever,
            block.timestamp,
            _value,
            true
        ));

        sendToDB(_reciever, _value, users[_reciever].userNick);
    }

    function sendToDB (address _sender, uint _value, string memory _nick) internal{  // Function for sending data to the Blockchain database
        users[_sender].userMoneyAmount = _value;
        users[_sender].userNick = _nick;
    }

    function changeUserStatus (address _user, EuserStatus _value) public{  // Function for adding commonUser/contractOwner status to a certain user
        users[_user].userStatus = _value;
    }


    function getMyGameBalance() public view returns(uint){
       return users[msg.sender].userMoneyAmount;
    }
    
    function getOtherGameBalance(address _otherwallet) public view returns(uint) {
        return users[_otherwallet].userMoneyAmount;
    }

}