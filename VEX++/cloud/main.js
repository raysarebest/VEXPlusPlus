Parse.Cloud.define("validateVEXID", validateVEXID);
function validateVEXID(request, response){
  //This should be a string, in a similar format to this: "2616F", or undefined
  var initialCheck = request.params.VEXID;
  var saving = request.body.VEXID;
  if(initialCheck){
    validate(initialCheck, response);
  }
  else if(saving){
    validate(saving, response);
  }
  else{
    response.error("Please provide a valid VEX ID");
  }
}
function validate(vexID, response){
  //Here we validate the VEX ID
  //last contains just the last charachter of the string
  var last = vexID.substring(vexID.length - 1);
  //numbers contains everything else
  var numbers = vexID.substring(0, vexID.length - 1);
  //Yay, regexes!
  var lastIsCapChar = /^[A-Z]+$/.test(last);
  var lastIsNumber = /^[0-9]+$/.test(last);
  var mostlyNumbers = /^[0-9]+$/.test(numbers);
  var allNumbers = /^[0-9]+$/.test(vexID);
  if(!mostlyNumbers){
    response.error("The first part of a VEX ID must consist solely of numbers");
    return;
  }
  if(!lastIsNumber && !lastIsCapChar){
    response.error("The last charachter of a VEX ID must be either a number or a capital letter");
    return;
  }
  //Enough of what could go wrong, now let's be picky and make sure stuff isn't wrong when the big stuff is right
  if(allNumbers && (vexID.length <= 0 || vexID.length > 4)){
    response.error("An all-number VEX ID must be between 1 and 4 characters long");
    return;
  }
  else if(vexID.length <= 0 || vexID.length > 5){
    response.error("A VEX ID must be between 1 and 5 characters long, and must consist of 1 or more letters and an optional capital letter at the end");
    return;
  }
  //If we magically make it this far, the VEX ID is in a valid format
  response.success();
}
