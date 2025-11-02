// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Simplified staking skeleton to integrate AdaptScore oracle.
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is ReentrancyGuard, Ownable {
    IERC20 public aeth;
    uint256 public totalStaked;

    struct Stake {
        uint256 amount;
        uint256 rewardDebt;
        uint256 since;
    }

    mapping(address => Stake) public stakes;

    // AdaptScore oracle address (trusted writers)
    address public adaptOracle;

    event Staked(address indexed who, uint256 amount);
    event Unstaked(address indexed who, uint256 amount);
    event RewardsClaimed(address indexed who, uint256 amount);

    constructor(address _aeth) {
        aeth = IERC20(_aeth);
    }

    function setAdaptOracle(address oracle) external onlyOwner {
        adaptOracle = oracle;
    }

    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "zero");
        aeth.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender].amount += amount;
        stakes[msg.sender].since = block.timestamp;
        totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(stakes[msg.sender].amount >= amount, "insufficient");
        stakes[msg.sender].amount -= amount;
        totalStaked -= amount;
        aeth.transfer(msg.sender, amount);
        emit Unstaked(msg.sender, amount);
    }

    // Placeholder: claim rewards would calculate using AdaptScore snapshots
    function claimRewards() external {
        // implement reward calculation using AdaptScore
        emit RewardsClaimed(msg.sender, 0);
    }

    // Admin function for testing: emergency withdraw tokens from contract
    function rescueTokens(address token, address to, uint256 amount) external onlyOwner {
        IERC20(token).transfer(to, amount);
    }
}
