pragma solidity ^0.8.24;

import "./Project.sol";

contract CrowdfundingPlatform {

    address[] public projects;
    event ProjectCreated(address projectAddress, address creator, string description, uint256 goalAmount, uint256 deadline);

    function initialize() public initializer;

    function createProject(address public _creator, string _campaignName, uint256 _goalAmount, uint256 _deadline, string _description) public{

        Project newProject = new Project();
        projects.push(address(newProject));
        newProject.initialize( _creator, _campaignName, _goalAmount, _deadline, _description);

        emit ProjectCreated(address(newProject), _creator, _description, _goalAmount, _deadline);
    }

    function getProjects() public view returns (address[] memory){

        return projects;
    }


}