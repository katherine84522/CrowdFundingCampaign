// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Project {

enum ProjectState { Ongoing, Successful, Failed }

ProjectState public state;
string public campaignName;
address public creator;
string public description;
uint256 public goalAmount;
uint256 public deadline;
uint256 public currentAmount;


struct Donation { 
    bool refunded ; 
    uint256 amount; 
}

mapping(address => Donation) public donations;


event DonationReceived(address indexed donor, uint256 amount);
event ProjectStateChanged(ProjectState newState);
event FundsWithdrawn(address indexed creator, uint256 amount);
event FundsRefunded(address indexed donor, uint256 amount);




    function initialize( address _creator, string memory _campaignName, uint256 _goalAmount, uint256 _deadline, string memory _description) public {

        creator = _creator;
        campaignName = _campaignName;
        goalAmount = _goalAmount;
        deadline = _deadline;
        description = _description;
        currentAmount = 0;

        state = ProjectState.Ongoing;

    }

    function donate() external payable {

        currentAmount += msg.value;
        donations[msg.sender].amount += msg.value;
        donations[msg.sender].refunded = false;

        emit DonationReceived(address(msg.sender), msg.value);

    }

    function withdrawFunds() external onlyCreator onlyAfterDeadline {

        require(state == ProjectState.Successful);

        address payable recipient = payable(creator);
        recipient.transfer(currentAmount);

        emit FundsWithdrawn(address(creator), currentAmount);
    }

   function refund() public onlyAfterDeadline {
        require(state == ProjectState.Failed, "Cannot refund unless project failed");

        Donation storage donorDonation = donations[msg.sender];
        require(donorDonation.amount > 0, "No donations found for the sender");
        require(!donorDonation.refunded, "Donation already refunded");

        uint256 refundAmount = donorDonation.amount;
        donorDonation.amount = 0;
        donorDonation.refunded = true;

        payable(msg.sender).transfer(refundAmount);
    }


    function updateProjectState() external onlyAfterDeadline{


        if(currentAmount >= goalAmount){

            state = ProjectState.Successful;
        }else{

            state = ProjectState.Failed;
        }

        emit ProjectStateChanged(state);
    }



    modifier onlyCreator(){

        require(msg.sender == creator, "Not creator");
        _;

    }

    modifier onlyAfterDeadline(){

        require(block.timestamp > deadline, "Haven't reached the deadline");
        _;
    }



  
}
