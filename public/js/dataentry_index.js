/*
 * Javascript file for controller dataentry/index.html.erb
 */


var remainingTime = 0;
var startTime = 0;
var activeTimeout = null;
var validCities = [
  "Abbotsford",
  "Armstrong",
  "Burnaby",
  "Campbell River",
  "Castlegar",
  "Chilliwack",
  "Colwood",
  "Coquitlam",
  "Courtenay",
  "Cranbrook",
  "Dawson Creek",
  "Duncan",
  "Enderby",
  "Fernie",
  "Fort St. John",
  "Grand Forks",
  "Greenwood",
  "Kamloops",
  "Kelowna",
  "Kimberley",
  "Langford",
  "Langley",
  "Maple Ridge",
  "Merritt",
  "Nanaimo",
  "Nelson",
  "New Westminster",
  "North Vancouver",
  "Parksville",
  "Penticton",
  "Pitt Meadows",
  "Port Alberni",
  "Port Coquitlam",
  "Port Moody",
  "Powell River",
  "Prince George",
  "Prince Rupert",
  "Quesnel",
  "Revelstoke",
  "Richmond",
  "Rossland",
  "Salmon Arm",
  "Surrey",
  "Terrace",
  "Trail",
  "Vancouver",
  "Vernon",
  "Victoria",
  "West Kelowna",
  "White Rock",
  "Williams Lake",
  "Central Saanich",
  "Chetwynd",
  "Clearwater",
  "Coldstream",
  "Delta",
  "Elkford",
  "Esquimalt",
  "Fort St. James",
  "Hope",
  "Houston",
  "Invermere",
  "Kitimat",
  "Lillooet",
  "Logan Lake",
  "Mackenzie",
  "Metchosin",
  "Mission",
  "North Cowichan",
  "North Saanich",
  "Oak Bay",
  "Peachland",
  "Sechelt",
  "Sicamous",
  "Sooke",
  "Stewart",
  "Summerland",
  "Taylor",
  "Tofino",
  "Ucluelet",
  "Vanderhoof",
  "Bowen Island",
  "Whistler",
  "Comox",
  "Creston",
  "Gibsons",
  "Golden",
  "Ladysmith",
  "Lake Cowichan",
  "Oliver",
  "Osoyoos",
  "Port McNeill",
  "Princeton",
  "Qualicum Beach",
  "Sidney",
  "Smithers",
  "Alert Bay",
  "Ashcroft",
  "Burns Lake",
  "Cache Creek",
  "Canal Flats",
  "Chase",
  "Clinton",
  "Cumberland",
  "Fruitvale",
  "Hazelton",
  "Kaslo",
  "Keremeos",
  "Lions Bay",
  "Lumby",
  "Lytton",
  "Masset",
  "McBride",
  "Midway",
  "Nakusp",
  "New Denver",
  "Pemberton",
  "Port Alice",
  "Port Clements",
  "Pouce Coupe",
  "Salmo",
  "Sayward",
  "Slocan",
  "Tahsis",
  "Valemount"
];

function disableSubmit() {
  document.getElementById("submit_input").disabled = true;
}

function enableSubmit() {
  document.getElementById("submit_input").disabled = false;
}

function changeCountdownDisplay() {

  if (activeTimeout != null)
    window.clearTimeout(activeTimeout);

  element = document.getElementById("countdown_h3");
  var relative = remainingTime - Math.floor(new Date() / 1000 - startTime);

  console.log("Relative: " + relative);

  if (relative < 0) {
    console.log("Now available");
    element.innerHTML = "Please enter your data!";
    document.getElementById("submit_input").disabled = false;
  }
  else {

    document.getElementById("submit_input").disabled = true;

    var hours = Math.floor(relative / (60 * 60));
    var minutes = Math.floor((relative / 60) % 60);
    var seconds = Math.floor(relative % 60);

    var timeText = "";
    if (hours > 0) {
      if (hours == 1)
        timeText += hours + " hour ";
      else
        timeText += hours + " hours ";
    }
    if (minutes > 0) {
      if (minutes == 1)
        timeText += minutes + " minute "
      else
        timeText += minutes + " minutes ";
    }
    if (seconds > 0) {
      if (seconds == 1)
        timeText += seconds + " second ";
      else
        timeText += seconds + " seconds ";
    }

    element.innerHTML = "You can enter more data after " + timeText;

    activeTimeout = setTimeout(function() { changeCountdownDisplay() }, 1000 );
  }


}

function cityIsValid(str) {
  for (var k = 0; k < validCities.length; k += 1) {
    if (validCities[k].toLowerCase() == str.toLowerCase())
      return true;
  }

  return false;
}


function resolveCityName(str) {
  var bestDistance = 10000; // pointlessly large number
  var bestCity = "Unknown";

  str = str.toLowerCase();

  for (var k = 0; k < validCities.length; k += 1) {

    var distance = levenshteinDistance(validCities[k].toLowerCase(), str);
    if (distance < bestDistance) {
      bestDistance = distance;
      bestCity = validCities[k];
    }

  }

  if (bestDistance > 6) {
    console.log("Failed to resolve \"" + str + "\" to city. Best match was \"" + bestCity + "\" (levenshtein distance: " + bestDistance + ")");
  }
  else {
    console.log("Resolved \"" + str + "\" to \"" + bestCity + "\" (levenshtein distance: " + bestDistance + ")")
    return bestCity;
  }
}

function isInteger(str) {

  if (str.length == 0)
    return false;

  if (parseInt(str) == NaN)
    return false;

  for (var k = 0; k < str.length; k++) {
    var chr = str.charAt(k);
    if (chr < '0' || chr > '9') {
      return false;
    }
  }

  return true;
}

function setError(str) {
  console.log("Setting error: \"" + str + "\"");

  document.getElementById("validate_error_h4").innerHTML = str;
  document.getElementById("message_banner_h2").innerHTML = "";
}

function setCityTo(str) {
  console.log("Set city to: \"" + str + "\"");

  var city = document.forms["submitForm"]["city"];
  city.value = str;

  enableSubmit();
}

function validateSubmitForm() {

  setError("");

  var ret = true;

  var city = document.forms["submitForm"]["city"];
  var mood = document.forms["submitForm"]["mood"];
  var sleep = document.forms["submitForm"]["sleep"];
  var exercise = document.forms["submitForm"]["exercise"];

  // CITY VALIDATION
  if (city.value == "") {
    if (ret)
      setError("City cannot be blank");
    city.style.backgroundColor = "pink";
    ret = false;
  }
  else if (!cityIsValid(city.value)) {
    if (ret) {
      var suggestedCityName = resolveCityName(city.value);
      if (suggestedCityName != null)
        setError("City provided is invalid. Did you mean: \"<a href=\"javascript: setCityTo('" + suggestedCityName + "')\">" + suggestedCityName + "</a>\"?");
      else
        setError("City provided is invalid. Couldn't even guess where you meant");
    }
    city.style.backgroundColor = "pink";
    ret = false;
  }
  else
    city.style.backgroundColor = "white";


  if (ret) {
    document.getElementById("message_banner_h2").innerHTML = "Sending data...";
  }

  return ret;

}

function textField_OnChange() {
  if (remainingTime == 0) {
    enableSubmit();
  }
}

function range_onInput(id, value)
{
  document.getElementById(id + "_span", value).innerHTML = value;
}

console.log("Finished loading dataentry_index.js");
