var express = require('express');
var execSync = require('child_process').execSync;
var bodyParser = require('body-parser'); 

var app = express();
app.use(bodyParser.json());

app.post('/calc_position', function (req, res) {
  let params = req.body;

  let args_string   = `${params["emitters"][0]["rssi"]} `;
  args_string       += `${params["emitters"][1]["rssi"]} `;
  args_string       += `${params["emitters"][2]["rssi"]} `;
  args_string       += `${params["emitters"][0]["x"]} `; 
  args_string       += `${params["emitters"][0]["y"]} `;
  args_string       += `${params["emitters"][1]["x"]} `; 
  args_string       += `${params["emitters"][1]["y"]} `;
  args_string       += `${params["emitters"][2]["x"]} `; 
  args_string       += `${params["emitters"][2]["y"]} `;

  let command = `/src/bosquebin ${args_string}`;
  let result = execSync(command);
  res.send(result)
})

var server = app.listen(8081, function () {
   console.log("Running")
})