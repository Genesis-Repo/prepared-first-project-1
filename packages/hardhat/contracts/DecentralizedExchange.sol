// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DecentralizedExchange {
    using SafeMath for uint256;

    address public admin;
    mapping(address => mapping(address => uint256)) public balances;

    event TokensDeposited(address indexed user, address indexed token, uint256 amount);
    event TokensWithdrawn(address indexed user, address indexed token, uint256 amount);
    event TokensSwapped(address indexed user, address indexed tokenFrom, address indexed tokenTo, uint256 amountFrom, uint256 amountTo);

    constructor() {
        admin = msg.sender;
    }

    function depositTokens(address token, uint256 amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender][token] = balances[msg.sender][token].add(amount);
        emit TokensDeposited(msg.sender, token, amount);
    }

    function withdrawTokens(address token, uint256 amount) external {
        require(balances[msg.sender][token] >= amount, "Insufficient balance");
        balances[msg.sender][token] = balances[msg.sender][token].sub(amount);
        IERC20(token).transfer(msg.sender, amount);
        emit TokensWithdrawn(msg.sender, token, amount);
    }

    function swapTokens(address tokenFrom, uint256 amountFrom, address tokenTo) external {
        require(balances[msg.sender][tokenFrom] >= amountFrom, "Insufficient balance");
        
        uint256 amountTo = amountFrom; // For simplicity, 1:1 swap
        balances[msg.sender][tokenFrom] = balances[msg.sender][tokenFrom].sub(amountFrom);
        balances[msg.sender][tokenTo] = balances[msg.sender][tokenTo].add(amountTo);

        emit TokensSwapped(msg.sender, tokenFrom, tokenTo, amountFrom, amountTo);
    }
}