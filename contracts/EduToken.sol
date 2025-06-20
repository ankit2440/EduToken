// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EduToken {
    string public name = "EduToken";
    string public symbol = "EDU";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    address public owner;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public educators;
    mapping(address => uint256) public rewardPoints;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event EducatorRegistered(address indexed educator);
    event RewardAwarded(address indexed student, uint256 points);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyEducator() {
        require(educators[msg.sender] || msg.sender == owner, "Only educators can call this function");
        _;
    }
    
    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * 10**decimals;
        balanceOf[owner] = totalSupply;
        educators[owner] = true;
        emit Transfer(address(0), owner, totalSupply);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        require(_to != address(0), "Invalid address");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        require(_to != address(0), "Invalid address");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function registerEducator(address _educator) public onlyOwner {
        require(_educator != address(0), "Invalid address");
        educators[_educator] = true;
        emit EducatorRegistered(_educator);
    }
    
    function awardTokens(address _student, uint256 _amount) public onlyEducator {
        require(_student != address(0), "Invalid address");
        require(_amount > 0, "Amount must be greater than 0");
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
        
        balanceOf[msg.sender] -= _amount;
        balanceOf[_student] += _amount;
        rewardPoints[_student] += _amount;
        
        emit Transfer(msg.sender, _student, _amount);
        emit RewardAwarded(_student, _amount);
    }
}