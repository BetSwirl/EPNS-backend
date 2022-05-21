// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

import "../interfaces/IEPNSComV1.sol";

contract Notifier is Initializable, Ownable, KeeperCompatibleInterface {
    address public constant EPNS_COMM_ADDRESS=0x87da9Af1899ad477C67FeA31ce89c1d2435c77DC;
    string[] notificationCIDS;
    uint256 public immutable interval = 5 minutes;
    uint256 public lastTimeStamp;
    uint8 public cid;

    function initialize() public initializer {
        uint length = notificationCIDS.length;
        if (length < 1) {
            // 10 matic message
            notificationCIDS.push("QmPV3mMQCKYf9127mtpq1gftVw3tEdn3khptvWCFYH1tGq");
        }
        if (length < 2) {
            // 50 matic message
            notificationCIDS.push("QmPjn7bdPHj5w3V9tHxhJ3iAJx1wBmpc8VBRxwyJMpmXgo");
        }
        if (length < 3) {
            // 100 matic message
            notificationCIDS.push("QmRLgBPQ3vFcNty1QRxNia9mmSU6JBb9AFuKwyfhkErCZd");
        }
        lastTimeStamp = block.timestamp;
        cid = 0;
    }

    function identity(uint256 _id) public view returns(bytes memory) {
        // 3: targeted notification
        return abi.encodePacked("3", "+", notificationCIDS[_id]);
    }

    function send(address _channel, address _recipient, uint256 _id) public {
        bytes memory _identity = identity(_id);
        IEPNSComV1(EPNS_COMM_ADDRESS).sendNotification(_channel, _recipient, _identity);
    }

    function checkUpkeep(bytes calldata checkData) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        performData = checkData;
    }

    function performUpkeep(bytes calldata performData) external override {
        address channel;
        address recipient;
        bool upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        require(upkeepNeeded);
        lastTimeStamp = block.timestamp;
        (channel, recipient) = abi.decode(performData, (address, address));
        send(channel, recipient, cid);
        // update cid
        cid = cid + 1;
        cid = cid % (uint8)(notificationCIDS.length);
    }
}