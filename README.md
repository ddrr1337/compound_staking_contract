# Staking and Rewards Contract

# WARNING, THIS CONTRACT IS NOT AUDITED AND TESTED YET!!

This contract allows users to stake tokens and receive rewards in a specific token for a certain period of time, or an infinite time. Rewards are calculated proportionally to time and total staked, using a defined interest rate.

This is a fork of **Alberto Cuesta Cañada's** staking contract: [SimpleRewards.sol](https://github.com/alcueca/staking/blob/main/src/SimpleRewards.sol).

In this version, a fixed number of tokens per second is no longer used as a reward. Instead, this version focuses on rewarding stakers with a % of the totalSupply. The number of tokens distributed as a reward is recalculated as the totalSupply increases with the minting of new tokens. In summary, this contract applies compound interest to the totalSupply to determine what the totalSupply will be after a certain number of seconds.

Example:
If we decide, for example, that the contract should distribute 5% of the totalSupply as rewards every year, then right after deploying the contract, 5% of the supply divided by the seconds in a year will be X. However, after a certain amount of time, X will be recalculated taking into account that the compound interest of the totalSupply has increased, so rewards will be distributed as X+n.

In summary, this implementation focuses on (taking the previous example) distributing the 5% at all times regardless of whether the totalSupply has increased as a result of reward minting.

## Significant Changes Compared to the Original Contract

## 1.- Constructor:

In this version, it is no longer necessary to pass `totalRewards` to the constructor for it to calculate rewardsRate. On the contrary, it is necessary to pass rate of interest so that the `_customRewardsPerSecond` function can calculate at all times how many tokens will be rewarded per second.
This input to the constructor will be passed in RAY. Below you can see how to calculate this number to pass it to the constructor (following the previous example where 5% is distributed).

- Effective Rate Per Second = 0.05 / (365 days/yr _ 86400 sec/day) = 1.5854895991882 _ 10 \*\* -9
- The value we want to send to this function is
- 1 _ 10 \*\* 27 + Effective Rate Per Second _ 10 \*\* 27

Below are examples of Python and JS for calculating the interest to be passed to the constructor:

Python:

```
def annual_rate(rate):
    a_rate = (1 * 10**27) + (rate / (365 * 86400)) * (10**27)
    print(int(a_rate))

annual_rate(0.05)

```

JS:

```
function annualRate(rate) {
    const aRate = (1 * 10 ** 27) + (rate / (365 * 86400)) * (10 ** 27);
    console.log(Math.floor(aRate));
}

annualRate(0.05);

```

Additionally, the contract has been modified to be able to pass `rewardsEnd_` with an end date for the token distribution, or alternatively pass `rewardsEnd_ = 0` for the token reward process to have no end.

## 2.-Minting Reward Tokens and Usage Considerations

Since the contract no longer holds the reward tokens it will distribute, the `_claim` function has been modified so that instead of transferring the tokens, it will mint them by calling a `mint` function of the ERC20 rewardsToken contract.

This has important implications:

Your ERC20 contract rewardsToken MUST have a `mint` function that can only be called by this staking contract. This repository provides a basic implementation of an ERC20 **RewardsToken.sol** with a mint function. This implies some considerations at the deployment stage:

- Deploy the ERC20 token rewardsToken.

- If necessary, provide liquidity to a Uniswap V2 contract (this is only necessary if you want the resulting LP token from providing liquidity to be the stakingToken you want to reward).

- Deploy this contract, passing both instances of both ERC20s to the constructor.

- Use the setAllowedMinter function of the ERC20 rewardsToken contract to link the ERC20 with this staking contract.

Once linked, this contract will have the necessary permission to mint reward tokens to users who stake.

- Care should be taken when using non-standard ERC20 tokens as compatibility issues may arise.

## Key Features

- **Stake and Unstake**: Users can stake and unstake tokens at any time.
- **Claim Rewards**: Users can claim accumulated rewards at any time.
- **Reward Updates**: Rewards are periodically updated based on the amount of tokens staked, the time elapsed, and the calculation of totalSupply.
- **Rewards Query**: Users can query the current rewards per token and for a specific user.

## Libraries and Dependencies

The contract uses various libraries and dependencies for its operation, including:

- `ERC20`: Standard contract for ERC20 tokens.
- `SafeTransferLib`: Library for secure token transfers.
- `RewardsToken`: Contract of the token used as a reward.
- `CompoundInterestLib`: Library for compound interest calculations.
- `CastU128`: Library for secure conversion of `uint256` to `uint128`. (save gas)

## Customizations

The contract allows customization of certain aspects of the rewards program, including:

- **Interest Rate**: Allows specifying an interest rate for the calculation of rewards.
- **Program Duration**: Allows defining the start and end time of the rewards program. (pass 0 if you want never ending rewards)
