ready(() => {
  const CONTAINER_ID = "map";
  const LEAFLET_MAP_URL = (
    "//api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}" +
    "?access_token={accessToken}"
  );
  const LEAFLET_STYLE_ID = "streets-v12";
  const LEAFLET_DEFAULT_COORDS = {lat: 0, lng: 0};
  const LEAFLET_DEFAULT_ZOOM = 3;
  const LEAFLET_MAX_ZOOM = 18;
  const MAPBOX_ACCESS_TOKEN = (
    "pk.eyJ1IjoiamF6YSIsImEiOiJjbHdjdzRzNGwwN2h" +
    "qMmlwaHlnbnd3dTIyIn0.HYukMJILRBnI9X_6jU3eyw"
  );
  const LEAFLET_MAP_ATTRIBUTION = (
    'Map data &copy; ' +
    '<a href="https://www.openstreetmap.org/">OpenStreetMap</a> ' +
    'contributors, ' +
    '<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
    'Imagery &copy; <a href="https://www.mapbox.com/">Mapbox</a>, ' +
    'Source <a href="https://github.com/Jaza/bip39-cities-wordlist">code on GitHub</a>'
  );
  const CSV_URL_PREFIX = (
    "https://raw.githubusercontent.com/Jaza/bip39-cities-wordlist/master/csv/"
  );

  const CITIES_CSV_FILENAME = "cities.csv";

  let map = null;
  let nodes = null;
  let nodeLatsLons = null;

  const getCsvUrlPrefix = () => {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const csvUrlPrefix = urlParams.get("csv_url_prefix");

    return csvUrlPrefix || CSV_URL_PREFIX;
  };

  const loadNodesFromFile = (results) => {
    while (results.length) {
      const result = results.pop();

      if (!nodes) {
        nodes = L.layerGroup();
      }

      if (!nodeLatsLons) {
        nodeLatsLons = {};
      }

      const name = result.name;

      if (result.lat && result.lon) {
        const latLon = {lat: result.lat, lng: result.lon};
        nodeLatsLons[name] = latLon;

        const marker = L.marker(latLon);
        marker.bindPopup(
          `<strong>${result.name}</strong><br>` +
          `Region: ${result.region}<br>` +
          `Population: ${parseInt(result.population).toLocaleString()}`
        );
        nodes.addLayer(marker);
      }
    }

    nodes.addTo(map);
  };

  const loadNodesFromUrl = (url) => {
    Papa.parse(
      url,
      {
        download: true,
        header: true,
        dynamicTyping: true,
        skipEmptyLines: 'greedy',
        complete: (results) => {
          if (!results.data.length) {
            console.log('Warning: nodes file is empty, not loading nodes');
            return;
          }

          loadNodesFromFile(results.data);
        }
      }
    );
  };

  const initMap = (containerId) => {
    map = L.map(containerId).setView(LEAFLET_DEFAULT_COORDS, LEAFLET_DEFAULT_ZOOM);

    const defaultStyle = L.tileLayer(LEAFLET_MAP_URL, {
      attribution: LEAFLET_MAP_ATTRIBUTION,
      maxZoom: LEAFLET_MAX_ZOOM,
      id: LEAFLET_STYLE_ID,
      accessToken: MAPBOX_ACCESS_TOKEN,
      tileSize: 512,
      zoomOffset: -1
    });

    map.addLayer(defaultStyle);
  };

  const init = () => {
    const containerEl = document.getElementById(CONTAINER_ID);
    if (containerEl) {
      initMap(CONTAINER_ID);

      const url = `${getCsvUrlPrefix()}${CITIES_CSV_FILENAME}`;
      loadNodesFromUrl(url);
    }
  };

  init();
});
