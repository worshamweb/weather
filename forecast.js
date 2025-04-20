/*
Uses Google place picker to get zip code  then uses that to search for weather conditions based on zip code.
 */
$(document).ready(function () {
  const placePicker = $('gmpx-place-picker');
  placePicker.on("gmpx-placechange", () => {
    const place = placePicker?.val();
    if (place) {
      let postal_code = null;

      const field = $.grep(place?.addressComponents, (component) => {
        return component?.types?.includes('postal_code');
      });

      if (field && field.length > 0) {
        postal_code = field[0]?.shortText;
      }

      if (postal_code) {
        getWeatherForecast(postal_code);
      } else {
        // unable to find a zip code. show error.
        noMatchError();
      }
    } else {
      // empty submit. show error.
      noMatchError();
    }
  });

  // Bind listeners for setting temperature preferences
  $('.dropdown-menu button.dropdown-item').on('click', (event) => {
    event.preventDefault();
    const temperatureSettings = $(event.target).data('value'); // Get temp display preference
    setTemperatureSettings(temperatureSettings, event);
  });

});

function getWeatherForecast(postal_code) {
  showLoading();

  $.ajax({
    url: "/search",
    method: 'GET',
    data: {
      zip_code: postal_code,
    },
    dataType: 'script',
    success: (response) => {
      // Nothing to do here. Rails will re-render UI with weather data
    },
    error: (response) => {
      noMatchError();
    }

  });
}

// DropDown menu for temperature settings. Save preference in local storage.
function setTemperatureSettings(temperatureSettings, event) {
  $('.temp-preference').hide(); // Hide elements that contain values in imperial and metric
  $(`.${temperatureSettings}`).show(); // Show only the relevant ones

  // Set current menu choice as active
  $('.temp-settings').removeClass('active');
  $(event.target).addClass('active');

  // Persist preference in local storage
  localStorage.setItem('temperatureSettings', temperatureSettings);
}

// No Zip code Match. Do not waste ajax call. show error message.
function noMatchError() {
  // Show error message. Hide all other elements
  $('#current-conditions-location').children().hide();
  $("#current-conditions-row").children().hide();
  $("#forecast-row").children().hide();
  $("#gmpx-no-match-error").removeClass('d-none').show();
}

// Show loading indicator while querying weather api
function showLoading() {
  // Show loading indioator. Hide all other elements
  $('#current-conditions-location').children().hide();
  $("#current-conditions-row").children().hide();
  $("#forecast-row").children().hide();
  $("#loading-spinner").removeClass('d-none').show();
}
