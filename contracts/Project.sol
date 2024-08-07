// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Project {

string public campaignName;
address public creator;
string public description;
uint256 public goalAmount;
uint256 public deadline;
uint256 public currentAmount;
enum ProjectState { Ongoing, Successful, Failed }
ProjectState public state;
struct Donation { address donor; uint256 amount; }
Donation[] public donations;


event DonationReceived(address indexed donor, uint256 amount);
event ProjectStateChanged(ProjectState newState);
event FundsWithdrawn(address indexed creator, uint256 amount);
event FundsRefunded(address indexed donor, uint256 amount);




    function initialize( address public _creator, string _campaignName, uint256 _goalAmount, uint256 _deadline, string _description) public {

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
        donations.push(Donation({
            donor: msg.sender,
            amount: msg.value}));

        emit DonationReceived(msg.sender, msg.value);

    }

    function withdrawFunds() external onlyCreator onlyAfterDeadline {

        required(state == ProjectState.Successful);

        address payable recipient = payable(creator);
        creator.transfer(currentAmount);

        emit FundsWithdrawn(creator, currentAmount);
    }

    function refund() external onlyAfterDeadline{

        required(state == ProjectState.Failed, "can't refund");

        for(uint i = 0; i < donations.length; i++){

            if(donations[i].donor = msg.sender){

                donor.transfer(donations[i].amount);

                return;
            }
        }

    }


    function updateProjectState() external onlyAfterDeadline{


        if(currentAmount >= goalAmount){

            state = ProjectState.Successful;
        }else{

            state = ProjectState.Failed;
        }
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
