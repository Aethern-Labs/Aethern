// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

contract AETH is ERC20Upgradeable, ERC20PermitUpgradeable, AccessControlUpgradeable, UUPSUpgradeable, PausableUpgradeable {
    bytes32 public constant GOVERNOR_ROLE = keccak256("GOVERNOR_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function initialize(address governor, uint256 initialSupply) public initializer {
        __ERC20_init("Aethern Token", "AETH");
        __ERC20Permit_init("Aethern Token");
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __Pausable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, governor);
        _setupRole(GOVERNOR_ROLE, governor);
        _mint(governor, initialSupply);
    }

    function _authorizeUpgrade(address) internal override onlyRole(GOVERNOR_ROLE) {}

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function pause() external onlyRole(GOVERNOR_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(GOVERNOR_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20Upgradeable) whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }
}
